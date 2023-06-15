#!/bin/bash

##########################################################
### Description:
###		Script will display all Docker Containers based off
###		a folder containing folders of docker-compose.yml
###		files.
###	
###	File structure script will work with:
###		/FolderToPointTo/nameOfDocker/docker-compose.yml
###	
### NOTE:
###	  Folders containing the docker-compose.yml files
###	  MUST be the exact name of the docker container
##########################################################

source ~/dotfiles/scripts/shellTextVariables.sh
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
prefix="${GRAY}[ ${CYAN}Update Container ${GRAY}]${NOCOLOR}"

rokianDockerFolder="/mnt/ServerBackup/docker/compose"
HADockerFolder="/docker/compose"
if [[ -d $rokianDockerFolder ]]; then dockerFolder=$rokianDockerFolder; fi
if [[ -d $HADockerFolder ]]; then dockerFolder=$HADockerFolder; fi
# ----------------------------------

eprint() {
  echo -e "${GRAY}[ ${CYAN}Update Container ${GRAY}]${NOCOLOR} $1"
}
lprint() {
  echo -en "${GRAY}[ ${CYAN}Update Container ${GRAY}]${NOCOLOR} $1"
}
rprint() {
  echo -e "\t\t${NOCOLOR} $1"
}
runContainerRebuild() {
  #echo -en "${GRAY}[ ${CYAN} $(1) ${GRAY}]${NOCOLOR} $1"
  #echo -en "${GRAY}[ ${CYAN} $(allContainers) ${GRAY}]${NOCOLOR} ${allContainers[$1]}"
	echo
	echo
	if [[ ${allContainers[$1]} == "gluetun" ]]; then echo -n
		eprint "GLUETUN SELECTED: Rebuilding all Services using network mode 'container:gluetun'"

		lprint
		echo -e "${PURPLE}Do you wish to rebuild and start up STOPPED CONTAINERS as well?${NOCOLOR}"
		lprint
		echo -en "Yes/No: ${GREEN}"
		read -r USERCHOICE
		echo -en "${NOCOLOR}"

		eprint "==== REBUILDING GLUETUN ===="
		stopContainer ${allContainers[$1]}
		removeContainer ${allContainers[$1]}
		recreateContainer ${allContainers[$1]}
		

		if [[ $USERCHOICE == "yes" || $USERCHOICE == "y" ]]; then
			rebuildAll=TRUE
		else
			rebuildAll=FALSE
		fi


		vpnDockers=("frigate" "prowlarr" "qbittorrent" "overseerr" "sonarr" "radarr" "lidarr" "bazarr")
		for i in ${!vpnDockers[@]}; do
			container=${vpnDockers[i]}
			echo "Rebuilding ${container}"
			isRunning=`docker ps | grep ${container}`
			isRunning=$?
			if [[ $isRunning -eq 1 ]]; then echo -n # Only rebuild if currently running
				#echo "--------- It's not running ----------"
				if [[ $rebuildAll == "TRUE" ]]; then
					eprint "==== REBUILDING $container ===="
					stopContainer $container
					removeContainer $container
					recreateContainer $container
					eprint "==== $container COMPLETE ===="
					echo
				fi
			else
				#echo "--------- It's running ----------"
				eprint "==== REBUILDING $container ===="
				stopContainer $container
				removeContainer $container
				recreateContainer $container
				eprint "==== $container COMPLETE ===="
				echo
			fi
		done
		# Double check to make sure everything is running properly. 
		vpnDocker+=("gluetun")
		for i in ${!vpnDockers[@]}; do
			container=${vpnDockers[i]}
			isRunning=`docker ps | grep ${container}`
			isRunning=$?
			if [[ $isRunning -eq 1 ]]; then echo -n # Only rebuild if currently running
				lprint
				echo -e "${RED}=== $container is not running ===${NOCOLOR}"
			else
				lprint
				echo -e "${GREEN}=== $container is running ===${NOCOLOR}"
			fi
		done
		exit
	else
		stopContainer ${allContainers[$1]}
		removeContainer ${allContainers[$1]}
		recreateContainer ${allContainers[$1]}
	fi


#	echo "...Waiting for Container to wake up"
#	sleep 3.5
#	# Double Check to make sure the container is running again. 
#
#	isRunning=`docker ps | grep ${allContainers[$1]}`
#	isRunning=$?
#	if [[ $isRunning -eq 1 ]]; then echo -n
#	else
#		echo "Container still is not running, reattempting to rebuild/update"
#		runContainerRebuild ${allContainers[$1]}
#	fi
}
stopContainer() {
        response=$(docker stop $1)
        #if [[ $reponse != "$1" ]]; then
                #eprint "${RED}ERROR:${NOCOLOR} Something went wrong"
        #fi
}

