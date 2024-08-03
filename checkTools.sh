#!/bin/bash


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

# check if a tool is installed
check_tool() {
    command -v $1 &> /dev/null
    if [ $? -eq 0 ]; then
       echo "$1 is installed."
    else
        echo -e "\033[0;31m$1 is not installed.\033[0m"
    fi
}


echo "Checking required tools..."
for tool in "${required_tools[@]}"; do
    check_tool $tool
done
