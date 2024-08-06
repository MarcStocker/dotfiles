#!/bin/bash

source ~/dotfiles/scripts/shellTextVariables.sh
source ~/dotfiles/scripts/functions.sh

RAID="md126"

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
  retrieveRaidDiskLoc

  echo -en "${OnPurple}"
  print_centered_underlined "mdadm -E /dev/sd[${driveletter[0]}${driveletter[1]}${driveletter[2]}${driveletter[3]}]"

  output="$(sudo mdadm  -E /dev/${raidArray[0]})"
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
  output="$(sudo mdadm  -E /dev/${raidArray[1]})"
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
  output="$(sudo mdadm  -E /dev/${raidArray[2]})"
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
  output="$(sudo mdadm  -E /dev/${raidArray[3]})"
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
  retrieveRaidDiskLoc

  theCommand="sudo mdadm --create /dev/${RAID} --level=5 --raid-devices=4 --assume-clean --metadata=1.2 /dev/sd[${driveletter[0]},${driveletter[1]},${driveletter[2]},${driveletter[3]}]1"
  echo -en "${OnPurple}"
  print_centered_underlined "$theCommand"

  echo -e  "The Command:\n$theCommand"
  theCommandColor="${theCommand//${RAID}/${GREEN}${RAID}${NOCOLOR}}"
  echo "${driveletter[0]}\,${driveletter[1]}\,${driveletter[2]}\,${driveletter[3]}"
  theCommandColor="${theCommandColor//${driveletter[0]}\,${driveletter[1]}\,${driveletter[2]}\,${driveletter[3]}/${GREEN}${driveletter[0]}\,${driveletter[1]}\,${driveletter[2]}\,${driveletter[3]}${NOCOLOR}}"

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

  #sudo mdadm --create /dev/${RAID} --level=5 --raid-devices=4 --assume-clean --metadata=1.2 /dev/sd[a,b,c,f]1

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

retrieveRaidDiskLoc () {
  echo -e "What is the LABEL of the drive? (ex. "Rokian:127", enter nothing to default to "linux_raid_member")\n"
  echo -en "LABEL: "
  read driveLabel

  echo "Entered '${driveLabel}'"
  if [ -z "$driveLabel" ]; then
    driveLabel='linux_raid_member'
    echo "Entered '${driveLabel}'"
  fi
  raidArray=($(lsblk -f | awk -v term="$driveLabel" '$0 ~ term {gsub(/[^a-zA-Z0-9]/, "", $1); print $1}'))
  echo "-- Array --"
  echo "Disk 1: ${raidArray[0]}"
  echo "Disk 2: ${raidArray[1]}"
  echo "Disk 3: ${raidArray[2]}"
  echo "Disk 4: ${raidArray[3]}"
  echo "-----------"

  driveletter=()
  for ((i = 0; i < ${#raidArray[@]}; i++)); do
    disk="${raidArray[$i]}"
    last_letter="${disk: -2: 1}"  # Extract the last letter
    driveletter+=("$last_letter")
    #echo "Disk $((i + 1)): $disk (Last letter: $last_letter)"
  done
}


prompt() {
  echo -e "${PURPLE}What action would you like to perform on the RAID?${NOCOLOR}"
	
	echo -e "${GREEN}------------  Test/Diagnostic  --------------${NOCOLOR}"
	echo -e "1. ${PURPLE}mdadm -D /dev/md126${NOCOLOR} --- Describe State of RAID Device"
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
