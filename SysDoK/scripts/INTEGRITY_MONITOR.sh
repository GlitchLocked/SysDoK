#!/bin/bash
clear

         ###################################################
         #*/=============================================\*#
         # ||                      .__                  || #
         # ||   ____   ____   ____ |  |   ____   ____   || #
         # || _/ __ \_/ __ \ / ___\|  |  /  _ \ /  _ \  || #
         # || \  ___/\  ___// /_/  >  |_(  <_> |  <_> ) || #
         # ||  \___  >\___  >___  /|____/\____/ \____/  || #
         # ||      \/     \/_____/                  2021|| #
         #.\=============================================/.#
         ################################################### 
         
########################################################################
#  ██ ███    ██ ████████ ███████  ██████  ██████  ██ ████████ ██    ██ #
#  ██ ████   ██    ██    ██      ██       ██   ██ ██    ██     ██  ██  #
#  ██ ██ ██  ██    ██    █████   ██   ███ ██████  ██    ██      ████   #
#  ██ ██  ██ ██    ██    ██      ██    ██ ██   ██ ██    ██       ██    #
#  ██ ██   ████    ██    ███████  ██████  ██   ██ ██    ██       ██   V1
########################################################################

########################################################################
#  Generation des md5sum des fichiers en liste, et check regulierement #
########################################################################

# check list de fichiers sensibles
declare -a Files=("/etc/passwd"
                  "/etc/issue"
                  "/etc/group"
                  "/etc/hostname"
                  "/etc/hosts"
                  "/etc/fstab"
                  "/etc/login.defs"
                  "/etc/default/useradd"
                  "/etc/sysctl.conf"
                  "/usr/sbin/cron"
                  "/usr/bin/crontab")

# ,/home/user/,/home/user/.ssh,/home/user/bash_history
# declare -a Files=("/tmp/coucou"
#                   "/tmp/hello")

########################################################################
# Root ?#
#########
		if [[ $(id -u) == 0 ]]; then
			Files+=("/etc/shadow")
		fi
#########

function StartFilesIntegrity(){

	echo "Init process"
	LogFileCheck
	GenerateSumFromList "init"
	RAS
	CompareCheckSums

}


# make integrity reference with md5sum from list
function GenerateSumFromList() 
{
	cat /dev/null > /tmp/.B

	for File in "${Files[@]}"; do
		# Control if file exist
		if test -f "$File"; then

			#Generate checksum
			CheckSum=$(md5sum $File)

			if [[ $1 == "init" ]]; then
				# init checkSum 
				echo "$CheckSum" >> /tmp/.A
			else 
				# post-init checkSum 
				echo "$CheckSum" >> /tmp/.B
			fi
		fi
	done

}

function LogFileCheck() 
{
	#A REVOIR , CONFLIT AVEC ROOT
	# REPLACE BUFFER BY VARIABLE

	# Si le fichier exist
	if test -f /tmp/.C.log; then
		rm /tmp/.C.log
	fi

	if test -f /tmp/.B; then
		rm /tmp/.B
	fi

	if test -f /tmp/.A; then
		rm /tmp/.A 
	fi

	touch /tmp/.C.log
	touch /tmp/.B
	touch /tmp/.A
}

function CompareCheckSums(){

	while /bin/true; do
		
		# Recheck la liste 
		GenerateSumFromList "refresh"
		
		sleep 1
		
		# Comparaison checkSums
		integrity="$(diff -u /tmp/.A /tmp/.B)"

		#if output from $integrity are not clean 
		if [[ -n $integrity ]]
		then
		    Alert "$integrity"
		    exit
		fi
	done
}

function Alert(){
	clear

	printf "\n\n========================================"
	printf "\n █████  ██      ███████ ██████  ████████
██   ██ ██      ██      ██   ██    ██   
███████ ██      █████   ██████     ██   
██   ██ ██      ██      ██   ██    ██   
██   ██ ███████ ███████ ██   ██    ██   \n"
	printf "%s\n" "========================================"

	printf "  Compromission sur : "
	printf "%s\n" $1 | grep -A 1 "+" | grep "/" | grep -v "/tmp/.B"
	printf "  Check la liste initial /tmp/C.log\n"

	printf "%s\n" "========================================"
	date

}

function RAS(){
	clear

	printf "\n==========================================\n"
echo " Init  :  $(date)" 
	printf "==========================================\n"
echo " Surveillance Fichiers Sensible en cours"
	printf "=========================================="

}

function Menu(){

	PS3='Monitoring : '
	options=("Fichiers Sensibles" "Pots de Miel" "Detection de Ping" "Quit")

	select opt in "${options[@]}"
	do
	    case $opt in
	        "Fichiers Sensibles")
	            clear 
	            StartFilesIntegrity
	            ;;
	        "Pots de Miel")
	            echo "In progress..."
	            ;;
	        "Detection de Ping")
				if [[ $(id -u) == 0 ]]; then
					clear
					tcpdump -i any 'icmp and icmp[icmptype]=icmp-echo' 
				else
					echo "Run as root."
				fi
	            ;;
	        "Quit")
	            break
	            ;;
	        *) echo "invalid option $REPLY";;
	    esac
	done

}

StartFilesIntegrity