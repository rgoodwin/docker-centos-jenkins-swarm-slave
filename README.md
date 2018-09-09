# docker-centos-jenkins-swarm-slave

Docker container of Jenkins swarm slave running on Centos

This is configured to support builds of docker containers, and includes tools to help doing this at AWS, and on kubernetes. 
But it can also be used for general building of whatever is needed by installing more tools.

It is based on [CentOS](https://www.centos.org) to enable having a full os environment and toolchain, to support build steps such as binary compilation etc.

### Running

Note: By mounting the docker socket in the container the jenkins slave can run docker commands

Example: run the container and setup to take docker builds via a label

```docker run -v /var/run/docker.sock:/var/run/docker.sock -it rgoodwin/centos7.1-jenkins-swarm-slave:latest  -master http://<url to jenkins> -name jenkins-docker-slave -labels docker-build -mode exclusive```
```