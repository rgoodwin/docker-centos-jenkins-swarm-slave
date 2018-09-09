FROM centos:7.5.1804

MAINTAINER rgoodwin

## setup epel and install jdk
RUN yum -y install epel-release && yum update -y

RUN yum install -y java-1.8.0-openjdk

# Setup handy tools for building
#RUN yum install -y git && yum install -y python-pip && yum install -y gcc && yum install -y python-devel && yum install -y libffi-devel && yum install -y install openssl-devel
RUN yum install -y git && yum install -y gcc
RUN yum install -y python-pip && yum install -y python-devel && yum install -y libffi-devel && yum install -y install openssl-devel
RUN pip install ansible && pip install boto boto3 awscli httplib2

# install LTS release of nodejs
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - \
    && yum -y install nodejs

RUN yum install -y docker

ENV JENKINS_SWARM_CLIENT_VERSION 3.9
RUN curl --create-dirs -sSLo "/usr/share/jenkins/swarm-client-jar-with-dependencies.jar" \
    https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_CLIENT_VERSION/swarm-client-${JENKINS_SWARM_CLIENT_VERSION}.jar

ENTRYPOINT [ "java", "-Dfile.encoding=UTF8", "-jar", "/usr/share/jenkins/swarm-client-jar-with-dependencies.jar" ]
