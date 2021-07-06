#!/bin/bash
# Script to install sockshop on k8s
echo "-----------------------------------------------------------------------"
echo "Install Sockshop"
echo "-----------------------------------------------------------------------"

SOCKSHOP_REPO="https://github.com/KevLeng/sockshop"

git clone $SOCKSHOP_REPO
cd sockshop

./deploy-sockshop.sh

echo "Sockshop deployed."
export INGRESSCLASS=nginx
./deploy-ingress.sh

echo "Sockshop ingress deployed."


echo "-----------------------------------------------------------------------"
echo "Done installation of sockshop"
echo "-----------------------------------------------------------------------"