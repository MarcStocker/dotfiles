#!/bin/bash

##########################################################
### Description:
###		Script will display all Wireguard clients based off
###		the wireguard config folder.
###	
###		File structure script will work with:
###			/FolderToPointTo/nameOfClient/client.conf
##########################################################

source ~/dotfiles/scripts/shellTextVariables.sh
# ----------------------------------
# Symbols
# ----------------------------------
#GREENCHECK="${LIGHTGREEN}\u2714${NOCOLOR}"
GREENCHECK="\U2705"
REDCROSS="\U274C"
YELLOWHAZARD="${YELLOW}\U1F6AB${NOCOLOR}"
WARNING="\U2620"
FIRE="\U1F525"

# ----------------------------------
# Variables
# ----------------------------------
prefix="${GRAY}[ ${CYAN}Wireguard Clients ${GRAY}]${NOCOLOR}"

# For multiple systems, determine which folder exists and use that one 
RokianClientFolder="/mnt/ServerBackup/docker/storage/wireguard/config"
otherClients="/docker/storage/wireguard/config"
if [[ -d $RokianClientFolder ]]; then clientFolder=$RokianClientFolder; fi
if [[ -d $otherClients ]]; then clientFolder=$otherClients; fi
# ----------------------------------

eprint() {
  echo -e "${GRAY}[ ${CYAN}Wireguard Clients ${GRAY}]${NOCOLOR} $1"
}
lprint() {
  echo -en "${GRAY}[ ${CYAN}Wireguard Clients ${GRAY}]${NOCOLOR} $1"
}
rprint() {
  echo -e "\t\t${NOCOLOR} $1"
}

prompt() {
	#clientFolder="/mnt/ServerBackup/docker/storage/wireguard/config/"
	allClients=($(ls -1 ${clientFolder}))
	declare -a removeNonContainers

	echo "Client Folder: ${clientFolder}"

	eprint "${PURPLE}Which client do you want to display connection info for?${NOCOLOR}"
	printOptions=""
	numSelect=0
	for i in ${!allClients[@]}; do
		client=${allClients[i]}
		if [[ -e "${clientFolder}/${client}/${client}.conf" ]]; then echo -n
		else
			continue
		fi
		removeNonClients+=("${client}")
		numSelect=$(( $numSelect + 1 ))
		
		rem=$(($numSelect % 2))
		tputGREEN=$(tput setaf 2)
		tputnormal=$(tput sgr0)
		printf "%-4s %-19s \n" "${tputGREEN}${numSelect}." "${tputnormal}${client}"
	done | column 

	for i in ${!allClients[@]}; do
		container=${allClients[i]}
		if [[ -e "${clientFolder}/${client}/${client}.conf" ]]; then echo -n
		else
			continue
		fi
		removeNonClients+=("${client}")
	done #| column 


	echo -en "${prefix} Select: ${GREEN}"
	read USERCHOICE
	echo -en "${NOCOLOR}"
	USERCHOICE=$(( $USERCHOICE -1 ))
  
}


while true; do
	prompt
	case $USERCHOICE in 
		x | X | q | Q | exit)
			eprint "Exiting..."
			exit
			;;
		[0-9]* )
			if [[ $USERCHOICE -gt ${#allClients[@]} ]]; then
				echo -en "\033[1A"
				eprint "${ORANGE}Please select a valid choice${NOCOLOR}. You chose '$USERCHOICE'"
				sleep .75
				continue
			fi
			break
			;;
		* )
			echo -en "\033[1A"
			eprint "${ORANGE}Please select a valid choice${NOCOLOR}"
			sleep .75
			continue
			;;
	esac
done

echo -e "${PURPLE}==================================================================${NOCOLOR}"
echo -e "${PURPLE}======================== Config Output ===========================${NOCOLOR}"
echo -e "${PURPLE}==================================================================${NOCOLOR}"
cat ${clientFolder}/${allClients[$USERCHOICE]}/${allClients[$USERCHOICE]}.conf
echo -e "${PURPLE}==================================================================${NOCOLOR}"
echo -e "${PURPLE}======================= QR Code  Output ==========================${NOCOLOR}"
echo -e "${PURPLE}=============== qrencode -t ansiutf8 < {FILENAME} ================${NOCOLOR}"
echo -e "${PURPLE}==================================================================${NOCOLOR}"
qrencode -t ansiutf8 < ${clientFolder}/${allClients[$USERCHOICE]}/${allClients[$USERCHOICE]}.conf
echo -e "${PURPLE}==================================================================${NOCOLOR}"


#eprint "${PURPLE}------------------------------------"
#eprint "${PURPLE}----- ${ORANGE}Stopping Containers ${PURPLE}----------"
#eprint "${PURPLE}------------------------------------"
#
#
#eprint "${PURPLE}------------------------------------"
#eprint "${PURPLE}----- ${RED}Removing Containers ${PURPLE}----------"
#eprint "${PURPLE}------------------------------------"
#
#eprint "${PURPLE}------------------------------------"
#eprint "${PURPLE}----- ${GREEN}Starting Containers ${PURPLE}----------"
#eprint "${PURPLE}------------------------------------"
#
#for n in {15..1}
#do
#        cursor=("|" "/" "-" "\\")
#        for i in ${!cursor[@]}; do
#                echo -en "${CLEARLINE}" # Clear text line
#                echo -en "                                                                                  \r"
#                echo -en "\r${ORANGE}[ INFO ]${NOCOLOR} ${LIGHTGREY} VPN Booting[${cursor[i]}]${NOCOLOR} - $n"
#                sleep 0.25
#        done
#done
#echo ""
#
#
