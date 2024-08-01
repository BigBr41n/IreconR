#!/bin/bash

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# run Amass for passive reconnaissance
run_amass() {
    log "Running Amass for domain enumeration..."
    amass enum -passive -d $target_domain -o amass_domains.txt
}

# run Sublist3r for subdomain enumeration
run_sublist3r() {
    log "Running Sublist3r for subdomain enumeration..."
    sublist3r -d $target_domain -o sublist3r_domains.txt
}

# run Subfinder for subdomain enumeration
run_subfinder() {
    log "Running Subfinder for subdomain enumeration..."
    subfinder -d $target_domain -o subfinder_domains.txt
}

# combine and sort subdomains
combine_subdomains() {
    log "Combining and sorting unique subdomains..."
    cat amass_domains.txt sublist3r_domains.txt subfinder_domains.txt | sort -u > all_subdomains.txt
}

# Function to probe alive subdomains
probe_subdomains() {
    log "Probing for alive subdomains..."
    cat all_subdomains.txt | httprobe > alive_subdomains.txt
}


# Function to run Nmap for network scanning
run_nmap() {
    log "Running Nmap for network scanning..."
    while read subdomain; do
        nmap -p- -T4 -A $subdomain -oN nmap_$subdomain.txt
    done < alive_subdomains.txt
}

# Function to run Nikto for web vulnerability scanning
run_nikto() {
    log "Running Nikto for web vulnerability scanning..."
    while read subdomain; do
        nikto -h $subdomain -output nikto_$subdomain.txt
    done < alive_subdomains.txt
}


# fuction to run WhatWeb for CMS detection
run_whatweb() {
    log "Running WhatWeb for CMS detection..."
    while read subdomain; do
        whatweb $subdomain -o whatweb_$subdomain.txt
    done < alive_subdomains.txt
}

# Function to run WPScan for WordPress vulnerability scanning
run_wpscan() {
    log "Running WPScan for WordPress vulnerability scanning..."
    while read subdomain; do
        wpscan --url $subdomain --output wpscan_$subdomain.txt
    done < alive_subdomains.txt
}

# Function to run Gobuster for directory brute-forcing
run_gobuster() {
    log "Running Gobuster for directory brute-forcing..."
    while read subdomain; do
        gobuster dir -u $subdomain -w /path/to/wordlist.txt -o gobuster_$subdomain.txt
    done < alive_subdomains.txt
}

# Function to run dirsearch for directory and file brute-forcing
run_dirsearch() {
    log "Running Dirsearch for directory and file brute-forcing..."
    while read subdomain; do
        dirsearch -u $subdomain -w /path/to/wordlist.txt -o dirsearch_$subdomain.txt
    done < alive_subdomains.txt
}

# Function to run ffuf for fuzzing
run_ffuf() {
    log "Running FFUF for fuzzing..."
    while read subdomain; do
        ffuf -u $subdomain/FUZZ -w /path/to/wordlist.txt -o ffuf_$subdomain.txt
    done < alive_subdomains.txt
}

# Function to run Subjack for subdomain takeover detection
run_subjack() {
    log "Running Subjack for subdomain takeover detection..."
    subjack -w alive_subdomains.txt -o subjack_results.txt -ssl
}




# Main function to run all tasks
main() {
    target_domain=$1
    if [ -z "$target_domain" ]; then
        log "Usage: $0 <target_domain>"
        exit 1
    fi

    mkdir -p $target_domain
    cd $target_domain

    run_amass
    run_sublist3r
    run_subfinder
    combine_subdomains
    probe_subdomains
    run_nmap
    run_nikto
    run_whatweb
    run_wpscan
    run_gobuster
    run_dirsearch

    

    log "All tasks completed. Results are stored in the $target_domain/report directory."
}

main $1
