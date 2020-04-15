#! /bin/bash
#Created by siddhesh rele email id:- sidluckie@gmail.com
#Creats docker containor of jenkins

JENKINS_PORT=8080
JENKINS_CONTAINER_NAME=jenkins
JENKINS_HOME=~/jenkins_home

mkdir $JENKINS_HOME

JenkinsContainerId=`docker ps -qa --filter "name=$JENKINS_CONTAINER_NAME"`
if [ -n "$JenkinsContainerId" ]
then
        echo "Stopping and removing existing jenkins container"
        docker stop $JENKINS_CONTAINER_NAME
        docker rm $JENKINS_CONTAINER_NAME
fi

echo "Starting jenkins container on port $JENKINS_PORT and jenkins home is $JENKINS_HOME"
# https://github.com/jenkinsci/docker
# https://hub.docker.com/r/jenkinsci/jenkins/tags/
# /var/jenkins_home contains all plugins and configuration
docker run -d --name $JENKINS_CONTAINER_NAME \
        --net=host \
        -p $JENKINS_PORT:8080 -p 50000:50000 \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $(which docker):/bin/docker \
        -v $JENKINS_HOME:/var/jenkins_home \
        -u root \
        jenkins/jenkins:latest

#alpine image jenkinsci/jenkins:alpine 
#alpine not used due to jenkins is outdated
#Install docker and other utility inside the server
#docker exec -it jenkins apk --update add git less docker
#Install require uitlity in jenkins containor

docker exec -it jenkins apt-get update
docker exec -it jenkins apt-get install -y libltdl7
