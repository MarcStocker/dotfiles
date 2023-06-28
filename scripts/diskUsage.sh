#!/bin/bash
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

#############################################################################################
# This script/function displays all harddrives on the system and info about their space
# The OS harddrive '/' will always be first. 
# Following the OS will be every other drive that doesn't come from the /etc folder,
# and will be sorted by total size, smallest-largest. 
#
# The function harddrive() will accept 1 argument, and must be the strings "reverse" or "r".
# Passing in these arguments will reverse the order to largest-smallest
#
# You can save hardcoded drives (the location where they should be mounted) as well
# 
#############################################################################################
# Example output (Real output will be colorized): 
##  user@machine:~/dotfiles/scripts$ ./diskUsage.sh list
##    Filesystems             Free    Used    Size   Used%
##    /(dev/sde1)              17G     66G     87G     80%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━----------]
##    /mnt/NanoDrive is UNMOUNTED...
##    [xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx]
##    /mnt/ServerBackup        15G    202G    229G     94%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━---]
##    /mnt/plexMetaData        15G    207G    234G     94%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━---]
##    /mnt/One                211G    2.6T    2.8T     93%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━----]
##    /mnt/TriceriBytes        12G    2.8T    2.8T    100%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━]
##    /mnt/FatTerry            91G    9.1T    9.1T    100%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━]
##    /mnt/raid5               16T     21T     39T     57%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━----------------------]
#############################################################################################
#
# Note: If you want to change the number of prefix spaces, search for #SPACES in the file
#       and change the line proceeding '#SPACES' comment. 
#
#############################################################################################



