# maven-3-jdk-8-builder
# Here you can use whatever image base is relevant for your application.
FROM maven:3.3.9-jdk-8

# Here you can specify the maintainer for the image that you're building
MAINTAINER andrea.lambruschini@gmail.com

# Set the labels that are used for Openshift to describe the builder image.
LABEL io.k8s.description="Java Application Builder" \
    io.k8s.display-name="maven 3.3.9 jdk-8 builder" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,webserver,html,java" \
    # this label tells s2i where to find its mandatory scripts
    # (run, assemble, save-artifacts)
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

RUN apt-get update -qq && \
    apt-get install -yq gettext-base

RUN apt-get update -qq && \
 DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
 build-essential \
 ca-certificates \
 cmake \
 curl \
 git \
 make \
 libcurl4-openssl-dev \
 libffi-dev \
 libsqlite3-dev \
 libzmq3-dev \
 pandoc \
 python \
 python3 \
 python-dev \
 python3-dev \
 sqlite3 \
 texlive-fonts-recommended \
 texlive-latex-base \
 texlive-latex-extra \
 zlib1g-dev && \
 apt-get clean && \
 rm -rf /var/lib/apt/lists/*

RUN curl -SL -o nss_wrapper.tar.gz https://ftp.samba.org/pub/cwrap/nss_wrapper-1.1.2.tar.gz && \
 mkdir nss_wrapper && \
 tar -xC nss_wrapper --strip-components=1 -f nss_wrapper.tar.gz && \
 rm nss_wrapper.tar.gz && \
 mkdir nss_wrapper/obj && \
 (cd nss_wrapper/obj && \
 cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DLIB_SUFFIX=64 .. && \
 make && \
 make install) && \
 rm -rf nss_wrapper


RUN groupadd -r builder && useradd -r -g builder builder
USER builder

# Copy the S2I scripts to /usr/libexec/s2i since we set the label that way
COPY  .s2i/bin/ /usr/libexec/s2i/
COPY  scripts/entrypoint.sh /usr/libexec/entrypoint.sh
COPY  scripts/passwd.template ${HOME}/passwd.template

RUN chmod 777 /usr/libexec/entrypoint.sh

ENTRYPOINT "/usr/libexec/entrypoint.sh"

# Modify the usage script in your application dir to inform the user how to run
# this image.
CMD ["/usr/libexec/s2i/usage"]

