#!/bin/bash
# Script to install wetty on ubuntu
echo "***********************************************************************"
echo "Started installWetty.sh"
echo "***********************************************************************"

export WETTY_PORT=${WETTY_PORT:-"8080"}

echo "Installing Wetty"
#WETTY_FILE="https://raw.githubusercontent.com/Nodnarboen/keptn-in-a-box/master/setup-wetty.sh"
#printInfo "Download wetty setup file..."
#curl -o setup-wetty.sh $WETTY_FILE
#printInfo "Set permissions..."
#chmod +x setup-wetty.sh
#printInfo "Install wetty..."
#./setup-wetty.sh
#printInfo "Finish install commands for wetty."


echo "apt add..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt update && apt-get -y install yarn

# installing npm
echo "install npm..."
apt-get -y install npm

# updating npm for wetty
echo "update npm for wetty..."
npm cache clean -f
npm install -g n
n stable

#installing wetty
echo "install wetty..."
yarn global add wetty

echo "
# systemd unit file
#
# place in /etc/systemd/system
# systemctl enable wetty.service
# systemctl start wetty.service

[Unit]
Description=Wetty Web Terminal
After=network.target

[Service]
Type=simple
WorkingDirectory=/usr/local/bin
ExecStart=/usr/local/bin/wetty -p $WETTY_PORT
TimeoutStopSec=20
KillMode=mixed
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target" > wetty.service

echo "Copy file to /etc/systemd/system..."
cp wetty.service /etc/systemd/system

echo "Enable wetty.service..."
systemctl enable wetty.service
echo "Enable start.service..."
systemctl start wetty.service
echo "Status of wetty.service:"
systemctl status wetty.service

echo "Done with wetty.service tasks."

echo "***********************************************************************"
echo "Finished installWetty.sh"
echo "***********************************************************************"