startContainer() {
        #eprint "Starting container ${NOCOLOR}'${GRAY}$1${NOCOLOR}'"
        #response=$(docker start $1)
  #eprint "Recreating container '${GREY}$1${NOCOLOR}'"
        #$(cd ${dockerFolder}/$1/; docker-compose pull;)
        $(cd ${dockerFolder}/$1/; docker-compose up -d;)
        #if [[ $reponse != "$1" ]]; then
                #eprint "${RED}ERROR:${NOCOLOR} Something went wrong"
        #fi
}

removeContainer() {
        eprint "Removing container ${NOCOLOR}'${GRAY}$1${NOCOLOR}'"
        $(cd ${dockerFolder}/$1/; docker-compose down;)
				eprint "Pruning Images"
        $(docker image prune -f &>/dev/null)
				eprint "Pruning Volumes"
        $(docker volume prune -f &>/dev/null)
}

recreateContainer() {
  eprint "Recreating container '${GREY}$1${NOCOLOR}'"
        $(cd ${dockerFolder}/$1/; docker-compose pull;)
        $(cd ${dockerFolder}/$1/; docker-compose up -d;)
}

prompt() {
  eprint "${PURPLE}What action would you like to perform on your Docker Containers?${NOCOLOR}"

	eprint "1. Upgrade Container"
	eprint "2. Start Container"
	eprint "3. Restart Container"
	eprint "4. Stop Container"
	eprint "5. Remove Container"
	eprint "E. Abort"

	echo
	echo -en "${prefix} Select: ${GREEN}"
	read -r USERCHOICE
	echo -en "${NOCOLOR}"
}

containerSelect() {
	allContainers=($(ls -1 ${dockerFolder}))
	declare -a removeNonContainers

	printContainers=""
	numSelect=0
	for i in ${!allContainers[@]}; do
		container=${allContainers[i]}
		if [[ -e "${dockerFolder}/${container}/docker-compose.yml" ]]; then echo -n
		else
			continue # Skip if no docker-compose.yml file present in folder
		fi
		numSelect=$(( $numSelect + 1 ))
		removeNonContainers+=("${container}")
		
		isRunning=`docker ps | grep ${container}`
		isRunning=$?
		rem=$(($numSelect % 2))
		tputRED=$(tput setaf 1)		# Container IS NOT running, set number to RED
		tputGREEN=$(tput setaf 2)	# Container   IS   running, set number to GREEN
		tputnormal=$(tput sgr0) 
		if [[ $isRunning -eq 1 ]]; then
			printf "%-4s %-19s \n" "${tputRED}${numSelect}." "${tputnormal}${container}"
		else
			printf "%-4s %-19s \n" "${tputGREEN}${numSelect}." "${tputnormal}${container}"
		fi
	done | column 

	for i in ${!allContainers[@]}; do
		container=${allContainers[i]}
		if [[ -e "${dockerFolder}/${container}/docker-compose.yml" ]]; then echo -n
		else
			continue
		fi
		removeNonContainers+=("${container}")
	done #| column 


# REMOVE ALL ENTRIES THAT DO NO CONTAIN DOCKER-COMPOSE FILES
# If we do not, then all those folders mess up the number selection.
	unset allContainers[@]
	allContainers=("${removeNonContainers[@]}")

	echo -en "${prefix} Select: ${GREEN}"
	read -r USERCHOICE
	echo -en "${NOCOLOR}"
}


prompt
while true; do
	case $USERCHOICE in 
		x | X | q | Q | exit)
			eprint "Exiting..."
			exit
			;;
		[0-9]* )
			if [[ $USERCHOICE -gt 5 ]]; then
				echo -en "${prefix} ${ORANGE}Please select a valid choice${NOCOLOR}"
				sleep 1.75 
        echo -en "${RESET_LINE}" 	# Clear text to end of line
				echo -en "${CURSORUP}"
				echo -en "${CLR_LINE_END}"

        echo -en "${prefix} Select: ${GREEN}"
        read USERCHOICE
        echo -en "${NOCOLOR}"
        USERCHOICE=$(( $USERCHOICE -1 ))
