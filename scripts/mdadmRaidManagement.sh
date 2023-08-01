#!/bin/bash

source ~/dotfiles/scripts/shellTextVariables.sh
source ~/dotfiles/scripts/functions.sh

RAID="md127"

describeState () {
  echo -en "${OnPurple}"
  print_centered_underlined "sudo mdadm -D /dev/${RAID}"

  output="$(sudo mdadm -D /dev/${RAID})"
  output="${output//degraded/${OnRed}degraded${NOCOLOR}}"
  output="${output//removed/${OnRed}removed${NOCOLOR}}"
  output="${output//inactive/${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//active/${GREEN}active${NOCOLOR}}"
  output="${output//clean/${GREEN}clean${NOCOLOR}}"
  echo -e "$output"

  echo -en "${NOCOLOR}${PURPLE}"
  print_centered_underlined
}

procMdstat () {
  echo -en "${OnPurple}"
  print_centered_underlined "cat /proc/mdstat${RAID}"

  output="$(cat /proc/mdstat)"
  output="${output//degraded/${OnRed}degraded${NOCOLOR}}"
  output="${output//removed/${OnRed}removed${NOCOLOR}}"
  output="${output//inactive/${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//active/${GREEN}active${NOCOLOR}}"
  output="${output//clean/${GREEN}clean${NOCOLOR}}"
  echo -e "$output"

  echo -en "${NOCOLOR}${PURPLE}"
  print_centered_underlined
}

listRaidDrivesStatus () {
  echo -en "${OnPurple}"
  print_centered_underlined "mdadm -E /dev/sd[abcd]1"

  output="$(sudo mdadm  -E /dev/sda1)"
  output="${output//degraded/${OnRed}degraded${NOCOLOR}}"
  output="${output//removed/${OnRed}removed${NOCOLOR}}"
  output="${output//clean/${GREEN}clean${NOCOLOR}}"
  output="${output//inactive/${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//: inactive/: ${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//: active/: ${GREEN}active${NOCOLOR}}"
  echo -e "$output"
  echo -en "Press Enter to continue..."
  read 
  echo -en "\033[999D\033[K"
  print_centered_underlined
  output="$(sudo mdadm  -E /dev/sdb1)"
  output="${output//degraded/${OnRed}degraded${NOCOLOR}}"
  output="${output//removed/${OnRed}removed${NOCOLOR}}"
  output="${output//clean/${GREEN}clean${NOCOLOR}}"
  output="${output//inactive/${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//: inactive/: ${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//: active/:${GREEN} active${NOCOLOR}}"
  echo -e "$output"
  echo -en "Press Enter to continue..."
  read 
  echo -en "\033[999D\033[K"
  print_centered_underlined
  output="$(sudo mdadm  -E /dev/sdc1)"
  output="${output//degraded/${OnRed}degraded${NOCOLOR}}"
  output="${output//removed/${OnRed}removed${NOCOLOR}}"
  output="${output//clean/${GREEN}clean${NOCOLOR}}"
  output="${output//inactive/${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//: inactive/: ${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//: active/:${GREEN} active${NOCOLOR}}"
  echo -e "$output"
  echo -en "Press Enter to continue..."
  read 
  echo -en "\033[999D\033[K"
  print_centered_underlined
  output="$(sudo mdadm  -E /dev/sdd1)"
  output="${output//degraded/${OnRed}degraded${NOCOLOR}}"
  output="${output//removed/${OnRed}removed${NOCOLOR}}"
  output="${output//clean/${GREEN}clean${NOCOLOR}}"
  output="${output//inactive/${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//: inactive/: ${ORANGE}${Inv}inactive${NOCOLOR}}"
  output="${output//: active/:${GREEN} active${NOCOLOR}}"
  output="${output//: inactive/: ${ORANGE}${Inv}inactive${NOCOLOR}}"
  echo -e "$output"
  echo -en "Press Enter to continue..."
  read 
  echo -en "\033[999D\033[K"

  echo -en "${NOCOLOR}${PURPLE}"
  print_centered_underlined
}

