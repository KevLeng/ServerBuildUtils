#!/bin/bash
# Script to install sockshop on k8s
echo "-----------------------------------------------------------------------"
echo "Install Sockshop"
echo "-----------------------------------------------------------------------"

SOCKSHOP_JENKINS_INSTALL=${SOCKSHOP_JENKINS_INSTALL:-"false"}
SOCKSHOP_REPO="https://github.com/KevLeng/sockshop"

echo "SOCKSHOP_REPO: $SOCKSHOP_REPO"
echo "SOCKSHOP_JENKINS_INSTALL: $SOCKSHOP_JENKINS_INSTALL"

git clone $SOCKSHOP_REPO
cd sockshop

./deploy-sockshop.sh

echo "Sockshop deployed."
export INGRESSCLASS=nginx
./deploy-ingress.sh

echo "Sockshop ingress deployed."



if [[ "$SOCKSHOP_JENKINS_INSTALL" == true ]]; then
    echo "Install Jenkins for Sockshop"
    ./deploy-jenkins.sh
fi



cd ..

chown -R $USER:$USER sockshop/

echo "-----------------------------------------------------------------------"
echo "Done installation of sockshop"
echo "-----------------------------------------------------------------------"