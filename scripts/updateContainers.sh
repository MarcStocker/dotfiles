#!/bin/bash

##########################################################
### Description:
###             Script will display all Docker Containers based off
###             a folder containing folders of docker-compose.yml
###             files.
###
###     File structure script will work with:
###             /FolderToPointTo/nameOfDocker/docker-compose.yml
###
### NOTE:
###       Folders containing the docker-compose.yml files
###       MUST be the exact name of the docker container
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
progress_pid=""

rokianDockerFolder="/mnt/ServerBackup/docker/compose"
HADockerFolder="/docker/compose"
if [[ -d $rokianDockerFolder ]]; then dockerFolder=$rokianDockerFolder; fi
if [[ -d $HADockerFolder ]]; then dockerFolder=$HADockerFolder; fi
allContainerFolders=($(ls -1 ${dockerFolder}))

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

progress_loop() {
  spinner_msg="Please wait, processing..."
  while true; do
    echo -ne "\r${spinner_msg}  |"
    sleep 0.25
    echo -ne "\r${spinner_msg}  /"
    sleep 0.25
    echo -ne "\r${spinner_msg}  -"
    sleep 0.25
    echo -ne "\r${spinner_msg}  \\"
    sleep 0.25
  done
}
start_progress() {
  progress_loop &
  progress_pid=$!
}
stop_progress() {
  if [[ -n "$progress_pid" ]]; then
    kill "$progress_pid" &>/dev/null
    wait "$progress_pid" 2>/dev/null
    progress_pid=""
    echo -ne "\r\033[K"  # Clear the line
  fi
}

gatherVPNContainers () {
  declare -A runningContainers
  while read -r name; do
    runningContainers["$name"]=1;
  done < <(docker ps --format '{{.Names}}')

  declare -a vpnContainers
  for i in ${!allContainerFolders[@]}; do
    networkMode=$(grep -Po '^\s[^#]*network_mode:\s*\K[^#]+' "${dockerFolder}/${allContainerFolders[i]}/docker-compose.yml" 2>&1)
    if [[ "$networkMode" == "container:gluetun" ]]; then
      vpnDockers+=("${allContainerFolders[i]}")
    fi
  done
  # List VPN Dockers
  for i in ${!vpnDockers[@]}; do
    vpnDocker="${vpnDockers[i]}"
    if [[ -n "${runningContainers[$vpnDocker]}" ]]; then #If Running
      eprint "${GREEN} - ${vpnDockers[i]}"
    else
      eprint "${RED} - ${vpnDockers[i]}"
    fi
  done
}

