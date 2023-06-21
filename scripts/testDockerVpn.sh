source ~/dotfiles/scripts/shellTextVariables.sh
source ~/dotfiles/scripts/functions.sh
## ----------------------------------
## Colors
## ----------------------------------
#NOCOLOR='\033[0m'
#RED='\033[0;31m'
#GREEN='\033[0;32m'
#ORANGE='\033[0;33m'
#BLUE='\033[0;34m'
#PURPLE='\033[0;35m'
#CYAN='\033[0;36m'
#LIGHTGRAY='\033[0;37m'
#GRAY='\033[0;37m'
#DARKGRAY='\033[1;30m'
#LIGHTRED='\033[1;31m'
#LIGHTGREEN='\033[1;32m'
#YELLOW='\033[0;33m'
#LIGHTBLUE='\033[1;34m'
#LIGHTPURPLE='\033[1;35m'
#LIGHTCYAN='\033[1;36m'
#WHITE='\033[1;37m'
## ----------------------------------
## Symbols
## ----------------------------------
##GREENCHECK="${LIGHTGREEN}\u2714${NOCOLOR}"
#GREENCHECK="\U2705"
#REDCROSS="\U274C"
#YELLOWHAZARD="${YELLOW}\U1F6AB${NOCOLOR}"
#WARNING="\U2620"
#FIRE="\U1F525"


# ----------------------------------
# Variables
# ----------------------------------
prefix="${GRAY}[ ${CYAN}TestVPN ${GRAY}]${NOCOLOR} "
vpnContainer="gluetun"

testDockerVPNIP() {
	# A Sample Call: testDockerVPNIP ${PROWLARRIP:=None} Prowlarr
	
	# Test only dockers that should be behind a VPN
	#dockers=( 'jackett' 'qbittorrent' 'sonarr' 'radarr' 'lidarr' 'bazarr' 'overseerr' 'ombi' )

	#out=""
	#for container in ${dockers[@]}; do
		if [[ ${1} == ${VPNIP} && ${1} != "" ]]; then
			if [[ ${3} == "yes" ]]; then
				echo -en "		"
				echo -e "${GREENCHECK} ${2}"
			else
				echo -en "${prefix}${GREENCHECK} ${2}"
			fi
		elif [[ ${1} == "None" ]]; then
			if [[ ${3} == "yes" ]]; then
				echo -en "		"
				echo -e "${REDCROSS} ${2}"
			else
				echo -en "${prefix}${REDCROSS} ${2}"
			fi
		else
			if [[ ${3} == "yes" ]]; then
				echo -en "		"
				echo -e "${FIRE} ${RED}${2}${NOCOLOR}"
			else
				echo -en "${prefix}${FIRE} ${RED}${2}${NOCOLOR}"
			fi
		fi
	#done
}

getPublicIP()
{
	for i in {1..3}; do
		if [[ -z "$PUBLICIP" ]]; then
			case $i in
				1 )
					#echo "1) Dig"
					PUBLICIP=`dig +short myip.opendns.com @resolver1.opendns.com &` > /dev/null
					break;;
				2 )
					#echo "2) Curl amazon"
					PUBLICIP=`curl -w "\n" -s -X GET https://checkip.amazonaws.com &` > /dev/null
					break;;
				3 )
					#echo "3) Curl ifconfig.io"
					PUBLICIP=`curl ifconfig.io &` > /dev/null
					break;;
			esac
		fi
	done
}
getVpnIP()
{
	for i in {1..3}; do
		if [[ -z "$VPNIP" ]]; then
			case $i in
				1 )
					VPNIP=`curl -Gs http://192.168.1.229:8001/v1/publicip/ip | jq .public_ip | sed -r "s/\"//g" 2> /dev/null`
					break;;
				2 )
					#echo "3) Curl ifconfig.io"
					VPNIP=`docker exec ${vpnContainer} curl -s ifconfig.io & 2> /dev/null`
					break;;
				3 )
					#echo "2) Curl amazon"
					VPNIP=`docker exec ${vpnContainer} curl -w "\n" -s -X GET https://checkip.amazonaws.com & 2> /dev/null`
					break;;
			esac
		fi
	done
}

getDockerIPs()
{
	PROWLARRIP=`docker exec prowlarr curl -s ifconfig.io 2> /dev/null`
	QBITTORRENTIP=`docker exec qbittorrent curl -s ifconfig.io 2> /dev/null`
	SONARRIP=`docker exec sonarr curl -s ifconfig.io 2> /dev/null`
	RADARRIP=`docker exec radarr curl -s ifconfig.io 2> /dev/null`
	LIDARRIP=`docker exec lidarr curl -s ifconfig.io 2> /dev/null`
	BAZARRIP=`docker exec bazarr curl -s ifconfig.io 2> /dev/null`
	OVERSEERRIP=`docker exec overseerr curl -s ifconfig.io 2> /dev/null`
	OMBIIP=`docker exec ombi curl -s ifconfig.io 2> /dev/null`
}

