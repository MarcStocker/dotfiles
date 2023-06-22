#!/bin/bash

script_name1=`basename $0`
script_path1=$(dirname $(readlink -f $0))
script_path_with_name="$script_path1/$script_name1"

############################################################
# ----------------------------------
# Colors
# ----------------------------------
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
GREY='\033[0;37m'
GRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
DARKGREY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[0;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'
###########################################################################

trap '{ echo -e "\n${GREY}[ ${RED}TMUX ${GREY}] "; }' EXIT

# Script Prefix for use with echo
prefix="${GREY}[ ${GREEN}TMUX ${GREY}]${NOCOLOR} "

sessions_prompt()
{
	# Read in Tmux sessions data into 3 Arrays: Names, Dates, Sizes
	IFS=$'\n' read -r -d '' -a tmux_sessions_names < <( tmux list-sessions | awk '{print $1}' && printf '\0' )
	IFS=$'\n' read -r -d '' -a tmux_sessions_dates < <( tmux list-sessions | awk '{print $6" "$7" "$8}' && printf '\0' )
	IFS=$'\n' read -r -d '' -a tmux_sessions_sizes < <( tmux list-sessions | awk '{print $10}' && printf '\0' )

	# Loop over the NAMES array and remove the trailing ':' character from tmux names
	for ((i = 0; i < ${#tmux_sessions_names[@]}; i++)); do
		# Remove the ':' character using parameter expansion
		tmux_sessions_names[i]=${tmux_sessions_names[i]//:/}
	done

	echo -e "${prefix}${GREEN}======================================================="
	echo -e "${prefix}${GREEN}                Manage TMUX Sesssions"
	echo -e "${prefix}${GREEN}=======================================================${NOCOLOR}"
	# Print Header
	# [ TMUX ]   Session Name     Creation Date    Size
	echo -en "${prefix}   "
	echo -e "${CYAN}Session Name	 Creation Date	Size${NOCOLOR}" | awk '{printf "%-20s %22s %12s\n", $1" "$2, $3" "$4, $5}'

	tempNum=0
	for ((i = 0; i < ${#tmux_sessions_names[@]}; i++)); do
		tempNum=$(( $tempNum + 1 ))
		name=${tmux_sessions_names[$i]}
		date=${tmux_sessions_dates[$i]}
		size=${tmux_sessions_sizes[$i]}

		echo -ne "${prefix}"
		echo -e "${GREEN}${tempNum}.	${NOCOLOR}${name}	${date}	${size}" | awk '{printf "%-3s %-17s %22s %12s\n", $1, $2, $3" "$4" "$5, $6}'

		## Example
		##echo -e "Session Name         Creation Date  Size
		##echo -e "1. databackup      Jun 12 23:13:43  [322x454]"
		##echo -e "2. docker logs     Jun 12 23:13:43  [322x454]"
		##echo -e "3. multipleterms   Jun 12 23:13:43  [322x454]"
	done
	echo -e "${prefix}"
	echo -e "${prefix}${LIGHTGREEN}n. Add New Session${NOCOLOR}"
	echo -e "${prefix}${ORANGE}o. Enable/Disable Options${NOCOLOR}"
	echo -e "${prefix}${LIGHTRED}d. Delete a Session${NOCOLOR}"
	echo -e "${prefix}${LIGHTRED}x. Exit${NOCOLOR}"


	echo -en "${prefix}Select: ${GREEN}"
	read USERCHOICE
	echo -en "${NOCOLOR}"
}

attach_session () {
	echo -e "${prefix}${LIGHTGREEN}Attaching To Session: '${GREEN}${tmux_sessions_names[$USERCHOICE]}${LIGHTGREEN}'${NOCOLOR}"
	echo -e "${prefix}..."
	echo -en "${prefix}${YELLOW}"
	tmux attach-session -t ${tmux_sessions_names[$USERCHOICE]}
}

create_session () {
	echo -e "${prefix}"
	echo -en "${prefix}Name of New Session: ${GREEN}"
	read sessionName
	echo -en "${NOCOLOR}"
	echo -e "${prefix}${LIGHTGREEN}Starting Session: '${GREEN}${sessionName}${LIGHTGREEN}'${NOCOLOR}"
	echo -e "${prefix}..."
	echo -en "${prefix}${YELLOW}"
	tmux new-session -s ${sessionName}
	echo -en "${NOCOLOR}"
	exit
}

set_options () {
	echo -e "${prefix} Set Options:"


  
}

kill_session () {
	echo -e "${prefix}"
	echo -en "${prefix}Name of Session to Delete: ${GREEN}"
	read sessionName
	echo -en "${NOCOLOR}"
	echo -e "${prefix}${LIGHTGREEN}Deleting Session: '${GREEN}${sessionName}${LIGHTGREEN}'${NOCOLOR}"
	echo -e "${prefix}${NOCOLOR}..."
	echo -ne "${prefix}${YELLOW}"
	tmux kill-session -t ${sessionName}
	if [[ $? -eq 0 ]]; then
		echo -en "\033[2K\r"      # Clear current line (no error message to display)
	fi
	sleep 2
}



while true; do
	sessions_prompt

	case $USERCHOICE in
		x | X | q | Q | e | e | exit)
			echo -e "${prefix}Exiting..."
			exit
			;;
		n | N)
			create_session
			;;
		d | D)
			kill_session
			;;
		d | D)
			set_options
			;;
		r | R)
			echo -e "${prefix}${PURPLE}Relaunching Script${NOCOLOR}"
			echo -e "${prefix}"
			script_path_with_name && exit
			exit
			;;
		[0-9]* )
			if [[ $USERCHOICE -gt ${#tmux_sessions_names[@]} ]]; then
				echo -en "\033[1A"
				echo -e "${prefix}${ORANGE}Please select a valid choice${NOCOLOR}"
				sleep .75
				# Prevent spamming terminal with too much useless shit (AKA go back and clear 
				lines=$(( ${#tmux_sessions_names[@]} ))
				lines=$(( ${lines} + 10 ))
				for i in $( eval echo {1..$lines} ); do
					echo -en "\033[K"       # Clear text to end of line
					echo -en "\033[1A"      # Move cursor position up 1 row
				done
				echo
				continue
			fi
			USERCHOICE=$(( $USERCHOICE - 1 ))
			break
			;;
		* )
			echo -en "\033[1A"
			echo -e "${prefix}${ORANGE}Please select a valid choice${NOCOLOR}"
			sleep .75
			# Prevent spamming terminal with too much useless shit
			lines=$(( ${#tmux_sessions[@]} ))
			lines=$(( ${lines} + 10 ))
			for i in $( eval echo {1..$lines} ); do
				echo -en "\033[K"       # Clear text to end of line
				echo -en "\033[1A"      # Move cursor position up 1 row
			done
			echo
			continue
			;;
	esac
done

attach_session

exit
kill -9 $PPID
