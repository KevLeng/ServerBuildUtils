#!/bin/bash
# Script to install sockshop on k8s
echo "-----------------------------------------------------------------------"
echo "Install Sockshop"
echo "-----------------------------------------------------------------------"
export USER=${USER:-"ubuntu"}

# Wrapper for runnig commands for the real owner and not as root
alias bashas="sudo -H -u ${USER} bash -c"

SOCKSHOP_REPO="https://github.com/KevLeng/sockshop"

bashas "git clone $SOCKSHOP_REPO"
cd sockshop

./deploy-sockshop.sh

echo "Sockshop deployed."
export INGRESSCLASS=nginx
./deploy-ingress.sh

echo "Sockshop ingress deployed."


echo "-----------------------------------------------------------------------"
echo "Done installation of sockshop"
echo "-----------------------------------------------------------------------"