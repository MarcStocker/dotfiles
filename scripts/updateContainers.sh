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
source ~/dotfiles/scripts/functions.sh
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
tputRED=$(tput setaf 1)		
tputGREEN=$(tput setaf 2)	
tputCYAN=$(tput setaf 6)	
tputGREY=$(tput setaf 7)	
tputnormal=$(tput sgr0) 
prefix="${GRAY}[ ${CYAN}Update Container ${GRAY}]${NOCOLOR}"
prefixtput="${tputGREY}[ ${tputCYAN}Update Container ${tputGREY}]${tputnormal}"

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
	if [[ ${allContainers[$1]} == "gluetun" ]]; then echo -n
		eprint "GLUETUN SELECTED: Rebuilding all Services using network mode 'container:gluetun'"

		lprint
		echo -e "${PURPLE}Do you wish to rebuild and start up STOPPED CONTAINERS as well?${NOCOLOR}"
		lprint
		echo -en "Yes/No: ${GREEN}"
		read -r USERCHOICE
		echo -en "${NOCOLOR}"

		if [[ $USERCHOICE == "yes" || $USERCHOICE == "y" ]]; then
			rebuildAll=TRUE
		else
			rebuildAll=FALSE
		fi

		eprint "==== REBUILDING GLUETUN ===="
		stopContainer ${allContainers[$1]}
		removeContainer ${allContainers[$1]}
		recreateContainer ${allContainers[$1]}
		
		vpnDockers=("frigate" "prowlarr" "qbittorrent" "overseerr" "sonarr" "radarr" "lidarr" "bazarr" "readarr" "nzbhydra2" "lazylibrarian" "reiverr")
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
		vpnDockers+=("gluetun")
		for i in ${!vpnDockers[@]}; do
			container=${vpnDockers[i]}
			isRunning=`docker ps | grep ${container}`
			isRunning=$?
			if [[ $isRunning -eq 1 ]]; then echo -n 
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
        #$(cd ${dockerFolder}/$1/; docker compose pull;)
        $(cd ${dockerFolder}/$1/; docker compose up -d;)
        #if [[ $reponse != "$1" ]]; then
                #eprint "${RED}ERROR:${NOCOLOR} Something went wrong"
        #fi
}

removeContainer() {
        eprint "Removing container ${NOCOLOR}'${GRAY}$1${NOCOLOR}'"
        $(cd ${dockerFolder}/$1/; docker compose down;)
				eprint "Pruning Images"
        $(docker image prune -f &>/dev/null)
				eprint "Pruning Volumes"
        $(docker volume prune -f &>/dev/null)
}

recreateContainer() {
  eprint "Recreating container '${GREY}$1${NOCOLOR}'"
        $(cd ${dockerFolder}/$1/; docker compose pull;)
        $(cd ${dockerFolder}/$1/; docker compose up -d;)
}

prompt() {
  eprint "${PURPLE}What action would you like to perform on your Docker Containers?${NOCOLOR}"

	eprint "1. Upgrade Container"
	eprint "2. Start Container"
	eprint "3. Restart Container"
	eprint "4. Stop Container"
	eprint "5. Remove Container"
	eprint "6. List All Containers"
	eprint "E. Abort"

	echo
	echo -en "${prefix} Select: ${GREEN}"
	read -r USERCHOICE
	echo -e "${NOCOLOR}"
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
    containerName=$(grep -Po 'container_name:\s*\K.*' "${dockerFolder}/${container}/docker-compose.yml")
		numSelect=$(( $numSelect + 1 ))
		removeNonContainers+=("${container}")
		
		isRunning=`docker ps | grep ${container}`
		isRunning=$?
		#rem=$(($numSelect % 2))
    updateIcon="❔"


		tputRED=$(tput setaf 1)		# Container IS NOT running, set number to RED
		tputGREEN=$(tput setaf 2)	# Container   IS   running, set number to GREEN
		tputnormal=$(tput sgr0) 
		if [[ $isRunning -eq 1 ]]; then
			printContainers+="${tputRED}${numSelect}.,${tputnormal}${container},"
			printf "%-4s %-30s \n" "${tputRED}${numSelect}." "${tputnormal}${container}"
		else
      ### Check if container is up-to-date ###
      RepoUrl=$(docker inspect "$containerName" --format='{{.Config.Image}}')
      LocalHash=$(docker image inspect "$RepoUrl" --format '{{.RepoDigests}}')
      # Checking for errors while setting the variable:
      if RegHash=$(~/regctl image digest --list "$RepoUrl" 2>&1) ; then
        if [[ "$LocalHash" = *"$RegHash"* ]] ; then
          # No UpdateNoUpdates+=("$i")
          updateIcon="🔄"
        else
          #GotUpdates+=("$i")
          updateIcon="✅"
        fi
      else
        # Here the RegHash is the result of an error code.
        GotErrors+=("$i - ${RegHash}")
        updateIcon="⚠"
      fi
      ### ###
			printContainers+="${tputGREEN}${numSelect}. ${updateIcon} ,${tputnormal}${container},"
			printf "%-4s %-30s \n" "${tputGREEN}${numSelect}. ${updateIcon} " "${tputnormal}${container}"
		fi
	done | column | sed "s/^/$prefixtput /"

	#echo -e "$printContainers" | column -ts $',' | sed -e 's/^/${prefixtput}/'

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
}


