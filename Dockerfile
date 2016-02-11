#
# Version number is not in downloaded jar because ENTRYPOINT cannot interpolate strings
#
FROM centos:7.2.1511
MAINTAINER rgoodwin

# setup epel and install jdk
RUN yum -y install epel-release && yum update -y
RUN yum install -y wget && wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm
RUN rpm -ivh jdk-8u51-linux-x64.rpm && rm jdk-8u51-linux-x64.rpm

RUN yum install -y git
# RUN yum install -y ansible

RUN yum install -y python-pip && yum install -y gcc && yum install -y python-devel && pip install ansible


#   11  yum list *pip*
#   12  yum install python-pip
#   13  pip
#   14  pip install yolk
#   15  yolk -V ansible
#   16  pip install ansbile
#   17  pip install ansible
#
#   19  pip install ansible
#   20  yum list *python*
#   21  yum list *python*|grep dev
#
#   24  ansible --version
#   25  history

# install nodejs
# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 5.6.0

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc



# install docker
RUN curl -sSL https://get.docker.com/ | sh

ENV JENKINS_SWARM_CLIENT_VERSION 2.0
ENV JENKINS_DATA_DIRECTORY /var/lib/jenkins

RUN curl --create-dirs -sSLo "/usr/share/jenkins/swarm-client-jar-with-dependencies.jar" http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_CLIENT_VERSION/swarm-client-${JENKINS_SWARM_CLIENT_VERSION}-jar-with-dependencies.jar \
  && chmod 755 /usr/share/jenkins

WORKDIR $JENKINS_DATA_DIRECTORY

ENTRYPOINT [ "java", "-Dfile.encoding=UTF8", "-jar", "/usr/share/jenkins/swarm-client-jar-with-dependencies.jar" ]
