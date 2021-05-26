#!/bin/bash
# Script to install Microk8s on ubuntu
echo "***********************************************************************"
echo "Started installMicrok8s.sh"
echo "***********************************************************************"

export MICROK8S_CHANNEL=${MICROK8S_CHANNEL:-"1.21/stable"}

sudo snap install microk8s --classic --channel=$MICROK8S_CHANNEL

echo "allowing the execution of priviledge pods"
echo "--allow-privileged=true" >> /var/snap/microk8s/current/args/kube-apiserver

sudo usermod -a -G microk8s $USER

iptables -P FORWARD ACCEPT
ufw allow in on cni0 && sudo ufw allow out on cni0
ufw default allow routed

snap alias microk8s.kubectl kubectl

sed -i 's~/usr/bin:~/usr/bin:/snap/bin:~g' /etc/environment

homedirectory=$(eval echo ~$USER)

mkdir $homedirectory/.kube

microk8s.config > $homedirectory/.kube/config

microk8s.start

echo "***********************************************************************"
echo "Finished installMicrok8s.sh"
echo "***********************************************************************"


microk8sInstall() {
  if [ "$microk8s_install" = true ]; then
    printInfoSection "Installing Microkubernetes with Kubernetes Version $MICROK8S_CHANNEL"
    snap install microk8s --channel=$MICROK8S_CHANNEL --classic

    printInfo "allowing the execution of priviledge pods "
    bash -c "echo \"--allow-privileged=true\" >> /var/snap/microk8s/current/args/kube-apiserver"

    printInfo "Add user $USER to microk8 usergroup"
    usermod -a -G microk8s $USER

    printInfo "Update IPTABLES, allow traffic for pods (internal and external) "
    iptables -P FORWARD ACCEPT
    ufw allow in on cni0 && sudo ufw allow out on cni0
    ufw default allow routed

    printInfo "Add alias to Kubectl (Bash completion for kubectl is already enabled in microk8s)"
    snap alias microk8s.kubectl kubectl

    printInfo "Add Snap to the system wide environment."
    sed -i 's~/usr/bin:~/usr/bin:/snap/bin:~g' /etc/environment

    printInfo "Create kubectl file for the user"
    homedirectory=$(eval echo ~$USER)
    bashas "mkdir $homedirectory/.kube"
    bashas "microk8s.config > $homedirectory/.kube/config"
  fi
}

microk8sStart() {
  printInfoSection "Starting Microk8s"
  bashas 'microk8s.start'
}