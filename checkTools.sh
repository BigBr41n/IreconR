#!/bin/bash


log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}


required_tools=(
    "amass"
    "sublist3r"
    "subfinder"
    "subjack"
    "httprobe"
    "nmap"
    "nikto"
    "whatweb"
    "gobuster"
    "dirsearch"
    "ffuf"
    "wpscan"
)

check if a tool is installed
check_tool() {
    command -v $1 &> /dev/null
    if [ $? -eq 0 ]; then
        log "$1 is installed."
    else
        log "$1 is not installed."
    fi
}


echo "Checking required tools..."
for tool in "${required_tools[@]}"; do
    check_tool $tool
done