reassembleDrive () {
  theCommand="sudo mdadm --create /dev/${RAID} --level=5 --raid-devices=4 --assume-clean --metadata=1.2 /dev/sd[a,b,c,d]1"
  echo -en "${OnPurple}"
  print_centered_underlined "$theCommand"

  echo -e  "The Command:\n$theCommand"
  theCommandColor="${theCommand//${RAID}/${GREEN}${RAID}${NOCOLOR}}"
  theCommandColor="${theCommandColor//a\,b\,c\,d/${GREEN}a\,b\,c\,d${NOCOLOR}}"

  echo -e  "${Inv}ARE YOU SURE?!${NOCOLOR}\nWhile this operation did fix the Great Blackout, it can be dangerous."
  echo -e "Please look at the command carefully and make sure you really do want to run it."
  echo -e "\n\n"
  echo -e "Command: \n ${PURPLE}\$${NOCOLOR} ${theCommandColor}"
  echo -en "Continue? [y/N]: "
  read userinput

  echo "Entered '${userinput}'"

  if [[ "$userinput" =~ ^[Yy]$ ]]; then
    echo -en "${GREEN}CONTINUING${NOCOLOR}\n\n"
  else
    echo -en "${ORANGE}CANCELING${NOCOLOR}\n\n"
    return
  fi

  echo -e "SERIOUSLY. You need to be confident you want to continue."
  echo -e "Once again, here's the full command as it will run"
  echo -e "Command: \n \$ $theCommand"
  echo -en "Continue? [y/N]: "
  read userinput

  echo "Entered '${userinput}'"

  if [[ "$userinput" =~ ^[Yy]$ ]]; then
    echo -en "${GREEN}CONTINUING${NOCOLOR}\n\n"
  else
    echo -en "${ORANGE}CANCELING${NOCOLOR}\n\n"
    return
  fi

  echo -en "${OnPurple}"
  print_centered_underlined "REBUILD RAID ARRAY"

  # Execute the command and rebuild the Array
  $theCommand

  #sudo mdadm --create /dev/${RAID} --level=5 --raid-devices=4 --assume-clean --metadata=1.2 /dev/sd[a,b,c,d]1

  echo -en "${NOCOLOR}${PURPLE}"
  print_centered_underlined
}

stopRaidArray () {
  echo -en "${OnPurple}"
  print_centered_underlined "sudo mdadm --stop /dev/${RAID}"
  
  sudo mdadm --stop /dev/${RAID}

  echo -en "${NOCOLOR}${PURPLE}"
  print_centered_underlined
}


prompt() {
  echo -e "${PURPLE}What action would you like to perform on the RAID?${NOCOLOR}"
	
	echo -e "${GREEN}------------  Test/Diagnostic  --------------${NOCOLOR}"
	echo -e "1. ${PURPLE}mdadm -D /dev/md127${NOCOLOR} --- Describe State of RAID Device"
	echo -e "2. ${PURPLE}cat /proc/mdstat${NOCOLOR}"
	echo -e "3. ${PURPLE}mdadm -E /dev/sd[abcd]1${NOCOLOR} --- List all Raid Devices' Status"
	echo -e "8. ${ORANGE}Stop Array${NOCOLOR}"
  echo -e "9. ${ORANGE}Rebuild Array${NOCOLOR} - Use if a drive gets removed. ${Inv}This fixed the Great Blackout${NOCOLOR}"
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
			if [[ $USERCHOICE -eq 1 ]]; then # Show raid Device status
				describeState
			elif [[ $USERCHOICE -eq 2 ]]; then # Restart Interfaces
        procMdstat
			elif [[ $USERCHOICE -eq 3 ]]; then # Restart Interfaces
        listRaidDrivesStatus
			elif [[ $USERCHOICE -eq 8 ]]; then # Restart Interfaces
        stopRaidArray
			elif [[ $USERCHOICE -eq 9 ]]; then # Restart Interfaces
        reassembleDrive
			fi
			;;
	esac
done


echo
echo -e "${GREEN}===============================${NOCOLOR}"
echo -e "${GREEN}==            DONE           ==${NOCOLOR}"
echo -e "${GREEN}===============================${NOCOLOR}"