while true; do

	prompt

	case $USERCHOICE in 
		x | X | q | Q | exit)
			eprint "Exiting..."
			exit
			;;
		[0-9]* )
			if [[ $USERCHOICE -gt 6 ]]; then
				echo -en "${prefix} ${ORANGE}Please select a valid choice${NOCOLOR}"
				sleep 1.75 
        echo -en "${RESET_LINE}" 	# Clear text to end of line
				echo -en "${CURSORUP}"
				echo -en "${CLR_LINE_END}"

        echo -en "${prefix} Select: ${GREEN}"
        read USERCHOICE
        echo -en "${NOCOLOR}"
        USERCHOICE=$(( $USERCHOICE -1 ))
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
			elif [[ $USERCHOICE -eq 6 ]]; then # Remove
				action="list"
				eprint "${GREY}=======================================================${NOCOLOR}"
				eprint "${GREY}================   List All Dockers ===================${NOCOLOR}"
				eprint "${GREY}=======================================================${NOCOLOR}"
				containerSelect
				eprint "${GREY}=======================================================${NOCOLOR}"
				eprint
				continue
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

# Select which Container to perform action on 
# (Moved from containerSelect to help looping)
echo -en "${prefix} Select: ${GREEN}"
read -r USERCHOICE
echo -en "${NOCOLOR}"


while true; do
	case $USERCHOICE in 
		x | X | q | Q | exit)
			eprint "Exiting..."
			exit
			;;
		[0-9]* )
			USERCHOICE=$(( $USERCHOICE - 1 ))
			if [[ $USERCHOICE -gt ${#allContainers[@]} ]]; then
				echo -en "${prefix} ${ORANGE}Please select a valid choice${NOCOLOR}"
				sleep 1.75 
        echo -en "${RESET_LINE}" 	# Clear text to end of line
				echo -en "${CURSORUP}"
				echo -en "${CLR_LINE_END}"

        echo -en "${prefix} Select: ${GREEN}"
        read USERCHOICE
        echo -en "${NOCOLOR}"
        USERCHOICE=$(( $USERCHOICE -1 ))
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
					#runContainerRebuild $USERCHOICE
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


eprint
eprint "${GREY}=======================================================${NOCOLOR}"
eprint "${GREY}= Action:    ${CYAN}${action^^}${NOCOLOR}"
eprint "${GREY}= Container: ${GREEN}${allContainers[$USERCHOICE]^^}${NOCOLOR}"
eprint "${GREY}=======================================================${NOCOLOR}"
if   [[ $action == "upgrade" ]]; then
	#echo "upgrade"
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

echo -e "${prefix}${GREEN}===========================${NOCOLOR}"
echo -e "${prefix}${GREEN}======== Complete =========${NOCOLOR}"
echo -e "${prefix}${GREEN}===========================${NOCOLOR}"
live="${RED}LIVE${GREY}"
echo -e "${GREY}---------------------------------------------------------------------------------------${NOCOLOR}"
echo -e "${GREY}   Docker Logs    $live    Docker Logs    $live   Docker Logs    $live    Docker Logs  ${NOCOLOR}"
echo -e "${GREY}--------------------------------------------------------------------------------------- Ctrl+Z/C to exit${NOCOLOR}"

`docker logs -f ${allContainers[$USERCHOICE]}`

#sleep 5

exit
