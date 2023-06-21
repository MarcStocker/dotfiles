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
# ----------------------------------
# ----------------------------------

# ----------------------------------
# Symbols
# ----------------------------------
GREENCHECK="${LIGHTGREEN}\u2705${NOCOLOR}"
REDCROSS="\u274c"
# ----------------------------------
# ----------------------------------

# ----------------------------------
# Text/Termianl Manipulation
# ----------------------------------
ESCAPE='\033['
CURSORSAVE='\033[s'
SAVECURSOR='\033[s'
CURSORLOAD='\033[u'
LOADCURSOR='\033[u'
CURSORLEFT='\033[1D'
CURSORRIGHT='\033[s'
CURSORUP='\033[1A'
#------------------------------------
CLEARSCREEN='\033[2J'
CLEARSCRN='\033[2J'
ERASELINE='\033[K'
#CLEARSCRN='\033c'
#CLEARSCREEN='\033c'
#------------------------------------
#------------------------------------
#------------------------------------
echo_prefix () {
	# Script Prefix for use with echo
	color=${2^^} 		# Convert all uppercase
	color=${!color}	# Access variable using indirect expansion 
	echo -en "${GREY}[ ${color}$1 ${GREY}]${NOCOLOR}"
}

# Paired with the Spinning() funtion to create a spinning "loading" animation
# Call once to start the Loading animation. Call a 2nd time to cancel and clear it. 
# You can add a note on the same line to help with identifing what the call is doing
# For Example: 
#   Loading Start
#   Loading End
Loading () {
	Spinning () {
		## Example call to Loading:
		# Loading Start
		# stdout:  [ INFO ] Loading [|]
		# stdout:  [ INFO ] Loading [/]
		# stdout:  [ INFO ] Loading [-]
		# stdout:  [ INFO ] Loading [\]
		# Loading End
		cursor=("|" "/" "-" "\\")
		while ( : ); do
			for i in ${!cursor[@]}; do
				echo -en "${CLEARLINE}" # Clear text line
				echo -en "\r${ORANGE}[ INFO ]${NOCOLOR} ${LIGHTGREY}Loading [${cursor[i]}]${NOCOLOR}"
				sleep 0.25
			done
		done
	}

	if [[ -z $loadingpid ]]; then
		Spinning & loadingpid=$!
	else
		kill "$loadingpid"
		loadingpid=""
		for i in `seq 1 20`; do 
			echo -en "${CLEARLINE}" # Clear text line \033[D\033[K
		done
		echo -en "\r"
	fi
}