runContainerRebuild() {
  #echo -en "${GRAY}[ ${CYAN} $(1) ${GRAY}]${NOCOLOR} $1"
  #echo -en "${GRAY}[ ${CYAN} $(allContainerFolders) ${GRAY}]${NOCOLOR} ${allContainerFolders[$1]}"
        if [[ ${allContainerFolders[$1]} == "gluetun" ]]; then echo -n
                eprint "GLUETUN SELECTED: Rebuilding all Services using network mode 'container:gluetun'"

    gatherVPNContainers

                lprint
                echo -e "${PURPLE}Do you wish to rebuild and start up STOPPED CONTAINERS as well?${NOCOLOR}"
                lprint
                echo -en "Yes/No: ${GREEN}"
                read -r USERCHOICE
                echo -en "${NOCOLOR}"

                if [[ $USERCHOICE == "yes" || $USERCHOICE == "y" ]]; then
                        rebuildAll="TRUE"
                else
                        rebuildAll="FALSE"
                fi
    echo "Rebuild: $rebuildAll"

                eprint "==== REBUILDING GLUETUN ===="
                stopContainer ${allContainerFolders[$1]}
                removeContainer ${allContainerFolders[$1]}
                recreateContainer ${allContainerFolders[$1]}

    declare -A runningContainers
    while read -r name; do
      runningContainers["$name"]=1;
    done < <(docker ps --format '{{.Names}}')

                for i in ${!vpnDockers[@]}; do
                        container=${vpnDockers[i]}
                        echo "Rebuilding ${container}"
                        isRunning=`docker ps | grep ${container}`
                        isRunning=$?
      if [[ -n "${runningContainers[$container]}" ]]; then #If Running
                                #echo "--------- It's running ----------"
                                eprint "==== REBUILDING $container ===="
                                stopContainer $container
                                removeContainer $container
                                recreateContainer $container
                                eprint "==== $container COMPLETE ===="
                                echo
                        else
                                if [[ $rebuildAll == "TRUE" ]]; then # Rebuild and start, even if it's not running
                                        eprint "==== REBUILDING $container ===="
                                        stopContainer $container
                                        removeContainer $container
                                        recreateContainer $container
                                        eprint "==== $container COMPLETE ===="
                                        echo
                                fi
                        fi
                done
                # Double check to make sure everything is running properly.
                vpnDockers+=("gluetun")
                for i in ${!vpnDockers[@]}; do
                        container=${vpnDockers[i]}
                        isRunning=${runningContainers[$container]}
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
                stopContainer ${allContainerFolders[$1]}
                removeContainer ${allContainerFolders[$1]}
                recreateContainer ${allContainerFolders[$1]}
        fi

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

restartContainer() {
        if [[ $1 == "gluetun" ]]; then echo -n
                eprint "GLUETUN SELECTED: Restarting all Services using network mode 'container:gluetun'"

    gatherVPNContainers

                lprint
                echo -e "${PURPLE}Do you wish to restart STOPPED CONTAINERS as well?${NOCOLOR}"
                lprint
                echo -en "Yes/No: ${GREEN}"
                read -r USERCHOICE
                echo -en "${NOCOLOR}"

                if [[ $USERCHOICE == "yes" || $USERCHOICE == "y" ]]; then
                        rebuildAll=TRUE
                else
                        rebuildAll=FALSE
                fi

                eprint "==== RESTARTING GLUETUN ===="
                stopContainer $1
                startContainer $1

                for i in ${!vpnDockers[@]}; do
                        container=${vpnDockers[i]}
                        echo "Restarting ${container}"
                        isRunning=`docker ps | grep ${container}`
                        isRunning=$?
                        if [[ $isRunning -eq 1 ]]; then echo -n # Only rebuild if currently running
                                #echo "--------- It's not running ----------"
                                if [[ $rebuildAll == "TRUE" ]]; then
                                        eprint "==== RESTARTING $container ===="
                                        stopContainer $container
                                        removeContainer $container
                                        recreateContainer $container
                                        eprint "==== $container COMPLETE ===="
                                        echo
                                fi
                        else
                                #echo "--------- It's running ----------"
                                eprint "==== RESTARTING $container ===="
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
                stopContainer $1
    startContainer $1
        fi
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
        eprint "7. List All VPN Containers"
        eprint "E. Abort"

        echo
        echo -en "${prefix} Select: ${GREEN}"
        read -r USERCHOICE
        echo -e "${NOCOLOR}"
}

containerSelect() {

        allContainerFolders=($(ls -1 ${dockerFolder}))
        declare -a removeNonContainers

  declare -A runningContainers
  while read -r name; do
    runningContainers["$name"]=1;
  done < <(docker ps --format '{{.Names}}')

  declare -A allContainers
  while read -r name; do
    runningContainers["$name"]=1;
  done < <(docker ps -a --format '{{.Names}}')

        printContainers=""
        numSelect=0
  start_progress ${#allContainerFolders[@]}
        for i in ${!allContainerFolders[@]}; do
    if [[ $i -eq 0 ]]; then  # Clear the "Start_Progress" text once all output is printed
      cols=$(tput cols)
      printf '\r'
      printf ' %.0s' $(seq 1 $cols)
      printf '\r'
      echo -en "$prefixtput "
    fi
                container=${allContainerFolders[i]}
                if [[ -e "${dockerFolder}/${container}/docker-compose.yml" ]]; then echo -n
                else
                        continue # Skip if no docker-compose.yml file present in folder
                fi
    containerName=$(grep -Po 'container_name:\s*\K.*' "${dockerFolder}/${container}/docker-compose.yml")
    if [[ -e "${allContainers[$container]}" ]]; then
      continue
    fi
                numSelect=$(( $numSelect + 1 ))
                removeNonContainers+=("${container}")

    if [[ -n "${runningContainers[$container]}" ]]; then #If Running
      ### Check if container is up-to-date ###
      RepoUrl=$(docker inspect "$containerName" --format='{{.Config.Image}}' 2>&1)
      LocalHash=$(docker image inspect "$RepoUrl" --format '{{.RepoDigests}}' 2>&1)
      # Checking for errors while setting the variable:
      if [[ "$action" == "upgrade" ]]; then
        if RegHash=$(~/regctl image digest --list "$RepoUrl" 2>&1) ; then
          if [[ "$LocalHash" = *"$RegHash"* ]] ; then
            # No UpdateNoUpdates+=("$i")
            updateIcon="✅ "
          else
            #GotUpdates+=("$i")
            updateIcon="🔄 "
          fi
        else
          # Here the RegHash is the result of an error code.
          GotErrors+=("$i - ${RegHash}")
          updateIcon="⚠  "
        fi
        else
          updateIcon="✅ "
      fi
      numColor=${tputGREEN}
                else #Not Running
      updateIcon="❔ "
      numColor=${tputRED}
                fi
    printf "%-4s %-30s \n" "${updateIcon}${numColor}${numSelect}." "${tputnormal}${container}"
  done | column | sed "s/^/$prefixtput /"
  stop_progress

        for i in ${!allContainerFolders[@]}; do
                container=${allContainerFolders[i]}
                if [[ -e "${dockerFolder}/${container}/docker-compose.yml" ]]; then echo -n
                else
                        continue
                fi
                removeNonContainers+=("${container}")
        done

# REMOVE ALL ENTRIES THAT DO NO CONTAIN DOCKER-COMPOSE FILES
# If we do not, then all those folders mess up the number selection.
        unset allContainerFolders[@]
        allContainerFolders=("${removeNonContainers[@]}")
}


while true; do

        prompt

        case $USERCHOICE in
                x | X | q | Q | exit)
                        eprint "Exiting..."
                        exit
                        ;;
                [0-9]* )
                        if [[ $USERCHOICE -gt 7 ]]; then
                                echo -en "${prefix} ${ORANGE}Please select a valid choice${NOCOLOR}"
                                sleep 1.75
        echo -en "${RESET_LINE}"        # Clear text to end of line
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
                        elif [[ $USERCHOICE -eq 7 ]]; then # Remove
                                action="list"
                                eprint "${GREY}===========================================================${NOCOLOR}"
                                eprint "${GREY}================   List All VPN Dockers ===================${NOCOLOR}"
                                eprint "${GREY}===========================================================${NOCOLOR}"

        isRunning=`docker ps | grep gluetun`
        isRunning=$?
        if [[ $isRunning -eq 1 ]]; then
          eprint "VPN Container: ${RED}Gluetun"
        else
          eprint "VPN Container: ${GREEN}Gluetun"
        fi
        gatherVPNContainers
                                eprint "${GREY}===========================================================${NOCOLOR}"
                                eprint
                                continue
                        fi

                        break
                        ;;
                * )
                        eprint "Nice try dick-nuts.."
      sleep .75
      echo -en "${RESET_LINE}"  # Clear text to end of line
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
                        if [[ $USERCHOICE -gt ${#allContainerFolders[@]} ]]; then
                                echo -en "${prefix} ${ORANGE}Please select a valid choice${NOCOLOR}"
                                sleep 1.75
        echo -en "${RESET_LINE}"        # Clear text to end of line
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

                        for i in ${!allContainerFolders[@]}; do
                                container=${allContainerFolders[i]}
                                #echo "Container: ${container}"
                                #echo "User Choice ${USERCHOICE}"
                                if [[ "$container" == "$USERCHOICE" ]]; then
                                        for i in ${!allContainerFolders[@]}; do # Find the container's number and resave USERCHOICE
                                                container=${allContainerFolders[i]}
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
                                        #stopContainer ${allContainerFolders[$USERCHOICE]}
                                        #removeContainer ${allContainerFolders[$USERCHOICE]}
                                        #recreateContainer ${allContainerFolders[$USERCHOICE]}
                                        exit
                                else
                                        #echo -en "${prefix} Bad choice\n\n"
                                        continue
                                fi
                                removeNonContainers+=("${container}")
                        done #| column


      echo -en "${prefix} ${ORANGE}Please select a valid choice${NOCOLOR}"
      sleep .75
      echo -en "${RESET_LINE}"  # Clear text to end of line
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
eprint "${GREY}= Container: ${GREEN}${allContainerFolders[$USERCHOICE]^^}${NOCOLOR}"
eprint "${GREY}=======================================================${NOCOLOR}"
if   [[ $action == "upgrade" ]]; then
        #echo "upgrade"
        runContainerRebuild ${USERCHOICE}
elif [[ $action == "start" ]]; then
        startContainer ${allContainerFolders[$USERCHOICE]}
elif [[ $action == "restart" ]]; then
  restartContainer ${allContainerFolders[$USERCHOICE]}
elif [[ $action == "stop" ]]; then
        stopContainer ${allContainerFolders[$USERCHOICE]}
elif [[ $action == "remove" ]]; then
        stopContainer ${allContainerFolders[$USERCHOICE]}
        removeContainer ${allContainerFolders[$USERCHOICE]}
fi

echo -e "${prefix}${GREEN}===========================${NOCOLOR}"
echo -e "${prefix}${GREEN}======== Complete =========${NOCOLOR}"
echo -e "${prefix}${GREEN}===========================${NOCOLOR}"
live="${RED}LIVE${GREY}"
echo -e "${GREY}---------------------------------------------------------------------------------------${NOCOLOR}"
echo -e "${GREY}   Docker Logs    $live    Docker Logs    $live   Docker Logs    $live    Docker Logs  ${NOCOLOR}"
echo -e "${GREY}--------------------------------------------------------------------------------------- Ctrl+Z/C to exit${NOCOLOR}"

`docker logs -f ${allContainerFolders[$USERCHOICE]}`

#sleep 5

exit
