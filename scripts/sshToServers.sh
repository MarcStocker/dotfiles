#!/bin/bash

script_name1=`basename $0`
script_path1=$(dirname $(readlink -f $0))
script_path_with_name="$script_path1/$script_name1"
server_path_with_name="$script_path1/.serversToSshToo.sh"

declare -A server_names
declare -A server_users
declare -A server_ports
declare -A server_addrs
source $script_path1/.serversToSshToo.sh

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
prefix="${GREY}[ ${CYAN}SSH ${GREY}]${NOCOLOR} "


trap '{ rm -f -- "ssh.error"; }' EXIT


connect_prompt()
{
        echo -e "${prefix}${CYAN}============================================="
        echo -e "${prefix}           Connect to SSH Servers"
        echo -e "${prefix}${CYAN}============================================="
        tempNum=0
        for i in ${servers[@]}; do
                tempNum=$(( $tempNum + 1 ))
                #name=$(eval "echo \$server_${i}_name")
                #user=$(eval "echo \$server_${i}_user")
                #port=$(eval "echo \$server_${i}_port")
                #addr=$(eval "echo \$server_${i}_addr")

                name=${server_names[$i]}
                user=${server_users[$i]}
                port=${server_ports[$i]}
                addr=${server_addrs[$i]}

                ##echo -e "${PREFIX}${ORANGE}Loop #${tempNum}"
                ##echo -e "${PREFIX}${ORANGE}Name: ${name}"
                ##echo -e "${PREFIX}${ORANGE}User: ${user}"
                ##echo -e "${PREFIX}${ORANGE}Port: ${port}"
                ##echo -e "${PREFIX}${ORANGE}Addr: ${addr}"
                ##echo


                echo -e "${prefix}${GREEN}${tempNum}. ${NOCOLOR}${name} "
                #echo -e "${prefix}     ${GREY}${user}${NOCOLOR}@${GREY}${addr}${NOCOLOR}"

                ## Example
                ##echo -e "1. Production Server"
                ##echo -e "2. Dev Test Server"
                ##echo -e "3. Private Server"
        done
        echo -e "${prefix}${LIGHTGREEN}e. ${LIGHTGREEN}Edit${NOCOLOR}"
        echo -e "${prefix}${LIGHTRED}x. ${LIGHTRED}Exit${NOCOLOR}"


        echo -en "${prefix}Select: ${GREEN}"
        read USERCHOICE
        echo -en "${NOCOLOR}"
}

connect()
{
    echo "Userchoice: $USERCHOICE"
        name=${server_names[${servers[$USERCHOICE]}]}
        user=${server_users[${servers[$USERCHOICE]}]}
        port=${server_ports[${servers[$USERCHOICE]}]}
        addr=${server_addrs[${servers[$USERCHOICE]}]}
        #name=$(eval "echo \$server_${servers[$USERCHOICE]}_name")
        #user=$(eval "echo \$server_${servers[$USERCHOICE]}_user")
        #port=$(eval "echo \$server_${servers[$USERCHOICE]}_port")
        #addr=$(eval "echo \$server_${servers[$USERCHOICE]}_addr")
        echo -e "${prefix}${PURPLE}Connecting to ${CYAN}${name}${NOCOLOR}:"
        echo -e "${prefix}  ${GREEN}ssh -p ${port} ${user}@${addr}${NOCOLOR}"
        # connect to the server
        ssh -p ${port} ${user}@${addr} 2> ssh.error
        exitStatus=$?
}