echo -e "${prefix}${CYAN}===============================================${NOCOLOR}"
echo -e "${prefix}${CYAN}== ${NOCOLOR}Testing Docker containers attached to VPN ${CYAN}==${NOCOLOR}"
echo -e "${prefix}${CYAN}===============================================${NOCOLOR}"
echo -e "${prefix}${GREENCHECK} = ${GREEN}Connected to VPN${NOCOLOR}"
echo -e "${prefix}${REDCROSS} = ${ORANGE}No Internet/Not Running${NOCOLOR}"
echo -e "${prefix}${FIRE} = ${RED}Not connected to VPN${NOCOLOR}"
echo -e "${prefix}"
#echo -en "${prefix}Please wait..."
Loading Start

getPublicIP
getVpnIP
getDockerIPs

Loading End

#Clear Please Wait line 
#echo -en "\033[999D\033[K"
#echo "Overseerr IP: ${OVERSEERRIP}"

echo -e "${prefix}${CYAN}-----------------------------------${NOCOLOR}"
echo -e "${prefix}${CYAN}------${NOCOLOR}   Public IP Address   ${CYAN}------${NOCOLOR}"
echo -e "${prefix}${CYAN}------    ${ORANGE}${PUBLICIP}${CYAN}     ------${NOCOLOR}"
echo -e "${prefix}${CYAN}-----------------------------------${NOCOLOR}"
echo -e "${prefix}${CYAN}------${NOCOLOR}  VPN Pub IP Address   ${CYAN}------${NOCOLOR}"
echo -e "${prefix}${CYAN}------     ${ORANGE}${VPNIP}${CYAN}      ------${NOCOLOR}"
echo -e "${prefix}${CYAN}-----------------------------------${NOCOLOR}"

testDockerVPNIP ${PROWLARRIP:=None} Prowlarr
testDockerVPNIP ${QBITTORRENTIP:=None} qBitTorrent yes
testDockerVPNIP ${OVERSEERRIP:=None} Overseerr
testDockerVPNIP ${OMBIIP:=None} Ombi yes
testDockerVPNIP ${SONARRIP:=None} Sonarr
testDockerVPNIP ${LIDARRIP:=None} Lidarr yes
testDockerVPNIP ${RADARRIP:=None} Radarr
testDockerVPNIP ${BAZARRIP:=None} Bazarr yes


#if [[ ${TRANSIP} == ${VPNIP} && ${TRANSIP} != "" ]]; then
#	echo -en "${GREENCHECK} Transmission"
#elif [[ ${TRANSIP} == "" ]]; then
#	echo -en "${YELLOWHAZARD} Transmission"
#else
#	echo -en "${REDCROSS} ${RED}Transmission${NOCOLOR}"
#fi
#
#if [[ ${OMBIIP} == ${VPNIP} && ${OMBIIP} != "" ]]; then
#	echo -en "	"
#	echo -e "${GREENCHECK} Ombi"
#elif [[ ${TRANSIP} == "" ]]; then
#	echo -en "${YELLOWHAZARD} Transmission"
#else
#	echo -en "	"
#	echo -e "${REDCROSS} ${RED}Ombi${NOCOLOR}"
#fi
#
#if [[ ${SONARRIP} == ${VPNIP} && ${SONARRIP} != "" ]]; then
#	echo -en "${GREENCHECK} Sonarr"
#elif [[ ${TRANSIP} == "" ]]; then
#	echo -en "${YELLOWHAZARD} Transmission"
#else
#	echo -en "${REDCROSS} ${RED}Sonarr${NOCOLOR}"
#fi
#
#if [[ ${LIDARRIP} == ${VPNIP} && ${LIDARRIP} != "" ]]; then
#	echo -en "	"
#	echo -e "${GREENCHECK} Lidarr"
#elif [[ ${TRANSIP} == "" ]]; then
#	echo -en "${YELLOWHAZARD} Transmission"
#else
#	echo -en "	"
#	echo -e "${REDCROSS} ${RED}Lidarr${NOCOLOR}"
#fi
#
#if [[ ${RADARRIP} == ${VPNIP} && ${RADARRIP} != "" ]]; then
#	echo -en "${GREENCHECK} Radarr"
#elif [[ ${TRANSIP} == "" ]]; then
#	echo -en "${YELLOWHAZARD} Transmission"
#else
#	echo -en "${REDCROSS} ${RED}Radarr${NOCOLOR}"
#fi
#
#if [[ ${BAZARRIP} == ${VPNIP} && ${BAZARRIP} != "" ]]; then
#	echo -en "	"
#	echo -en "${GREENCHECK} Bazarr"
#elif [[ ${TRANSIP} == "" ]]; then
#	echo -en "${YELLOWHAZARD} Transmission"
#else
#	echo -en "	"
#	echo -en "${REDCROSS} ${RED}Bazarr${NOCOLOR}"
#fi



echo


