source /home/roki/dotfiles/scripts/shellTextVariables.sh
# ----------------------------------
# Colors
# ----------------------------------
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


harddrive () {
  echo -e "${PURPLE} HDD Space.: ${NOCOLOR}"
	# Which harddrives are we going to get data from?

	#Filesystem      Size  Used Avail Use% Mounted on
	#/dev/sde1        87G   30G   53G  37% /
	#/dev/sdf1       229G   47G  171G  22% /mnt/ServerBackup
	#/dev/sdg1       234G  201G   21G  91% /mnt/plexMetaData
	#/dev/sdh2       2.8T  2.6T  211G  93% /mnt/One
	#/dev/sdi2       2.8T  2.7T  102G  97% /mnt/Twee
	#/dev/md0         39T  959G   36T   3% /mnt/raid5
	#/dev/sdj1       9.1T  9.1T  115M 100% /mnt/FatTerry

	declare -A harddrives

	harddrives[OS]=$(df / | awk '{print$1}' | grep /)
	harddrives[Serverbackup]="/mnt/ServerBackup"
	harddrives[plexMetaData]="/mnt/plexMetaData"
	harddrives[raid5]="/mnt/raid5"
	harddrives[FatTerry]="/mnt/FatTerry"
  harddrives[One]="/mnt/One"
	harddrives[Twee]="/mnt/Twee"

	#echo "There are a total of ${#harddrives[@]} harddrives"

	tempnum=1
 	echo -en "${LIGHTGRAY}"
	echo -en "Filesystems	Free	Used	Size	Used%" | awk '{printf "   %-20s %7s %7s %7s %7s", $1, $2, $3, $4, $5}'
 	echo -e "${NOCOLOR}"
	for key in "${!harddrives[@]}"; do
		if ! lsblk -f | grep -q "${harddrives[${key}]}"; then
			if [[ "${key}" != "OS" ]]; then
				echo -e "   ${harddrives[${key}]} is not mounted..."
				echo -e "   ${LIGHTGRAY}[${REDHL}${DARKGRAY}xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx${NOCOLOR}${LIGHTGRAY}]${NOCOLOR}"
				continue
			fi	
		fi

		tot_available=`df -h ${harddrives[${key}]} | awk '{print $4}' | tail -n 1`
		tot_used=`df -h ${harddrives[${key}]} | awk '{print $3}' | tail -n 1`
		tot_size=`df -h ${harddrives[${key}]} | awk '{print $2}' | tail -n 1`
		tot_usedPerc=`df -h ${harddrives[${key}]} | awk '{print $5}' | tail -n 1`

		if [[ "${key}" = "OS" ]]; then
			harddrives[OS]="/${DARKGRAY}(${harddrives[${key}]:1})${NOCOLOR}"
			echo -e "${harddrives[$key]}	${Bold}${tot_available}	${tot_used}	${tot_size}	${tot_usedPerc}" | awk '{printf "   %-31s %11s %7s %7s %7s", $1, $2, $3, $4, $5}'
		else
			echo -e "${harddrives[$key]}	${Bold}${tot_available}	${tot_used}	${tot_size}	${tot_usedPerc}" | awk '{printf "   %-20s %11s %7s %7s %7s", $1, $2, $3, $4, $5}'
		fi

		#echo -e "Harddrive Key: 	${key}"
		#echo -e "Harddrive Value: ${harddrives[${key}]}"
		#echo -e "    ${key}"
		#echo -e "    Tot_Capacity: ${tot_used}/${tot_size}"
		#echo -e "    Tot_Available: ${tot_available}"


		echo 
		
		perc=`echo ${tot_usedPerc} | sed 's/\d*%//'`

		usedPerc=$(( ${perc} / 2  ))
		str=$(printf "%${usedPerc}s")
		percDiff=$(( 50 - $usedPerc ))
		extraStr=$(printf "%${percDiff}s")

		echo -en "   ${LIGHTGRAY}["
		if [[ ${perc} -lt 50 ]]; then
			echo -en "${GREEN}"
		elif [[ ${perc} -ge 50 && ${perc} -lt 55 ]]; then
			echo -en "\033[38;5;076m"
		elif [[ ${perc} -ge 55 && ${perc} -lt 60 ]]; then
			echo -en "\033[38;5;112m"
		elif [[ ${perc} -ge 60 && ${perc} -lt 65 ]]; then
			echo -en "\033[38;5;148m"
		elif [[ ${perc} -ge 65 && ${perc} -lt 70 ]]; then
			echo -en "\033[38;5;184m"
		elif [[ ${perc} -ge 70 && ${perc} -lt 75 ]]; then
			echo -en "\033[38;5;220m"
		elif [[ ${perc} -ge 75 && ${perc} -lt 80 ]]; then
			echo -en "\033[38;5;214m"
		elif [[ ${perc} -ge 80 && ${perc} -lt 85 ]]; then
			echo -en "\033[38;5;208m"
		elif [[ ${perc} -ge 85 && ${perc} -lt 90 ]]; then
			echo -en "\033[38;5;202m"
		elif [[ ${perc} -ge 90 && ${perc} -lt 95 ]]; then
			echo -en "\033[38;5;124m"
		elif [[ ${perc} -ge 95 ]]; then
			echo -en "\033[38;5;009m"
		else
			echo -en
		fi

		echo -en "${str// /━}${NOCOLOR}"
		echo -en "${DARKGRAY}${extraStr// /━}${NOCOLOR}"
		echo -en "${LIGHTGRAY}]${NOCOLOR}"

		echo
		tempnum=$(( $tempnum + 1 ))
	done
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


echo -e "${PURPLE}═════════════════════════════════════════════════════════${NOCOLOR}"
harddrive
echo -e "${PURPLE}═════════════════════════════════════════════════════════${NOCOLOR}"
