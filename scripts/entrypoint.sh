export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
echo "maven-3-jdk-8-builder: entrypoint.sh: user id: ${USER_ID} - group id: ${GROUP_ID} "
#envsubst < ${HOME}/passwd.template > /tmp/passwd
#export LD_PRELOAD=/usr/local/lib64/libnss_wrapper.so
#export NSS_WRAPPER_PASSWD=/tmp/passwd
#export NSS_WRAPPER_GROUP=/etc/group

