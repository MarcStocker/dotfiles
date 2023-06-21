source /home/roki/Documents/shellTextVariables.sh
#`/home/roki/Scripts/testvpn.sh`
# ----------------------------------
# Colors
# ----------------------------------
#NOCOLOR='\033[0m'
#RED='\033[0;31m'
#GREEN='\033[0;32m'
#ORANGE='\033[0;33m'
#BLUE='\033[0;34m'
#PURPLE='\033[0;35m'
#CYAN='\033[0;36m'
#LIGHTGRAY='\033[0;37m'
#GRAY='\033[0;37m'
#DARKGRAY='\033[1;30m'
#LIGHTRED='\033[1;31m'
#LIGHTGREEN='\033[1;32m'
#YELLOW='\033[0;33m'
#LIGHTBLUE='\033[1;34m'
#LIGHTPURPLE='\033[1;35m'
#LIGHTCYAN='\033[1;36m'
#WHITE='\033[1;37m'
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

#containers+=('plex')
#containers+=('organizr')
#containers+=('')
#containers+=('')
#containers+=('')
#containers+=('')
##containers+=('')


#numContainers="${#containers[@]}"




eprint() {
  echo -e "${GRAY}[ ${CYAN}Wireguard Clients ${GRAY}]${NOCOLOR} $1"
}

prompt() {
	wireguardClients=($(ls -d /mnt/ServerBackup/docker/storage/wireguard/config/peer_*))

	eprint "${PURPLE}Select a client to retrieve info for.${NOCOLOR}"
	print=""
	columns=3
	numSelect=0
	for i in ${!wireguardClients[@]}; do
		numSelect=$(( $numSelect +1 ))
		client=${wireguardClients[i]:55}

		printf "%-2s %-19s \n" "${numSelect}." "${client}"

	done | column

	echo -en "${prefix} Select: ${GREEN}"
	read USERCHOICE
	echo -en "${NOCOLOR}"
}


while true; do
	prompt
	case $USERCHOICE in 
		x | X | q | Q | exit)
			eprint "Exiting..."
			exit
			;;
		[0-9]* )
			if [[ $USERCHOICE -gt ${#wireguardClients[@]} ]]; then
				echo -en "\033[1A"
				eprint "${ORANGE}Please select a valid choice${NOCOLOR}"
				sleep .75
				continue
			fi
			USERCHOICE=$(( $USERCHOICE -1 ))
			break
			;;
		* )
			echo -en "\033[1A"
			eprint "${ORANGE}Please select a valid choice${NOCOLOR}"
			sleep .75
			continue
			;;
	esac


	#stopContainer ${wireguardClients[$USERCHOICE]:33}
	#removeContainer ${wireguardClients[$USERCHOICE]:33}
	#recreateContainer ${wireguardClients[$USERCHOICE]:33}
done

echo -e "${PURPLE}==================================================================${NOCOLOR}"
echo -e "${PURPLE}======================== Config Output ===========================${NOCOLOR}"
echo -e "${PURPLE}==================================================================${NOCOLOR}"
cat /mnt/ServerBackup/docker/storage/wireguard/config/peer_${wireguardClients[$USERCHOICE]:55}/peer_${wireguardClients[$USERCHOICE]:55}.conf
echo -e "${PURPLE}==================================================================${NOCOLOR}"
echo -e "${PURPLE}======================= QR Code  Output ==========================${NOCOLOR}"
echo -e "${PURPLE}==================================================================${NOCOLOR}"
qrencode -t ansiutf8 < /mnt/ServerBackup/docker/storage/wireguard/config/peer_${wireguardClients[$USERCHOICE]:55}/peer_${wireguardClients[$USERCHOICE]:55}.conf
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
