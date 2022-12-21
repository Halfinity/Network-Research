#!/bin/bash

#addons for the script

#figlet installation
echo "[!] Checking for 'Addons' Before Script [!] "
sleep 2
echo
 
if [ -d /usr/share/figlet ] 
then
echo "[#]Figlet already installed "
sleep 2
echo
else
	sudo apt-get install figlet 1>/dev/null
fi

#nmap installation
if [ -d /usr/share/nmap/scripts ] 
then
echo "[#]Nmap already installed  "
sleep 2
else
	sudo apt-get install nmap 1>/dev/null
fi
echo

#Install relevant applications on the local computer.
#SSH-PASS, NIPE, GEOIPLOOKUP SERVICES

	ORANGE="\e[33m"
	printf "${ORANGE}"
	printf "===========================================================================\n"
	figlet -f future "Installation begins"
	printf "===========================================================================\n"
	sleep 2
	STOP="\e[0m"
	printf "${STOP}"
function INSTALL()
{ 	#Installing SSH-PASS 
	printf "===========================================================================\n"
	figlet -f future "Installing SSH-PASS Service"
	printf "===========================================================================\n"
	sleep 2
    apt-get install sshpass 1>/dev/null
    echo "[*]Installation completed successfully"
    #Installing Nipe
	printf "===========================================================================\n"
    figlet -f future "Installing NIPE Service"
	printf "===========================================================================\n"
	sleep 2
	if [ -d /home/kali/nipe ] 
	then 
		echo "[*]Installation completed successfully"
	else
		cd /home/kali 1>/dev/null
		git clone https://github.com/htrgouvea/nipe && cd nipe 1>/dev/null
		sudo cpan install Try::Tiny Config::Simple JSON 1>/dev/null
		perl nipe.pl install -yes 1>/dev/null
	fi
	
    #Installing GeoIpLookUp
	printf "===========================================================================\n"
    figlet -f future "Installing GeoIP Service"
	printf "===========================================================================\n"
	sleep 2
	apt-get install -y geoip-bin 1>/dev/null
	 echo "[*]Installation completed successfully"
}


#Check if the connection is from your origin country. If no, continue.
function CONNECTION()
{
	IP=$(curl -s ifconfig.co)
if [ "$(geoiplookup $IP | grep -i country | grep -i IL)" ]
then

	RED="\e[31m"
	ORANGE="\e[33m"
	
	printf "${RED}"
	figlet -w 200 -f  small "YOU ARE NOT ANONYMOUS"
	printf "${ORANGE}"
	sleep 2
	printf "============================================================================================================================================\n"
	figlet -w 200 -f  small "STARTING  ANONYMOUS - MODE . . ."
	printf "============================================================================================================================================\n"
	STOP="\e[0m"
	printf "${STOP}"
	sleep 1
#Active Nipe
    cd /home/kali/nipe
	perl nipe.pl restart
	perl nipe.pl start
	perl nipe.pl status
	
	GREEN="\e[92m"
	printf "${GREEN}"
	printf "============================================================================================================================================\n"
	figlet -w 200 -f  small "YOU ARE NOW ANONYMOUS"
	printf "============================================================================================================================================\n"
	sleep 2
	STOP="\e[0m"
	printf "${STOP}"
else

	GREEN="\e[92m"
	ORANGE="\e[33m"
	
	printf "${GREEN}"
	figlet -w 200 -f  small "YOU ARE ANONYMOUS"
	sleep 2.5
	printf "${ORANGE}"
	figlet -w 200 -f  small "Continue . . . ."
	sleep 2
	STOP="\e[0m"
	printf "${STOP}"
fi
}
echo
#Once the connection is anonymous, communicate via SSH and execute nmap
#scans and whois queries.
function VPS()
{
	figlet -f future "Hello anonymous"
	echo "Enter ip of ssh server: " 
	read IP
	read -p "Enter username of ssh server:" USR
	read -p "Enter password for ssh server: " PASS
	read -p "Enter an IP-Range or IP to scan: " RNG
	sshpass -p $USR ssh -o StrictHostKeyChecking=no $PASS@$IP " nmap $RNG -Pn -p 22"
	echo "============================================================================================================================================\n"
	sshpass -p $USR ssh -o StrictHostKeyChecking=no $PASS@$IP " whois $RNG "
}
#Checking if you are "root"

if [ "$(whoami)" != "root" ] 
then
	echo "You are not root! EXITING ..."
exit
fi

#Calling the Functions
INSTALL
CONNECTION
VPS
