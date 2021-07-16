#!/bin/bash
# Script to install Helm on ubuntu
echo "***********************************************************************"
echo "Started installHelm.sh"
echo "***********************************************************************"

export HELM_VERSION=${HELM_VERSION:-"v3.5.4"}

echo "-----------------------------------------------------------------------"
echo "Download and install helm"
echo "-----------------------------------------------------------------------"
echo "Installing Helm Version: $HELM_VERSION"

#wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
#tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz
#sudo mv linux-amd64/helm /usr/local/bin/helm

# remove downloaded files
#rm helm-${HELM_VERSION}-linux-amd64.tar.gz
#rm -r linux-amd64

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

rm get_helm.sh

echo "***********************************************************************"
echo "Finished installHelm.sh"
echo "***********************************************************************"