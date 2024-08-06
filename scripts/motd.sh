source ~/dotfiles/scripts/shellTextVariables.sh
# ----------------------------------
# Colors
# ----------------------------------
# echo -en "\033[38;5;<TheColor>m"
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[38;5;208m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[0;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

REDHL='\033[1;41m'
YELLOWHL='\033[1;43m'
GREENHL='\033[1;42m'

ERASELINE='\033[D\033[K'
CLEARLINE='\033[D\033[K'

SAVECURSOR='\033[s'
CURSORLOAD='\033[u'
LOADCURSOR='\033[u'
# ----------------------------------
# Symbols
# ----------------------------------
GREENCHECK="${LIGHTGREEN}\u2705${NOCOLOR}"
REDCROSS="\u274c"



# ----------------------------------
# VARIABLES 
# ----------------------------------
vpnDocker="gluetun"
loadingpid=""


# ==================================
# ==================================
# ==================================
VerNum="v4.2"
VerSTRLENGTH=`echo -n $VerNum | wc -m`
for n in `seq 1 $VerSTRLENGTH`
do 
	VerNum="\b${VerNum}"
done

# =====================================================================
# Load .bashrc in case user decides to CTRL+C out of the MOTD
source ~/.bashrc

exit_script() {
    echo -e "\b\b  \n${YELLOW}Script killed by user${NOCOLOR}"

    trap - SIGINT SIGTERM  # clear the trap

		if [[ -z $loadingpid ]]; then kill "$loadingpid"; fi

		if [[ -z $! ]]; then kill -- $!; fi
		#kill -- $!

		# This line will also cause the SSH session to end if user inputs CTRL+C during the MOTD
    #kill -- -$$ # Sends SIGTERM to child/sub processes
}
trap exit_script SIGINT SIGTERM


banner () {
	#echo -en "$(clear)"
	#echo -e "${PURPLE}═════════════════════════════════════════════════════════${NOCOLOR}"
	#echo
	#echo -e "${PURPLE}═════════════════════════════════════════════════════════${NOCOLOR}"
  p=${PURPLE}
  c=${CYAN}
  n=${NOCOLOR}
  echo -e "${p}╭───────────────────────────────────────────────────╮${n}"
	echo -e "${p}│ ${c}╭───────────────────────────────────────────────╮${n}"                          "${p}│${n}"
	echo -e "${p}│ ${c}│   ${p}__________        __   .__                ${c}"                    " │ ${p}│${n}"
	echo -e "${p}│ ${c}│   ${p}\\______   \\ ____ |  | _|__|____    ____   ${c}"                  " │ ${p}│${n}"
	echo -e "${p}│ ${c}│   ${p} |       _//  _ \\|  |/ /  \\__  \\  /    \\  ${c}"                " │ ${p}│${n}"
	echo -e "${p}│ ${c}│   ${p} |    |   {  <_> }    <|  |/ __ \\|   |  \\ ${c}"                  " │ ${p}│${n}"
	echo -e "${p}│ ${c}│   ${p} |____|_  /\\____/|__|_ \\__{____  /___|  / ${c}"                  " │ ${p}│${n}"
	echo -e "${p}│ ${c}│   ${p}        \\/            \\/       \\/     \\/  ${c}"                " │ ${p}│${n}"
	echo -e "${p}│ ${c}│  ${p}  _________                                ${c}"                    " │ ${p}│${n}"
	echo -e "${p}│ ${c}│  ${p} /   _____/ ______________  __ ___________ ${c}"                    " │ ${p}│${n}"
	echo -e "${p}│ ${c}│  ${p} \\_____  \\_/ __ \\_  __ \\  \\/ // __ \\_  __ \\"             " ${c}│ ${p}│${n}"
	echo -e "${p}│ ${c}│  ${p} /        \\  ___/|  | \\/\\   /\\  ___/|  | \\/${c}"               " │ ${p}│${n}"
	echo -e "${p}│ ${c}│  ${p}/_______  /\\___  >__|    \\_/  \\___  >__|   ${c}"                 " │ ${p}│${n}"
	echo -e "${p}│ ${c}│  ${p}        \\/     \\/                 \\/     ${p}  ${VerNum}  ${c}│ ${p}│${n}"
	echo -e "${p}│ ${c}╰───────────────────────────────────────────────╯${n}${p}"               "│${n}"
  echo -e "${p}╰───────────────────────────────────────────────────╯${n}"
	#echo -e "${PURPLE}═════════════════════════════════════════════════════════${NOCOLOR}"
#  printf " -------------------------------------------------
# --  __________        __   .__                 --
# --  \______   \ ____ |  | _|__|____    ____    --
# --   |       _//  _ \|  |/ /  \__  \  /    \   --
# --   |    |   {  <_> }    <|  |/ __ \|   |  \  --
# --   |____|_  /\____/|__|_ \__{____  /___|  /  --
# --          \/            \/       \/     \/   --
# --   _________                                 --
# --  /   _____/ ______________  __ ___________  --
# --  \_____  \_/ __ \_  __ \  \/ // __ \_  __ \ --
# --  /        \  ___/|  | \/\   /\  ___/|  | \/ --
# -- /_______  /\___  >__|    \_/  \___  >__|    --
# --         \/     \/                 \/        --
# -------------------------------------------------" | lolcat
}

distro_info () {
	echo -e " ${YELLOW}Distro....: ${NOCOLOR}$(cat /etc/*release | grep "PRETTY_NAME" | cut -d "=" -f 2- | sed 's/"//g')"
	echo -e " ${ORANGE}Kernal....: ${NOCOLOR}$(uname -sv)"
	echo -e " ${ORANGE}pveVersion: ${NOCOLOR}$(pveversion | sed -n 's/.*pve-manager\/\([^ ]*\).*/\1/p')"
}
uptime_info () {
	echo -e " ${GREEN}Uptime....: ${NOCOLOR}$(uptime -p | sed 's/up //' | tr -d 'aeotu')${NOCOLOR}" 
	echo -e " ${GREEN}Up Since..: ${NOCOLOR}$(uptime -s)"
	echo -e " ${GREEN}Last Login:${NOCOLOR} $(lastlog -u `whoami` | tail -n 1 | awk '{print$4,$5,$6,$7,$8,$9}') ${LIGHTGREEN}from ${NOCOLOR}$(lastlog -u `whoami` | tail -n 1 | awk '{print$3}')"
}

docker_info () {
	ALLDOCKERS=`expr $(docker ps -a | wc -l) - 1`
	RUNDOCKERS=`expr $(docker ps | wc -l) - 1`
	UNHEALTHYDOCKERS=`expr $(docker ps | grep unhealthy | wc -l)`

	echo -e " ${CYAN}Dockers...: ${NOCOLOR}${RUNDOCKERS}/${ALLDOCKERS} Running |${ORANGE} ${UNHEALTHYDOCKERS} Unhealthy${NOCOLOR}"
}

docker_status () {
	docker_info
	Loading Start
	# Number of Columns to display
	columns=3

	# Docker containers to print
	dockers=("swag" "organizr" "gluetun" "plex" "overseerr" "organizr" "sonarr" "radarr" "qbittorrent")
	
	print=""

	for i in ${!dockers[@]}; do
		# Determine health of container, apply appropriate text color
		if [[ $(docker ps | grep ${dockers[i]} | grep unhealthy) ]]; then
			hlthStatus="${ORANGE}Unhlthy${NOCOLOR}"
		elif [[ $(docker ps | grep ${dockers[i]} | grep Paused) ]]; then
			hlthStatus="${YELLOW}Paused${NOCOLOR}"
		elif [[ $(docker ps | grep ${dockers[i]} | grep Up) ]]; then
			hlthStatus="${GREEN}Running${NOCOLOR}"
		else
			hlthStatus="${RED}STOPPED${NOCOLOR}"
		fi

	#echo -en "${2}:	${hlthStatus}" | awk '{printf "   %-12s %8s", $1, $2}'

		print+="${dockers[i]}:, ${hlthStatus},"

		if [ $((($i+1) % $columns)) -eq 0 ]; then
			print+="\n"
		fi
	done

	Loading END
	printf "$print" | column -ts $',' | sed -e 's/^/   /'
}

ha_docker_status () {
	Loading Start
	haStatus=''

	if [[ $(whoami) = 'root' ]]; then
		qmState=$(qm list 2> /dev/null | grep 103 | awk '{print$3}')
		if [[ ${qmState} == "running" ]]; then
			haStatus="${GREEN}${Undr}${Bold}HomeAssistant_VM${NOCOLOR}"
		elif [[ ${qmState} == "stopped" ]]; then
			haStatus="${RED}${Undr}${Bold}HomeAssistant_VM${NOCOLOR}"
		else
			haStatus="${ORANGE}${Undr}${Bold}HomeAssistant_VM${NOCOLOR}"
		fi
	fi

	Loading End
	echo -e " ${CYAN}HA Dockers: ${haStatus}" 
	Loading Start
	# Number of Columns to display
	columns=3

	# Docker containers to print
	dockers=("mqtt" "frigate" "double-take" "nodered" "ntpserver" "rtsptoweb" "wyze-bridge")
	
	print=''

	for i in ${!dockers[@]}; do
		# Determine health of container, apply appropriate text color
		if [[ $(docker ps | grep ${dockers[i]} | grep unhealthy) ]]; then
			hlthStatus="${ORANGE}Unhlthy${NOCOLOR}"
		elif [[ $(docker ps | grep ${dockers[i]} | grep Paused) ]]; then
			hlthStatus="${YELLOW}Paused${NOCOLOR}"
		elif [[ $(docker ps | grep ${dockers[i]} | grep Up) ]]; then
			hlthStatus="${GREEN}Running${NOCOLOR}"
		else
			hlthStatus="${RED}STOPPED${NOCOLOR}"
		fi

	#echo -en "${2}:	${hlthStatus}" | awk '{printf "   %-12s %8s", $1, $2}'

		print+="${dockers[i]}:, ${hlthStatus},"

		if [ $((($i+1) % $columns)) -eq 0 ]; then
			print+="\n"
		fi
	done

	Loading END
	printf "$print" | column -ts $',' 2>/dev/null | sed -e 's/^/   /' 2>/dev/null

}


vpn_status () {
	containers=("qbittorrent" "prowlarr" "sonarr" "radarr" "overseerr" "lidarr" "bazarr")
	columns=3

	echo -e " ${CYAN}Docker VPNs:${NOCOLOR}"
	Loading Start


	PUBLICIP=`dig +short myip.opendns.com @resolver1.opendns.com &` > /dev/null
	#VPNIP=`docker exec ${vpnDocker} curl -w "\n" -s ifconfig.io` > /dev/null
	#VPNIP=`docker exec ${vpnDocker} curl -s ifconfig.io 2> /dev/null`
	# Retrieve VPN IP
	for i in {1..3}; do
		if [[ -z "$VPNIP" ]]; then
			case $i in
				1 )
					VPNIP=`curl -Gs http://192.168.1.229:8001/v1/publicip/ip | jq .public_ip | sed -r "s/\"//g" 2> /dev/null`
					break;;
				2 )
					#echo "3) Curl ifconfig.io"
					VPNIP=`docker exec ${vpnContainer} curl -s ifconfig.io & 2> /dev/null`
					break;;
				3 )
					#echo "2) Curl amazon"
					VPNIP=`docker exec ${vpnContainer} curl -w "\n" -s -X GET https://checkip.amazonaws.com & 2> /dev/null`
					break;;
			esac
		fi
	done
	
	#echo "TEEEST: publicIP: $PUBLICIP  VPNIP: $VPNIP"
	print=""

	for i in ${!containers[@]}; do
		#vpnStatus=`docker exec ${containers[i]} curl -s -w "\n" ifconfig.io 2> /dev/null`
		vpnStatus=`docker exec ${containers[i]} curl -s ifconfig.io 2> /dev/null`

		if [[ ${vpnStatus} == ${VPNIP} ]]; then
			print+="${GREENCHECK} ${containers[i]},"
		else
			print+="${REDCROSS} ${containers[i]},"
		fi
		
		if [ $((( $i+1) % columns)) -eq 0 ]; then print+="\n"; fi
	done

	Loading END
	echo -e "${print}" | column -ts $',' | sed -e 's/^/   /'

}

