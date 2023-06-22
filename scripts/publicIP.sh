source ~/dotfiles/scripts/shellTextVariables.sh

## Get the current external IP address
getPublicIP () {
	echo -n "Retrieving Public IP Address..."
	for i in {1..3}; do
		case $i in
			1 )
				#echo "1) Dig"
				PUBLICIP=`dig +short myip.opendns.com @resolver1.opendns.com &` 2> /dev/null
				break;;
			2 )
				#echo "2) Curl amazon"
				PUBLICIP=$(curl -w "\n" -s -X GET https://checkip.amazonaws.com) 2> /dev/null
				break;;
			3 )
				#echo "3) Curl ifconfig.io"
				PUBLICIP=$(curl -s ifconfig.io) 2> /dev/null
				break;;
		esac
	done
}

getPublicIP

#Clear line
echo -en "\033[999D\033[K"
echo -e "${CYAN}${Undr}${OnPurple}Public IP:${NOCOLOR}"
echo -e "${PURPLE}$PUBLICIP${NOCOLOR}"
echo
echo -e "${CYAN}${Undr}${OnPurple}Local IPs:${NOCOLOR}"
for i in {0..20}; do
	ip --color a show enp${i}s0 2> /dev/null
done
echo
echo -e "${CYAN}${Undr}${OnPurple}Virtual IPs:${NOCOLOR}"
for i in {0..20}; do
	ip --color a show vmbr${i} 2> /dev/null
done
