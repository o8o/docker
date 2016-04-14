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

# Copy the S2I scripts to /usr/libexec/s2i since we set the label that way
COPY  .s2i/bin/ /usr/libexec/s2i/

RUN mkdir -p /opt/app/src && \
    mkdir -p /opt/app/bin && \
    chown -R 1001:0 /opt/app && \
    chown -R 1001:0 $HOME && \
    chmod -R ug+rw /opt/app 

USER 1001

# Modify the usage script in your application dir to inform the user how to run
# this image.
CMD ["/usr/libexec/s2i/usage"]