raid_status () {
	echo "Don't worry about it"

}

harddrive () {
	echo
  echo -e "${PURPLE} HDD Space.: ${NOCOLOR}"
  ~/dotfiles/scripts/diskUsage.sh -n 2
	## Which harddrives are we going to get data from?

	##Filesystem      Size  Used Avail Use% Mounted on
	##/dev/sde1        87G   30G   53G  37% /
	##/dev/sdf1       229G   47G  171G  22% /mnt/ServerBackup
	##/dev/sdg1       234G  201G   21G  91% /mnt/plexMetaData
	##/dev/sdh2       2.8T  2.6T  211G  93% /mnt/One
	##/dev/sdi2       2.8T  2.7T  102G  97% /mnt/Twee
	##/dev/md0         39T  959G   36T   3% /mnt/raid5
	##/dev/sdj1       9.1T  9.1T  115M 100% /mnt/FatTerry

	#declare -A harddrives

	#harddrives[OS]=$(df / | awk '{print$1}' | grep /)
	#harddrives[Serverbackup]="/mnt/ServerBackup"
	#harddrives[plexMetaData]="/mnt/plexMetaData"
	#harddrives[raid5]="/mnt/raid5"
	#harddrives[FatTerry]="/mnt/FatTerry"
  #harddrives[One]="/mnt/One"
	#harddrives[Twee]="/mnt/Twee"

	##echo "There are a total of ${#harddrives[@]} harddrives"

	#tempnum=1
 	#echo -en "${LIGHTGRAY}"
	#echo -en "Filesystems	Free	Used	Size	Used%" | awk '{printf "   %-20s %7s %7s %7s %7s", $1, $2, $3, $4, $5}'
 	#echo -e "${NOCOLOR}"
	#for key in "${!harddrives[@]}"; do
	#	if ! lsblk -f | grep -q "${harddrives[${key}]}"; then
	#		if [[ "${key}" != "OS" ]]; then
	#			echo -e "   ${harddrives[${key}]} is not mounted..."
	#			echo -e "   ${LIGHTGRAY}[${REDHL}${DARKGRAY}xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx${NOCOLOR}${LIGHTGRAY}]${NOCOLOR}"
	#			continue
	#		fi	
	#	fi

	#	tot_available=`df -h ${harddrives[${key}]} | awk '{print $4}' | tail -n 1`
	#	tot_used=`df -h ${harddrives[${key}]} | awk '{print $3}' | tail -n 1`
	#	tot_size=`df -h ${harddrives[${key}]} | awk '{print $2}' | tail -n 1`
	#	tot_usedPerc=`df -h ${harddrives[${key}]} | awk '{print $5}' | tail -n 1`

	#	if [[ "${key}" = "OS" ]]; then
	#		harddrives[OS]="/${DARKGRAY}(${harddrives[${key}]:1})${NOCOLOR}"
	#		echo -e "${harddrives[$key]}	${Bold}${tot_available}b	${tot_used}b	${tot_size}b	${tot_usedPerc}" | awk '{printf "   %-31s %11s %7s %7s %7s", $1, $2, $3, $4, $5}'
	#	else
	#		echo -e "${harddrives[$key]}	${Bold}${tot_available}b	${tot_used}b	${tot_size}b	${tot_usedPerc}" | awk '{printf "   %-20s %11s %7s %7s %7s", $1, $2, $3, $4, $5}'
	#	fi

	#	#echo -e "Harddrive Key: 	${key}"
	#	#echo -e "Harddrive Value: ${harddrives[${key}]}"
	#	#echo -e "    ${key}"
	#	#echo -e "    Tot_Capacity: ${tot_used}/${tot_size}"
	#	#echo -e "    Tot_Available: ${tot_available}"


	#	echo 
	#	
	#	perc=`echo ${tot_usedPerc} | sed 's/\d*%//'`

	#	usedPerc=$(( ${perc} / 2  ))
	#	str=$(printf "%${usedPerc}s")
	#	percDiff=$(( 50 - $usedPerc ))
	#	extraStr=$(printf "%${percDiff}s")

	#	echo -en "   ${LIGHTGRAY}["
	#	if [[ ${perc} -lt 50 ]]; then
	#		echo -en "${GREEN}"
	#	elif [[ ${perc} -ge 50 && ${perc} -lt 55 ]]; then
	#		echo -en "\033[38;5;076m"
	#	elif [[ ${perc} -ge 55 && ${perc} -lt 60 ]]; then
	#		echo -en "\033[38;5;112m"
	#	elif [[ ${perc} -ge 60 && ${perc} -lt 65 ]]; then
	#		echo -en "\033[38;5;148m"
	#	elif [[ ${perc} -ge 65 && ${perc} -lt 70 ]]; then
	#		echo -en "\033[38;5;184m"
	#	elif [[ ${perc} -ge 70 && ${perc} -lt 75 ]]; then
	#		echo -en "\033[38;5;220m"
	#	elif [[ ${perc} -ge 75 && ${perc} -lt 80 ]]; then
	#		echo -en "\033[38;5;214m"
	#	elif [[ ${perc} -ge 80 && ${perc} -lt 85 ]]; then
	#		echo -en "\033[38;5;208m"
	#	elif [[ ${perc} -ge 85 && ${perc} -lt 90 ]]; then
	#		echo -en "\033[38;5;202m"
	#	elif [[ ${perc} -ge 90 && ${perc} -lt 95 ]]; then
	#		echo -en "\033[38;5;124m"
	#	elif [[ ${perc} -ge 95 ]]; then
	#		echo -en "\033[38;5;009m"
	#	else
	#		echo -en
	#	fi

	#	echo -en "${str// /=}${NOCOLOR}"
	#	echo -en "${DARKGRAY}${extraStr// /=}${NOCOLOR}"
	#	echo -en "${LIGHTGRAY}]${NOCOLOR}"

	#	echo
	#	tempnum=$(( $tempnum + 1 ))
	#done



	##echo -en "${GREEN}"
	##echo -en "\033[38;5;076m"
	##echo -e "========"
	##echo -en "\033[38;5;112m"
	##echo -e "============"
	##echo -en "\033[38;5;148m"
	##echo -e "==============="
	##echo -en "\033[38;5;184m"
	##echo -e "=================="
	##echo -en "\033[38;5;220m"
	##echo -e "====================="
	##echo -en "\033[38;5;214m"
	##echo -e "========================"
	##echo -en "\033[38;5;208m"
	##echo -e "==========================="
	##echo -en "\033[38;5;202m"
	##echo -e "=============================="
	##echo -en "\033[38;5;124m"
	##echo -e "================================="
	##echo -en "\033[38;5;009m"
	##echo -e "====================================${NOCOLOR}"

}

