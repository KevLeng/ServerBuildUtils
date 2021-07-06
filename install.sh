#!/bin/bash
# Generic installer on ubuntu
echo "***********************************************************************"
echo "Started install.sh"
echo "***********************************************************************"


# ==================================================
# ----- Log Variables Definitions -----       
# ==================================================
LOGFILE=${LOGFILE:-"/tmp/install.log"}
touch $LOGFILE
chmod 775 $LOGFILE
pipe_log=${pipe_log:-true}

# ==================================================
# ----  Dynatrace Environment ---- 
# ==================================================
# Sample: https://{your-domain}/e/{your-environment-id} for managed or https://{your-environment-id}.live.dynatrace.com for SaaS
TENANT=$TENANT
PAASTOKEN=$PAASTOKEN
APITOKEN=$APITOKEN

# ==================================================
# ----  Workshop Variables ---- 
# ==================================================
echo "PUBLIC_SECTOR_WORKSHOP=$PUBLIC_SECTOR_WORKSHOP"
PUBLIC_SECTOR_WORKSHOP=${PUBLIC_SECTOR_WORKSHOP:-false}
echo "PUBLIC_SECTOR_WORKSHOP=$PUBLIC_SECTOR_WORKSHOP"

# ==================================================
# ----  Environment Variables ---- 
# ==================================================
#  Untils
UTIL_INSTALL=${UTIL_INSTALL:-false}
UTIL_FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/KevLeng/ServerBuildUtils/main/genericUtils.sh"
UTIL_FUNCTIONS_FILE="genericUtils.sh"

#  K3S
K3S_INSTALL=${K3S_INSTALL:-false}
K3S_FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/KevLeng/ServerBuildUtils/main/installK3S.sh"
K3S_FUNCTIONS_FILE="installK3S.sh"

#  MicroK8S
MICROK8S_INSTALL=${MICROK8S_INSTALL:-false}
MICROK8S_FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/KevLeng/ServerBuildUtils/main/installMicrok8s.sh"
MICROK8S_FUNCTIONS_FILE="installMicrok8s.sh"

#  Helm
HELM_INSTALL=${HELM_INSTALL:-false}
HELM_FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/KevLeng/ServerBuildUtils/main/installHelm.sh"
HELM_FUNCTIONS_FILE="installHelm.sh"

#  Istio
ISTIO_INSTALL=${ISTIO_INSTALL:-false}
ISTIO_FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/KevLeng/ServerBuildUtils/main/installIstio.sh"
ISTIO_FUNCTIONS_FILE="installIstio.sh"

# Docker
DOCKER_INSTALL=${DOCKER_INSTALL:-false}
DOCKER_FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/KevLeng/ServerBuildUtils/main/installDocker.sh"
DOCKER_FUNCTIONS_FILE="installDocker.sh"

#  Wetty
WETTY_INSTALL=${WETTY_INSTALL:-false}
WETTY_FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/KevLeng/ServerBuildUtils/main/installWetty.sh"
WETTY_FUNCTIONS_FILE="installWetty.sh"

# Sockshop
SOCKSHOP_INSTALL=${SOCKSHOP_INSTALL:-false}
SOCKSHOP_FUNCTIONS_FILE_REPO="https://raw.githubusercontent.com/KevLeng/ServerBuildUtils/main/installSockshop.sh"
SOCKSHOP_FUNCTIONS_FILE="installSockshop.sh"



## ----  Write all output to the logfile ----
if [ "$pipe_log" = true ]; then
  echo "Piping all output to logfile $LOGFILE"
  echo "Type 'less +F $LOGFILE' for viewing the output of installation on realtime"
  echo ""
  # Saves file descriptors so they can be restored to whatever they were before redirection or used
  # themselves to output to whatever they were before the following redirect.
  exec 3>&1 4>&2
  # Restore file descriptors for particular signals. Not generally necessary since they should be restored when the sub-shell exits.
  trap 'exec 2>&4 1>&3' 0 1 2 3
  # Redirect stdout to file log.out then redirect stderr to stdout. Note that the order is important when you
  # want them going to the same file. stdout must be redirected before stderr is redirected to stdout.
  exec 1>$LOGFILE 2>&1