#>>>>>>> a5c98b75490a9f8787265269415e51c8ac49cb12
				continue
			fi
			if   [[ $USERCHOICE -eq 1 ]]; then # Upgrade
				action="upgrade"
				eprint "${PURPLE}Which container would you like to ${GREEN}UPGRADE${PURPLE} the image for?${NOCOLOR}"
				containerSelect
			elif [[ $USERCHOICE -eq 2 ]]; then # Start
				action="start"
				eprint "${PURPLE}Which container would you like to ${GREEN}START${PURPLE}?${NOCOLOR}"
				containerSelect
			elif [[ $USERCHOICE -eq 3 ]]; then # Restart
				action="restart"
				eprint "${PURPLE}Which container would you like to ${ORANGE}RESTART${PURPLE}?${NOCOLOR}"
				containerSelect
			elif [[ $USERCHOICE -eq 4 ]]; then # Stop 
				action="stop"
				eprint "${PURPLE}Which container would you like to ${RED}STOP${PURPLE}?${NOCOLOR}"
				containerSelect
			elif [[ $USERCHOICE -eq 5 ]]; then # Remove
				action="remove"
				eprint "${PURPLE}Which container would you like to ${RED}REMOVE${PURPLE}?${NOCOLOR}"
				containerSelect
			fi

			break
			;;
		* )
			eprint "Nice try dick-nuts.."
      sleep .75 
      echo -en "${RESET_LINE}" 	# Clear text to end of line
      echo -en "${CURSORUP}"
      echo -en "${CLR_LINE_END}"

      echo -en "${prefix} Select: ${GREEN}"
      read USERCHOICE
      echo -en "${NOCOLOR}"
			break
			;;
	esac
done

while true; do
	case $USERCHOICE in 
		x | X | q | Q | exit)
			eprint "Exiting..."
			exit
			;;
		[0-9]* )
			USERCHOICE=$(( $USERCHOICE - 1 ))
			#echo "You chose a number!" 
			if [[ $USERCHOICE -gt ${#allContainers[@]} ]]; then
#<<<<<<< HEAD
				#echo -en "\033[1A"
				#eprint "${ORANGE}Please select a valid choice${NOCOLOR}. You chose '$USERCHOICE'"
				#sleep .75
#=======
				#echo -en "\033[1A"
				#eprint "${ORANGE}Please select a valid choice${NOCOLOR}"
				#sleep .75
				#continue

				echo -en "${prefix} ${ORANGE}Please select a valid choice${NOCOLOR}"
				sleep 1.75 
        echo -en "${RESET_LINE}" 	# Clear text to end of line
				echo -en "${CURSORUP}"
				echo -en "${CLR_LINE_END}"

        echo -en "${prefix} Select: ${GREEN}"
        read USERCHOICE
        echo -en "${NOCOLOR}"
        USERCHOICE=$(( $USERCHOICE -1 ))
#>>>>>>> a5c98b75490a9f8787265269415e51c8ac49cb12
				continue

			fi
			break
			;;
		* )
			#echo "You chose anything that wasn't a number!" 

			for i in ${!allContainers[@]}; do
				container=${allContainers[i]}
				#echo "Container: ${container}"
				#echo "User Choice ${USERCHOICE}"
				if [[ "$container" == "$USERCHOICE" ]]; then 
				for i in ${!allContainers[@]}; do # Find the container's number and resave USERCHOICE
					container=${allContainers[i]}
					numSelect=$(( $numSelect + 1 ))
					if [[ "$USERCHOICE" == "${container}" ]]; then
						#echo "Found '$USERCHOICE'"
						USERCHOICE=$numSelect # The container's coorosponding number has been found
						USERCHOICE=$(( $USERCHOICE - 1 ))
						#echo "Resaved as: $USERCHOICE"
						break
					fi
				done
					runContainerRebuild $USERCHOICE
					#stopContainer ${allContainers[$USERCHOICE]}
					#removeContainer ${allContainers[$USERCHOICE]}
					#recreateContainer ${allContainers[$USERCHOICE]}
					exit
				else
					#echo -en "${prefix} Bad choice\n\n"
					continue
				fi
				removeNonContainers+=("${container}")
			done #| column 


      echo -en "${prefix} ${ORANGE}Please select a valid choice${NOCOLOR}"
      sleep .75 
      echo -en "${RESET_LINE}" 	# Clear text to end of line
      echo -en "${CURSORUP}"
      echo -en "${CLR_LINE_END}"

      echo -en "${prefix} Select: ${GREEN}"
      read USERCHOICE
      echo -en "${NOCOLOR}"
      USERCHOICE=$(( $USERCHOICE -1 ))
			continue
			;;
	esac
done

# Check to see if it's Gluetun (VPN) that we're restarting
# If yes, restart everything that uses it as a network interface

echo "Come on"
echo ${allContainers[$USERCHOICE]}
echo "Come on"


if   [[ $action == "upgrade" ]]; then
	echo "upgrade"
	runContainerRebuild ${USERCHOICE}
elif [[ $action == "start" ]]; then
	startContainer ${allContainers[$USERCHOICE]}
elif [[ $action == "restart" ]]; then
	stopContainer ${allContainers[$USERCHOICE]}
	startContainer ${allContainers[$USERCHOICE]}
elif [[ $action == "stop" ]]; then
	stopContainer ${allContainers[$USERCHOICE]}
elif [[ $action == "remove" ]]; then
	stopContainer ${allContainers[$USERCHOICE]}
	removeContainer ${allContainers[$USERCHOICE]}
fi

`docker logs -f ${allContainers[$USERCHOICE]}`
wait 5

exit
