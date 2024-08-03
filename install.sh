#!/bin/bash

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Update and install dependencies
log "Updating package list and installing dependencies..."
sudo apt update
sudo apt install -y git python3 python3-pip nmap nikto whatweb gobuster

# Install Go for Subfinder
log "Installing Go..."
wget https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz
sudo tar -xvf go1.17.6.linux-amd64.tar.gz
sudo mv go /usr/local

# Set Go environment variables
echo "export GOROOT=/usr/local/go" >> ~/.profile
echo "export GOPATH=$HOME/go" >> ~/.profile
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.profile
source ~/.profile

# Install Amass
log "Installing Amass..."
go install -v github.com/owasp-amass/amass/v4/...@master

# Install Sublist3r
log "Installing Sublist3r..."
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
pip3 install -r requirements.txt
sudo python3 setup.py install
cd ..

# Install Subfinder
log "Installing Subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Install httprobe
log "Installing httprobe..."
go install github.com/tomnomnom/httprobe@latest

# Install WPScan
log "Installing WPScan..."
sudo gem install wpscan

# Install dirsearch
log "Installing Dirsearch..."
git clone https://github.com/maurosoria/dirsearch.git
cd dirsearch
pip3 install -r requirements.txt
cd ..

# Install ffuf
log "Installing FFUF..."
go install github.com/ffuf/ffuf@latest

# Install Subjack
log "Installing Subjack..."
go install github.com/haccer/subjack@latest

# Final log message
log "All tools have been installed successfully."