else
  echo "Not piping stdout stderr to the logfile, writing the installation to the console"
fi


# Comfortable function for setting the sudo user.
if [ -n "${SUDO_USER}" ] ; then
  USER=$SUDO_USER
fi
echo "running sudo commands as $USER"

# Wrapper for runnig commands for the real owner and not as root
alias bashas="sudo -H -u ${USER} bash -c"
# Expand aliases for non-interactive shell
shopt -s expand_aliases

# Load functions after defining the variables & versions
getFunctionsFile(){
    file=$1
    repo=$2
    
    if [ -f "$file" ]; then
        echo "The functions file $file exists locally, loading functions from it. (dev)"
    else
        echo "The functions file $file does not exist, getting it from github."
        curl -o $file $repo
    fi
}

# Installers
install(){
    if [[ "$UTIL_INSTALL" == true ]]; then
        echo "Install Utils"
        getFunctionsFile $UTIL_FUNCTIONS_FILE $UTIL_FUNCTIONS_FILE_REPO
        source $UTIL_FUNCTIONS_FILE
    fi

    if [[ "$K3S_INSTALL" == true ]]; then
        echo "Install K3S"
        getFunctionsFile $K3S_FUNCTIONS_FILE $K3S_FUNCTIONS_FILE_REPO
        source $K3S_FUNCTIONS_FILE
    fi

    if [[ "$MICROK8S_INSTALL" == true ]]; then
        echo "Install MicroK8S"
        getFunctionsFile $MICROK8S_FUNCTIONS_FILE $MICROK8S_FUNCTIONS_FILE_REPO
        source $MICROK8S_FUNCTIONS_FILE
    fi

    if [[ "$HELM_INSTALL" == true ]]; then
        echo "Install Helm"
        getFunctionsFile $HELM_FUNCTIONS_FILE $HELM_FUNCTIONS_FILE_REPO
        source $HELM_FUNCTIONS_FILE
    fi

    if [[ "$ISTIO_INSTALL" == true ]]; then
        echo "Install Istio"
        getFunctionsFile $ISTIO_FUNCTIONS_FILE $ISTIO_FUNCTIONS_FILE_REPO
        source $ISTIO_FUNCTIONS_FILE
    fi

    if [[ "$DOCKER_INSTALL" == true ]]; then
        echo "Install Istio"
        getFunctionsFile $DOCKER_FUNCTIONS_FILE $DOCKER_FUNCTIONS_FILE_REPO
        source $DOCKER_FUNCTIONS_FILE
    fi

    if [[ "$WETTY_INSTALL" == true ]]; then
        echo "Install Istio"
        getFunctionsFile $WETTY_FUNCTIONS_FILE $WETTY_FUNCTIONS_FILE_REPO
        source $WETTY_FUNCTIONS_FILE
    fi

    if [[ "$SOCKSHOP_INSTALL" == true ]]; then
        echo "Install Sockshop"
        getFunctionsFile $SOCKSHOP_FUNCTIONS_FILE $SOCKSHOP_FUNCTIONS_FILE_REPO
        source $SOCKSHOP_FUNCTIONS_FILE
    fi

}

if [[ "$PUBLIC_SECTOR_WORKSHOP" == true ]]; then
    echo "Installing for Public Sector Workshop..."
    export MICROK8S_CHANNEL="1.19/stable"

    PUBLIC_IP=$(curl -s ifconfig.me)
    PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

    UTIL_INSTALL=true
    MICROK8S_INSTALL=true
    WETTY_INSTALL=true
    SOCKSHOP_INSTALL=true

fi

install
echo "install.sh finished."