Service_Status () {
	echo -e " ${PURPLE}Services..:${NOCOLOR}"
	allServices=('ssh' 'docker' 'mdadm' 'pve-manager' 'pveproxy')
	columns=3
	print=""

	for i in "${!allServices[@]}"; do
		theStatus=`systemctl is-active ${allServices[i]}`
		print+="${allServices[i]}:,"
		if [[ $theStatus = "active" ]]; then
			print+="${GREEN}${theStatus}${NOCOLOR},"
		fi
		if [[ $theStatus = "inactive" ]]; then
			print+="${RED}${theStatus}${NOCOLOR},"
		fi

		if [ $((( $i+1) % columns)) -eq 0 ]; then print+="\n"; fi
	done
	echo -e "${print}" | column -ts $',' | sed -e 's/^/   /'

  #sudo service docker status | grep Active
}

Loading () {
	if [[ -z $loadingpid ]]; then
		Spinning & loadingpid=$!
	else
		kill "$loadingpid"
		loadingpid=""
		for i in `seq 1 20`; do
			echo -en "${CLEARLINE}" # Clear text line
		done
		echo -en "\r"
	fi
}

Spinning () {
	cursor=("|" "/" "-" "\\")
	while ( : ); do
		for i in ${!cursor[@]}; do
			echo -en "${CLEARLINE}" # Clear text line
			echo -en "\r${ORANGE}[ INFO ]${NOCOLOR} ${LIGHTGREY}Loading [${cursor[i]}]${NOCOLOR}" 
			sleep 0.25
		done
	done
}


harddriveSpace () {
  echo 
}

#################################################
#################################################
#################################################
#################################################
#################################################
#          Start Script    Start Script         #
#################################################
#################################################
#################################################
#################################################
#################################################

#Display the Rokian Server banner only (For all Users)
banner

uptime_info
echo
distro_info

harddrive

#Run each users unique motd (Or skip them, w/e)
currentUser=`whoami`
if [[ $currentUser = 'roki' || $currentUser = 'root'  ]]; then
  #Service_Status
	# ----------------------------------
	# Load Other Variables
	# ----------------------------------
	#/home/roki/Documents/vpnresults.sh & > tmp.tmp
	echo
	Service_Status
	echo
	docker_status
	echo
	ha_docker_status
	echo
	vpn_status
	echo
else
	figlet "Don't fuck up!" | lolcat
fi
if [[ -n $loadingpid ]]; then 
	kill "$loadingpid" 
fi
echo -e "${PURPLE}═════════════════════════════════════════════════════════${NOCOLOR}"