harddrive () { # the word "Reverse" or "r" can be passed in to reverse the harddrive order based on total space

	# Which harddrives are we going to get data from?
  # $ df -h | grep ^/
	#Filesystem      Size  Used Avail Use% Mounted on
	#/dev/sde1        87G   30G   53G  37% /
	#/dev/sdf1       229G   47G  171G  22% /mnt/ServerBackup
	#/dev/sdg1       234G  201G   21G  91% /mnt/plexMetaData
	#/dev/sdh2       2.8T  2.6T  211G  93% /mnt/One
	#/dev/sdi2       2.8T  2.7T  102G  97% /mnt/Twee
	#/dev/md0         39T  959G   36T   3% /mnt/raid5
	#/dev/sdj1       9.1T  9.1T  115M 100% /mnt/FatTerry

	declare -a harddrives

  #############################################################################################
	# HARDCODE Drives you'd like to be informed of if they are DISCONNECT (unmounted). 
  # Otherwise, it's all dynamic and you'll only see drives that are currently mounted.
  # 
  # Hardcoded drives will appear after the OS, but before everything else in the order they're entered.
  #
  # USE THE "MOUNT LOCATION" FOR THESE ENTRIES, examples follow.
  #############################################################################################
  ## harddrives+=("/mnt/FatTerry")
  ## harddrives+=("/mnt/raid5")
  ## harddrives+=("etc...")
  #############################################################################################

  #-----------------------------------------------------------
  #---------     Enter Hardcoded drives here    --------------
  #-----------------------------------------------------------
  #harddrives+=("/mnt/FatTerry")
  #harddrives+=("/mnt/raid5")
  #-----------------------------------------------------------

  # Gotta add in the '|' deliminator for any hardcoded drives
  for i in "${!harddrives[@]}"; do
    harddrives[$i]="|${harddrives[$i]}"
  done







  # Reverse drive order if requested
  fReverse=""
  if [[ ${1^^} == "REVERSE" || ${1^^} == "R" ]]; then
    fReverse="-r"
  fi

  # Read in all mounted harddrives
	while IFS= read -r line; do
		#echo -e "$line"
		filesystem=$(echo "$line" | awk '{print $1}')
		mount_point=$(echo "$line" | awk '{print $6}')
    # Check if the value already exists in the array (From Hardcoded drives)
    if [[ " ${harddrives[*]} " != *"$mount_point"* ]]; then
      #echo "ADDING: $filesystem | $mount_point"
      harddrives+=("$filesystem|$mount_point")
    fi
	done < <( df | grep ^/ | sort -n -k 3 $fReverse )
	#echo "There are a total of ${#harddrives[@]} harddrives"


  # Echo the Header
 	echo -en "${LIGHTGRAY}"
  #SPACES
	echo -en "Filesystems	Free	Used	Size	Used%" | awk '{printf "   %-20s %7s %7s %7s %7s", $1, $2, $3, $4, $5}'
 	echo -e "${NOCOLOR}"
  
  # Print OS drive first!!
  filesystem=$(df / | grep / | awk '{print $1}')
  mount_point=$(df / | grep / | awk '{print $6}')
  printHddGraphic $filesystem $mount_point

  # Print the rest of the drives
	for key in "${harddrives[@]}"; do
    filesystem=$(echo "$key" | cut -d "|" -f 1)
    mount_point=$(echo "$key" | cut -d "|" -f 2)
    if [[ $mount_point == "/" ]]; then
      continue
    fi
		printHddGraphic $filesystem $mount_point
	done
}
printHddGraphic () {
  filesystem=$1
  mount_point=$2
  #echo "Filesystem: $filesystem"
  #echo "mount_point: $mount_point"

  # If a hard coded drive is passed in without a filesystem, find it. 
  if [[ -z "${2// }" ]]; then
    mount_point=$(df | grep $filesystem | awk '{print $6}')
  fi

  # Handle unmounted drives (that aren't the OS, cause techincally it's mount point is '/', not '/dev/xxx#')
	if  ! lsblk -f | grep -q "${mount_point}" || [ -z "${mount_point// }" ] ; then
		if [[ "${filesystem}" != '/' ]]; then
      if [[ ${mount_point} == *"/etc/"* ]]; then
        return
      fi
      #SPACES
			echo -e "   ${filesystem} is ${RED}${Undr}${Bold}UNMOUNTED${NOCOLOR}..."
			#echo -e "   ${LIGHTGRAY}[${REDHL}${DARKGRAY}xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx${NOCOLOR}${LIGHTGRAY}]${NOCOLOR}"
			echo -en "   ${LIGHTGRAY}[${REDHL}${DARKGRAY}"
      
      str=$(printf "%50s")
      echo -en "${str// /x}${NOCOLOR}"

      echo -e "${NOCOLOR}${LIGHTGRAY}]${NOCOLOR}"
			return
		fi	
		return
	fi

	mount_point=${mount_point}
	filesystem=${filesystem}
	tot_available=`df -h ${mount_point} | awk '{print $4}' | tail -n 1`
	tot_used=`df -h ${mount_point} | awk '{print $3}' | tail -n 1`
	tot_size=`df -h ${mount_point} | awk '{print $2}' | tail -n 1`
	tot_usedPerc=`df -h ${mount_point} | awk '{print $5}' | tail -n 1`

  spaces="      "

	#if [[ "${filesystem}" = "OS" ]]; then
	if [[ "${mount_point}" = '/' ]]; then
		filesystem="/${DARKGREY}(${filesystem:1})${NOCOLOR}"
    #SPACES
		echo -e "${spaces}${filesystem}	${Bold}${tot_available}	${tot_used}	${tot_size}	${tot_usedPerc}" | awk '{printf "   %-31s %11s %7s %7s %7s", $1, $2, $3, $4, $5}'
	else
    #SPACES
		echo -e "${spaces}${mount_point}	${Bold}${tot_available}	${tot_used}	${tot_size}	${tot_usedPerc}" | awk '{printf "   %-20s %11s %7s %7s %7s", $1, $2, $3, $4, $5}'
	fi

	#echo
	#echo -e "Harddrive Key: 	${filesystem}"
	#echo -e "Harddrive Value: ${mount_point}"
	#echo -e "    ${filesystem}"
	#echo -e "    Tot_Capacity: ${tot_used}/${tot_size}"
	#echo -e "    Tot_Available: ${tot_available}"


	echo 
	
	perc=`echo ${tot_usedPerc} | sed 's/\d*%//'`

	usedPerc=$(( ${perc} / 2  ))
	str=$(printf "%${usedPerc}s")
	percDiff=$(( 50 - $usedPerc ))
	extraStr=$(printf "%${percDiff}s")

  #SPACES
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

# Only run if explicitly told to do so, otherwise, this file is basically just a function. 
if [[ $1 == "list" ]]; then
  echo -e "${PURPLE}═════════════════════════════════════════════════════════${NOCOLOR}"
  harddrive $2
  echo -e "${PURPLE}═════════════════════════════════════════════════════════${NOCOLOR}"
fi
