script_name1=`basename $0`
script_path1=$(dirname $(readlink -f $0))
script_path_with_name="$script_path1/$script_name1"

declare -A tmux_sessions

############################################################
#    Add list of all servers to ./serversToSshToo.sh.
#    Must follow following format:
#
#       server_SERVERNAME_name=""
#       server_SERVERNAME_user=""
#       server_SERVERNAME_port=""
#       server_SERVERNAME_addr=""
#       servers+=('SERVERNAME')
#
#       server_SERVERNAME_2_name="Display Name"
#       server_SERVERNAME_2_user="user2"
#       server_SERVERNAME_2_port="22"
#       server_SERVERNAME_2_addr="10.0.0.2"
#       servers+=('SERVERNAME_2')
#
############################################################


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

# Script Prefix for use with echo
prefix="${GREY}[ ${GREEN}TMUX ${GREY}]${NOCOLOR} "


trap '{ rm -f -- "ssh.error"; }' EXIT


sessions_prompt()
{
        echo -e "${prefix}${GREEN}============================================="
        echo -e "${prefix}${GREEN}           Manage TMUX Sesssions"
        echo -e "${prefix}${GREEN}=============================================${NOCOLOR}"
        tempNum=0

				echo -en "${prefix}   "
				echo -e "${CYAN}Session Name	 Creation Date	Size${NOCOLOR}" | awk '{printf "%-20s %22s %12s\n", $1" "$2, $3" "$4, $5}'
				tmux_sessions=$(tmux list-sessions | awk '{printf "%-20s %3s %2s %8s %12s\n", $1, $6, $7, $8, $10}')
				#tmux_sessions_names=$(tmux list-sessions | awk '{print $1}')
				#tmux_sessions_dates=$(tmux list-sessions | awk '{print $6" "$7" "$8}')
				#tmux_sessions_sizes=$(tmux list-sessions | awk '{print $10}')
				IFS=$'\n' read -r -d '' -a tmux_sessions_names < <( tmux list-sessions | awk '{print $1}' && printf '\0' )
				IFS=$'\n' read -r -d '' -a tmux_sessions_dates < <( tmux list-sessions | awk '{print $6" "$7" "$8}' && printf '\0' )
				IFS=$'\n' read -r -d '' -a tmux_sessions_sizes < <( tmux list-sessions | awk '{print $10}' && printf '\0' )

				char_to_remove=":"
				# Loop over the array and remove the specified character
				for ((i = 0; i < ${#tmux_sessions_names[@]}; i++)); do
					# Remove the character using parameter expansion
					tmux_sessions_names[i]=${tmux_sessions_names[i]//$char_to_remove/}
				done


				#echo -e "${prefix}Sessions:"
				#echo -e "$tmux_sessions"
				#echo
				#echo -e "${prefix}Names:"
				#echo -e "${tmux_sessions_names[@]}"
				#echo
				#echo -e "${prefix}Dates:"
				#echo -e "$tmux_sessions_dates"
				#echo
				#echo -e "${prefix}Sizes:"
				#echo -e "$tmux_sessions_sizes"
				#echo
				#echo
				#echo
				#echo TESTING
				#	echo "name: ${tmux_sessions_names[2]}"

				#echo 
				#echo "FOR LOOP:"
				for ((i = 0; i < ${#tmux_sessions_names[@]}; i++)); do
                tempNum=$(( $tempNum + 1 ))
                name=${tmux_sessions_names[$i]}
                date=${tmux_sessions_dates[$i]}
                size=${tmux_sessions_sizes[$i]}
							#	echo -e "DEBUG:"
							#	echo -e "Name: ${name}"
							#	echo -e "Date: ${date}"
							#	echo -e "Size: ${size}"
							#	
							#	echo -e "____THIS ONE____"
								echo -ne "${prefix}"
                echo -e "${GREEN}${tempNum}.	${NOCOLOR}${name}	${date}	${size}" | awk '{printf "%-3s %-17s %22s %12s\n", $1, $2, $3" "$4" "$5, $6}'

                ## Example
                ##echo -e "1. Production Server"
                ##echo -e "2. Dev Test Server"
                ##echo -e "3. Private Server"
        done
        echo -e "${prefix}${LIGHTGREEN}n. ${LIGHTGREEN}Add New Session${NOCOLOR}"
        echo -e "${prefix}${LIGHTRED}d. ${LIGHTRED}Delete Session${NOCOLOR}"
        echo -e "${prefix}${LIGHTRED}x. ${LIGHTRED}Exit${NOCOLOR}"


        echo -en "${prefix}Select: ${GREEN}"
        read USERCHOICE
        echo -en "${NOCOLOR}"
}

attach_session () {
	echo "User Choice: $USERCHOICE"
	echo "Actual Choice: ${tmux_sessions_names[$USERCHOICE]}"
	tmux attach-session -t ${tmux_sessions_names[$USERCHOICE]}
}

create_session () {
	echo -e "${prefix}"
	echo -en "${prefix}Name of New Session: ${GREEN}"
	read sessionName
	echo -en "${NOCOLOR}"
	echo -e "${prefix}${LIGHTGREEN}Starting Session: '${sessionName}'"
	echo -e "${prefix}..."
	echo -en "${prefix}"
	tmux new-session -s ${sessionName}
	exit
}

kill_session () {
	echo -e "${prefix}"
	echo -en "${prefix}Name of Session to Delete: ${GREEN}"
	read sessionName
	echo -en "${NOCOLOR}"
	echo -e "${prefix}${LIGHTGREEN}Deleting Session: '${sessionName}'"
	echo -e "${prefix}..."
	tmux kill-session -t ${sessionName}
	if [[ $? -ne 0 ]]; then
		echo "ERROR"
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
                                lines=$(( ${lines} + 7 ))
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
                        lines=$(( ${lines} + 7 ))
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
