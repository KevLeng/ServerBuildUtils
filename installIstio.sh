#!/bin/bash
# Script to install Istio on ubuntu
echo "***********************************************************************"
echo "Started installIstio.sh"
echo "***********************************************************************"

export ISTIO_VERSION=${ISTIO_VERSION:-"1.10.0"}

echo "-----------------------------------------------------------------------"
echo "Download and install istio"
echo "-----------------------------------------------------------------------"

echo "Installing Istio Version: $ISTIO_VERSION"

ISTIO_EXISTS=$(kubectl get po -n istio-system | grep Running | wc | awk '{ print $1 }')
if [[ "$ISTIO_EXISTS" -gt "0" ]]
then
  echo "Istio already installed on k8s"
else
  echo "Downloading and installing Istio ${ISTIO_VERSION}"
  curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -
  sudo mv istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/istioctl

  istioctl install -y
fi

echo "***********************************************************************"
echo "Finished installIstio.sh"
echo "***********************************************************************"