exit_status()
{
        case $exitStatus in
        0 | 1 | 130 | 127 )
                echo -e "\n${prefix}${GREY}Exit Status:${NOCOLOR} $exitStatus"
                echo -e "${prefix}${LIGHTGREEN}Connection Closed Gracefully"
                exit 0;;
        esac

        errorCode=`cat ssh.error | awk '{ printf $7 }' | sed 's/://'`
        errorDesc=`cut -d' ' -f8- ssh.error`
        errorFull=`cut -d' ' -f1- ssh.error`

        if [[ $errorFull = "Connection to ${addr} closed by remote host." ]]; then
                echo -e "${prefix}Connection closed by host."
                exit 0
        elif [[ $errorFull = "Connection to ${addr} closed." ]]; then
                echo -e "${prefix}Connection closed."
                exit 0
        else
                if [[ $errorCode -eq 120 ]]; then
                        errorColor=${RED}
                else
                        errorColor=${YELLOW}
                fi

                echo -e "\n${prefix}${errorColor}=========================================="
                echo -e "${prefix}${errorColor}=  Failed to connect or connection lost  ="
                echo -e "${prefix}${errorColor}=========================================="
                echo -e "${prefix}${YELLOW}Exit Status: ${WHITE}${exitStatus}"
                echo -e "${prefix}${YELLOW}Error Code: ${WHITE}${errorCode}"
                echo -e "${prefix}${YELLOW}Error Text: ${WHITE}${errorDesc}"
                echo -e "${prefix}${YELLOW}Full Error: ${GREY}`cut -d' ' -f1- ssh.error`${NOCOLOR}"
        fi
}


while true; do
        connect_prompt
        case $USERCHOICE in
                x | X | q | Q | exit)
                        echo -e "${prefix}Exiting..."
                        exit
                        ;;
                e | E)
                        if test -e "$server_path_with_name"; then
                        echo -n ""
                        else
                          echo -e "${prefix}${ORANGE}Creating File...${NOCOLOR}"

                          echo "############################################################" >> $server_path_with_name
                          echo "#    Add list of all servers to $server_path_with_name " >> $server_path_with_name
                          echo "#    Must follow following format:" >> $server_path_with_name
                          echo "#" >> $server_path_with_name
                          echo "#       servers+=('SERVERNAME')""" >> $server_path_with_name
                          echo "#       server_names[\${servers[-1]}]=""" >> $server_path_with_name
                          echo "#       server_users[\${servers[-1]}]=""" >> $server_path_with_name
                          echo "#       server_ports[\${servers[-1]}]=""" >> $server_path_with_name
                          echo "#       server_addrs[\${servers[-1]}]=""" >> $server_path_with_name
                          echo "#" >> $server_path_with_name
                          echo "#       servers+=('SERVERNAME_2')" >> $server_path_with_name
                          echo "#       server_names[\${servers[-1]}]=\"Display Name\"" >> $server_path_with_name
                          echo "#       server_users[\${servers[-1]}]=\"user2\"" >> $server_path_with_name
                          echo "#       server_ports[\${servers[-1]}]=\"22\"" >> $server_path_with_name
                          echo "#       server_addrs[\${servers[-1]}]=\"10.0.0.2\"" >> $server_path_with_name
                          echo "#" >> $server_path_with_name
                          echo "############################################################" >> $server_path_with_name
                          echo "" >> $server_path_with_name
                          echo "servers+=('main_server')" >> $server_path_with_name
                          echo "server_names[\${servers[-1]}]=\"Display Name\"" >> $server_path_with_name
                          echo "server_users[\${servers[-1]}]=\"user\"" >> $server_path_with_name
                          echo "server_ports[\${servers[-1]}]=\"22\"" >> $server_path_with_name
                          echo "server_addrs[\${servers[-1]}]=\"192.168.1.1\"" >> $server_path_with_name
                          echo "" >> $server_path_with_name
                        fi
                          echo -e "${prefix}${PURPLE}Editing File...${NOCOLOR}"
                          sleep .5
                          vim -f --not-a-term $server_path_with_name


                        echo -e "${prefix}${PURPLE}Finished Editing${NOCOLOR}"
                        echo -e "${prefix}${PURPLE}Relaunching Script${NOCOLOR}"
                        echo -e "${prefix}"
                        exec "$0"
                        #script_path_with_name && exit
                        #exit
                        ;;
                r | R)
                        echo -e "${prefix}${PURPLE}Relaunching Script${NOCOLOR}"
                        echo -e "${prefix}"
                        script_path_with_name && exit
                        exit
                        ;;
                [0-9]* )
                        if [[ $USERCHOICE -gt ${#servers[@]} ]]; then
                                echo -en "\033[1A"
                                echo -e "${prefix}${ORANGE}Please select a valid choice${NOCOLOR}"
                                sleep .75
                                # Prevent spamming terminal with too much useless shit
                                lines=$(( ${#servers[@]} ))
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
                        lines=$(( ${#servers[@]} ))
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

connect

exit_status

exit
kill -9 $PPID
