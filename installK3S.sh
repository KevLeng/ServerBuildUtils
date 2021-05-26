#!/bin/bash
# Script to install K3S on ubuntu
echo "***********************************************************************"
echo "Started installK3S.sh"
echo "***********************************************************************"

export K3S_VERSION=${K3S_VERSION:-"v1.21.1+k3s1"}


echo "-----------------------------------------------------------------------"
echo "Download and install K3S"
echo "-----------------------------------------------------------------------"
echo "Installing K3S Version: $K3S_VERSION"
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${K3S_VERSION} K3S_KUBECONFIG_MODE="644" sh -s - --no-deploy=traefik


echo "-----------------------------------------------------------------------"
echo "Set KUBECONFIG environment variable"
echo "-----------------------------------------------------------------------"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

if ! [ -x "$(command -v kubectl)" ]; then
  echo 'Error: kubectl must be installed and connected to your k8s cluster.' >&2
  exit 1
fi

echo "***********************************************************************"
echo "Finished installK3S.sh"
echo "***********************************************************************"