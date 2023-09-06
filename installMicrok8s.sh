#!/bin/bash
# Script to install Microk8s on ubuntu
echo "***********************************************************************"
echo "Started installMicrok8s.sh"
echo "***********************************************************************"

export MICROK8S_CHANNEL=${MICROK8S_CHANNEL:-"1.27/stable"}
export USER=${USER:-"ubuntu"}

# Wrapper for runnig commands for the real owner and not as root
# thanks to keptn-in-a-box for this script which i have copied most of the commands from!

alias bashas="sudo -H -u ${USER} bash -c"
# Expand aliases for non-interactive shell
shopt -s expand_aliases

echo "Installing microk8s version: $MICROK8S_CHANNEL"
sudo snap install microk8s --classic --channel=$MICROK8S_CHANNEL

echo "allowing the execution of priviledge pods"
bash -c "echo \"--allow-privileged=true\" >> /var/snap/microk8s/current/args/kube-apiserver"

echo "Enable microk8s for user. User is $USER"
usermod -a -G microk8s $USER

#iptables -P FORWARD ACCEPT
#ufw allow in on cni0 && sudo ufw allow out on cni0
#ufw default allow routed

echo "Enable alias microk8s.kubectl kubectl"
snap alias microk8s.kubectl kubectl
echo "Add Snap to the system wide environment."
sed -i 's~/usr/bin:~/usr/bin:/snap/bin:~g' /etc/environment

homedirectory=$(eval echo ~$USER)
echo "homedirectory is $homedirectory"

bashas "mkdir $homedirectory/.kube"
bashas "microk8s.config > $homedirectory/.kube/config"


echo "Start MicroK8S"
microk8s.start
echo "Enable MicroK8S DNS"
microk8s.enable dns
echo "Enable MicroK8S Storage"
microk8s.enable storage
echo "Enable MicroK8S Ingress"
microk8s.enable ingress



if [[ "$MICROK8S_HELM_INSTALL" == true ]]; then
    echo "Installing HELM 3 & Client via Microk8s addon"
    microk8s.enable helm3
    echo "Adding alias for helm client"
    snap alias microk8s.helm3 helm
    echo "Adding Default repo for Helm"
    bashas "helm repo add stable https://charts.helm.sh/stable"
    echo "Adding Jenkins repo for Helm"
    bashas "helm repo add jenkins https://charts.jenkins.io"
    echo "Adding GiteaCharts for Helm"
    bashas "helm repo add gitea-charts https://dl.gitea.io/charts/"
    echo "Updating Helm Repository"
    bashas "helm repo update"
fi

# fix cluster ip address
export CLUSTER_SERVER=$(microk8s config | grep "server:" | sed 's/^.*server: //')
echo "CLUSTER_SERVER:$CLUSTER_SERVER"
kubectl config set-cluster microk8s-cluster --insecure-skip-tls-verify=true --server="$CLUSTER_SERVER"
kubectl config view

echo "***********************************************************************"
echo "Finished installMicrok8s.sh"
echo "***********************************************************************"
