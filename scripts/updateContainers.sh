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
stopContainer() {
        response=$(docker stop $1)
        #if [[ $reponse != "$1" ]]; then
                #eprint "${RED}ERROR:${NOCOLOR} Something went wrong"
        #fi
}

startContainer() {
        #eprint "Starting container ${NOCOLOR}'${GRAY}$1${NOCOLOR}'"
        #response=$(docker start $1)
  eprint "Recreating container '${GREY}$1${NOCOLOR}'"
        $(cd ${dockerFolder}/$1/; docker-compose pull;)
        $(cd ${dockerFolder}/$1/; docker-compose up -d;)
        #if [[ $reponse != "$1" ]]; then
                #eprint "${RED}ERROR:${NOCOLOR} Something went wrong"
        #fi
}

removeContainer() {
        eprint "Removing container ${NOCOLOR}'${GRAY}$1${NOCOLOR}'"
        $(cd ${dockerFolder}/$1/; docker-compose down;)
        eprint "Next"
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
	allContainers=($(ls -1 ${dockerFolder}))
	declare -a removeNonContainers


	eprint "${PURPLE}Which container would you like to upgrade the image for?${NOCOLOR}"
	numSelect=0
	for i in ${!allContainers[@]}; do
		container=${allContainers[i]}
		if [[ -e "${dockerFolder}/${container}/docker-compose.yml" ]]; then echo -n
		else
			continue
		fi
		removeNonContainers+=("${container}")
		numSelect=$(( $numSelect +1 ))
		
		isRunning=`docker ps | grep ${container}`
		if [[ $? -eq 1 ]]; then
			eprint "${RED}${numSelect}. ${NOCOLOR}${container}"
		else
			eprint "${GREEN}${numSelect}. ${NOCOLOR}${container}"
		fi

	done
	# Remove all options that are not containers
	unset allContainers[@]
	allContainers=("${removeNonContainers[@]}")

	echo -en "${prefix} Select: ${GREEN}"
	read USERCHOICE
	echo -en "${NOCOLOR}"
	USERCHOICE=$(( $USERCHOICE -1 ))
  
}


while true; do
	prompt
	case $USERCHOICE in 
		x | X | q | Q | exit)
			eprint "Exiting..."
			exit
			;;
		[0-9]* )
			if [[ $USERCHOICE -gt ${#allContainers[@]} ]]; then
				echo -en "\033[1A"
				eprint "${ORANGE}Please select a valid choice${NOCOLOR}"
				sleep .75
				continue
			fi
			break
			;;
		* )
			echo -en "\033[1A"
			eprint "${ORANGE}Please select a valid choice${NOCOLOR}"
			sleep .75
			continue
			;;
	esac
done

stopContainer ${allContainers[$USERCHOICE]}
removeContainer ${allContainers[$USERCHOICE]}
recreateContainer ${allContainers[$USERCHOICE]}


#eprint "${PURPLE}------------------------------------"
#eprint "${PURPLE}----- ${ORANGE}Stopping Containers ${PURPLE}----------"
#eprint "${PURPLE}------------------------------------"
#
#
#eprint "${PURPLE}------------------------------------"
#eprint "${PURPLE}----- ${RED}Removing Containers ${PURPLE}----------"
#eprint "${PURPLE}------------------------------------"
#
#eprint "${PURPLE}------------------------------------"
#eprint "${PURPLE}----- ${GREEN}Starting Containers ${PURPLE}----------"
#eprint "${PURPLE}------------------------------------"
#
#for n in {15..1}
#do
#        cursor=("|" "/" "-" "\\")
#        for i in ${!cursor[@]}; do
#                echo -en "${CLEARLINE}" # Clear text line
#                echo -en "                                                                                  \r"
#                echo -en "\r${ORANGE}[ INFO ]${NOCOLOR} ${LIGHTGREY} VPN Booting[${cursor[i]}]${NOCOLOR} - $n"
#                sleep 0.25
#        done
#done
#echo ""
#
#
