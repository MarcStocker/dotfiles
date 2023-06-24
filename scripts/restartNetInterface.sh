#!/bin/bash

source ~/dotfiles/scripts/shellTextVariables.sh

interface1="enp7s0"
interface2="enp8s0"


interfaceUp () {
	echo -e "-${GREEN}UP${NOCOLOR}"
	sudo ifup ${1}
	echo -en "${NOCOLOR}"
}
interfaceDown () {
	echo -e "-${RED}Down${NOCOLOR}"
	sudo ifdown ${1}
	echo -en "${NOCOLOR}"
}

restartInterfaces () {
	echo -e "${GREEN}===============================${NOCOLOR}"
	echo -e "${GREEN}== Restart Network Interface ==${NOCOLOR}"
	echo -e "${GREEN}===============================${NOCOLOR}"

	echo -e "${CYAN}Restarting: ${NOCOLOR}${interface1}"
	interfaceDown ${interface1}
	interfaceUp ${interface1}

	echo -e "${CYAN}Restarting: ${NOCOLOR}${interface2}"
	interfaceDown ${interface2}
	interfaceUp ${interface2}
}

flushNetworking () {
	echo -e "${GREEN}===============================${NOCOLOR}"
	echo -e "${GREEN}==      Flush   IP   Addr    ==${NOCOLOR}"
	echo -e "${GREEN}===============================${NOCOLOR}"

	echo -en "${YELLOW}"
	sudo ip addr flush $interface1
	echo -en "${ORANGE}"
	sudo ip addr flush $interface2
	echo -en "${PURPLE}"
	sudo systemctl restart networking
	echo -en "${NOCOLOR}"
  
}

testing () {
	echo -e "${GREEN}===============================${NOCOLOR}"
	echo -e "${GREEN}== TESTING  TESTING  TESTING ==${NOCOLOR}"
	echo -e "${GREEN}===============================${NOCOLOR}"
	echo
	echo -e "${CYAN}Testing Ping to: ${GREEN}192.168.0.1 (Router)${NOCOLOR}"
	ping -c 4 192.168.0.1
	echo -e "${GRAY}------------------------------------------------------------------${NOCOLOR}"
	echo -e "${GRAY}------------------------------------------------------------------${NOCOLOR}"
	echo -e "${CYAN}Testing Ping to: ${GREEN}192.168.1.42 (Internal)${NOCOLOR}"
	ping -c 4 192.168.1.42
	echo -e "${GRAY}------------------------------------------------------------------${NOCOLOR}"
	echo -e "${GRAY}------------------------------------------------------------------${NOCOLOR}"
	echo -e "${CYAN}Testing Ping to: ${GREEN}www.google.com (External)${NOCOLOR}"
	ping -c 4 www.google.com
	echo -e "${GRAY}------------------------------------------------------------------${NOCOLOR}"
	echo -e "${GRAY}------------------------------------------------------------------${NOCOLOR}"
}

editFile () {
	echo -e "${PURPLE}Which file would you like to edit?${NOCOLOR}"
	echo -e "1. /etc/${CYAN}interfaces${NOCOLOR}"
	echo -e "2. /etc/${CYAN}hosts${NOCOLOR}"
	echo -e "3. /etc/${CYAN}hostname${NOCOLOR}"
	echo -e "4. /etc/${CYAN}resolve.conf${NOCOLOR}"
	echo -e "5. Bring all Interfaces ${GREEN}UP${NOCOLOR}"
	echo
	echo -en "${prefix} Select: ${GREEN}"
	read -r USERCHOICE
	echo -en "${NOCOLOR}"

	case $USERCHOICE in
		x | X | q | Q | exit | e)
			echo -e "Cancel..."
			echo
			break
			;;
		[0-9]*)
			if [[ $USERCHOICE -eq 1 ]]; then # Test Network
				theFile="/etc/network/interfaces"
			elif [[ $USERCHOICE -eq 2 ]]; then # Restart Interfaces
				theFile="/etc/hosts"
			elif [[ $USERCHOICE -eq 3 ]]; then # Restart Interfaces
				theFile="/etc/hostname"
			elif [[ $USERCHOICE -eq 4 ]]; then # Restart Interfaces
				theFile="/etc/resolve.conf"
			elif [[ $USERCHOICE -eq 5 ]]; then # Restart Interfaces
				interfaceUp
			fi
			;;
	esac

  vim -f --not-a-term $theFile
}

listInterfaceDevices () {
	dashes=$(printf "%80s")
	echo -e "${DARKGREY}${dashes// /=}\n${dashes// /=} ${NOCOLOR}"
  ip -c a | head -n 25
	echo -e "${DARKGREY}${dashes// /=}\n${dashes// /=} ${NOCOLOR}"
	echo
}

prompt() {
  echo -e "${PURPLE}What action would you like to perform on the Network?${NOCOLOR}"
	
	echo -e "${GREEN}------------  Test/Diagnostic  --------------${NOCOLOR}"
	echo -e "1. Test Ping"
	echo -e "2. Show all Interfaces ${GREY}(ip a)${NOCOLOR}"
	echo -e "3. Bring all Interfaces ${GREEN}UP${NOCOLOR}"
	echo -e "${YELLOW}-----------     Edit Files    --------------${NOCOLOR}"
	echo -e "4. Edit Interwork Files${NOCOLOR}"
	echo -e "${YELLOW}------     Restart/Flush Network    --------${NOCOLOR}"
	echo -e "5. Flush IP Addr ${GREY}(ip addr flush/system ctl restart networking${NOCOLOR}"
	echo -e "6. Restart all Interfaces${NOCOLOR}"
	echo -e "7. Bring all Interfaces ${RED}DOWN${NOCOLOR}"
	echo -e "E. Abort"

	echo
	echo -en "${prefix} Select: ${GREEN}"
	read -r USERCHOICE
	echo -en "${NOCOLOR}"
}

while true; do
	prompt
	case $USERCHOICE in
		x | X | q | Q | exit | e)
			echo -e "${RED}Exiting...${NOCOLOR}"
			exit 
			;;
		[0-9]*)
			if [[ $USERCHOICE -eq 1 ]]; then # Test Network
				testing
			elif [[ $USERCHOICE -eq 2 ]]; then # Restart Interfaces
				listInterfaceDevices
			elif [[ $USERCHOICE -eq 3 ]]; then # Restart Interfaces
				interfaceUp
			elif [[ $USERCHOICE -eq 4 ]]; then # Restart Interfaces
				editFile
			elif [[ $USERCHOICE -eq 5 ]]; then # Interfaces UP
				flushNetworking
			elif [[ $USERCHOICE -eq 6 ]]; then # Interfaces DOWN
				restartInterfaces
			elif [[ $USERCHOICE -eq 7 ]]; then # Interfaces DOWN
				interfaceDown
			fi
			;;
	esac
done


echo
echo -e "${GREEN}===============================${NOCOLOR}"
echo -e "${GREEN}==            DONE           ==${NOCOLOR}"
echo -e "${GREEN}===============================${NOCOLOR}"
