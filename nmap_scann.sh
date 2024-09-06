#!/bin/bash

exec >> >(tee -a  ~/networking/basic_networking/nmap/log_file.txt) 2>&1

set -x

### INIT VARS 

report_file=~/networking/basic_networking/nmap/report_file.txt
hosts_file=~/networking/basic_networking/nmap/hosts_file.txt
traceroute_file=~/networking/basic_networking/nmap/traceroute_file.txt

## Step 1 - Scan Host

target_name=$1

# Check that host exists

if [[ ! "$target_name" =~ ""  ]]; then
	echo "Host Name wasn't given "
	exit 1
else	
       	#if [[ ! "$target_name" =~ [0-9]+$ ]] ; then

	#	traceroute "$target_name" > "$traceroute_file"
	#fi
       traceroute "$target_name" > "$traceroute_file"	
fi
# Verify host file
if [[ -f "$traceroute_file" && -s "$traceroute_file" ]]; then
	# Preprocess host file
	echo "Preprocessing valid hosts...."
	## Greeping Host's IP Addr
	ip_addr=$(cat "$traceroute_file" | grep -oP 'google\.com  *\(\K[^\)]*')
	if [[ "$ip_addr" =~ "" ]]; then
		echo "Generating report for target $ip_addr"
		common_ports=(22 80 443)
	 	## nmap -sV "$ip_addr" >  "$hosts_file" Scanning for open ports and services along with the VERSION
		for port in "${common_ports[@]}"; do
			nmap -p "$port" --script vuln "$ip_addr" >> "$report_file"
		done
		echo "Showing final report: $report_file"
	else
		echo "IP addr not exists"

	fi
else 
	echo 'Host file not exists or is empty'
	exit 1

fi

set +x
