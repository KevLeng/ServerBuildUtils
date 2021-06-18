#!/bin/bash
# Script to install Docker on ubuntu
echo "***********************************************************************"
echo "Started installDocker.sh"
echo "***********************************************************************"

export INSTALL_DOCKER=${INSTALL_DOCKER:-true}
export INSTALL_DOCKER_COMPOSE=${INSTALL_DOCKER_COMPOSE:-true}


if [[ "$INSTALL_DOCKER" == "true" ]]; then
    echo "Install Docker"
    apt install docker.io -y
fi

if [[ "$INSTALL_DOCKER_COMPOSE" == "true" ]]; then
    echo "Install Docker Compose"
    apt install docker-compose
fi


echo "***********************************************************************"
echo "Finished installDocker.sh"
echo "***********************************************************************"