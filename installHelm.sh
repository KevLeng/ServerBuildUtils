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

wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

# remove downloaded files
rm helm-${HELM_VERSION}-linux-amd64.tar.gz
rm -r linux-amd64

echo "***********************************************************************"
echo "Finished installHelm.sh"
echo "***********************************************************************"