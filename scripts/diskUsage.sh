#!/bin/bash
source ~/dotfiles/scripts/shellTextVariables.sh
# ----------------------------------
# Colors
# ----------------------------------
TC="\033["
NOCOLOR="${TC}0m"
RED="${TC}0;31m"
GREEN="${TC}0;32m"
ORANGE="${TC}38;5;208m"
BLUE="${TC}0;34m"
PURPLE="${TC}0;35m"
CYAN="${TC}0;36m"
LIGHTGRAY="${TC}0;37m"
LIGHTGREY="${TC}0;37m"
DARKGRAY="${TC}1;30m"
DARKGREY="${TC}1;30m"
LIGHTRED="${TC}1;31m"
LIGHTGREEN="${TC}1;32m"
YELLOW="${TC}0;33m"
LIGHTBLUE="${TC}1;34m"
LIGHTPURPLE="${TC}1;35m"
LIGHTCYAN="${TC}1;36m"
WHITE="${TC}1;37m"

REDHL="${TC}1;41m"
YELLOWHL="${TC}1;43m"
GREENHL="${TC}1;42m"

Bold="${TC}1m"    # Bold text only, keep colors
Undr="${TC}4m"    # Underline text only, keep colors
Inv="${TC}7m"     # Inverse: swap background and foreground colors
Reg="${TC}22;24m" # Regular text only, keep colors
RegF="${TC}39m"   # Regular foreground coloring
RegB="${TC}49m"   # Regular background coloring
Rst="${TC}0m"     # Reset all coloring and style

ERASELINE="${TC}D${TC}K"
CLEARLINE="${TC}D${TC}K"

SAVECURSOR="${TC}s"
CURSORLOAD="${TC}u"
LOADCURSOR="${TC}u"

#####################################################################################################
# This script/function displays all mounted storage drives on the system and info about their space.
#
# The OS harddrive '/' will always be first. 
# Following the OS drive will be every other drive that doesn't come from the /etc folder,
# and will be sorted by total size, smallest-largest. 
#
# The function harddrive() will accept 1 argument, and must be the strings "reverse" or "r".
# Passing in these arguments will reverse the order to largest-smallest
#
# You can save hardcoded drives (the location where they should be mounted) as well. 
# This will give you the "{Drive} is UNMOUNTED..." warning if it cannot be found. 
# 
#####################################################################################################
# Example output (Real output will be colorized): 
##  user@machine:~/dotfiles/scripts$ ./diskUsage.sh list
##    Filesystems             Free    Used    Size   Used%
##    /(dev/sde1)              17G     66G     87G     80%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━----------]
##    /mnt/NanoDrive is UNMOUNTED...
##    [xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx]
##    /mnt/ServerBackup        15G    202G    229G     94%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━---]
##    /mnt/plexMetaData        15G    207G    234G     94%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━---]
##    /mnt/One                211G    2.6T    2.8T     93%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━----]
##    /mnt/TriceriBytes        12G    2.8T    2.8T    100%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━]
##    /mnt/FatTerry            91G    9.1T    9.1T    100%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━]
##    /mnt/raid5               16T     21T     39T     57%
##    [━━━━━━━━━━━━━━━━━━━━━━━━━━━━----------------------]
#####################################################################################################
#
# Note: If you want to change the indent spacing, just change the variable "indentNum" 
#       Or replace the indent spaces with another character by changing "indentChar"
#
#####################################################################################################

# Accepts 4 arguments:
# 1. "Reverse" flag to reverse harddrive order based on total size. Either "Reverse" or "r".
#    (Pass in anything else in order to use args 2 and 3)
#     -r
# 2. Num of Indention spaces
#    (Pass in any non-number in order to use arg 3 without changing the default arg 2)
#     -n
# 3. Change Indention character
#     -c
# 4. Order. Default is Total Disk Space. Other options; Size, Used, Avail, Perc.
#     -o

storageDrives () { 
  fReverse=''
  indentNum='5'
  indentChar=' '
  order='avail'
  while getopts 'hdlrn:c:o:' flag; do
    case "${flag}" in
      l | h | d) echo -n ;;
      r) fReverse="-r" ;; # Reverse flag for `sort` command
      n) indentNum="${OPTARG}" ;;
      c) indentChar="${OPTARG}" ;;
      o) echo -e "order flag: -$flag ${OPTARG}";order="${OPTARG}" ;;
      *) echo -e "${ORANGE}BAD ARUGMENT: ${NOCOLOR}-${flag} ${OPTARG}" 
         exit 1 ;;
    esac
  done

  #echo "Options: ${@}"
  #echo -e "fReverse:      $fReverse"
  #echo -e "indentNum(n):  $indentNum"
  #echo -e "indentChar(c): $indentChar"
  #echo -e "order(o):      $order"

  # Dynamically create the number of index chars specified
  str=$(printf "%${indentNum}s")
  indent="${NOCOLOR}${str// /${indentChar}${NOCOLOR}}"

  # Which storageDrive are we going to get data from?
  # $ df -h | grep ^/
  #Filesystem      Size  Used Avail Use% Mounted on
  #/dev/sde1        87G   30G   53G  37% /
  #/dev/sdf1       229G   47G  171G  22% /mnt/ServerBackup
  #/dev/sdg1       234G  201G   21G  91% /mnt/plexMetaData
  #/dev/sdh2       2.8T  2.6T  211G  93% /mnt/One
  #/dev/sdi2       2.8T  2.7T  102G  97% /mnt/Twee
  #/dev/md0         39T  959G   36T   3% /mnt/raid5
  #/dev/sdj1       9.1T  9.1T  115M 100% /mnt/FatTerry

  declare -a storageDrive

  #############################################################################################
  # HARDCODE Drives you'd like to be informed of if they are DISCONNECTED (unmounted). 
  # Otherwise, it's all dynamic and you'll only see drives that are currently mounted.
  # 
  # Hardcoded drives will appear after the OS, but before everything else in the order they're entered.
  #
  # USE THE "MOUNT LOCATION" FOR THESE ENTRIES, examples follow.
  #############################################################################################
  #-----------------------------------------------------------#
  #---------     Enter Hardcoded drives here    --------------#
  #-----------------------------------------------------------#
  # storageDrive+=("/mnt/FatTerry")
  # storageDrive+=("/mnt/raid5")
  # storageDrive+=("etc...")
  #-----------------------------------------------------------#

  # Gotta add in the '|' deliminator for any hardcoded drives
  for i in "${!storageDrive[@]}"; do
    storageDrive[$i]="|${storageDrive[$i]}"
  done


  case ${order^^} in 
    *AVAIL* | *FREE*) 
      order=4
      ;;
    *USED*) 
      order=3
      ;;
    *PERC*) 
      order=5
      ;;
    *SIZE*) 
      order=2
      ;;
  esac

  # Read in all mounted storageDrive
  while IFS= read -r line; do
    #echo -e "$line"
    filesystem=$(echo "$line" | awk '{print $1}')
    mount_point=$(echo "$line" | awk '{print $6}')
    # Check if the value already exists in the array (From Hardcoded drives)
    if [[ " ${storageDrive[*]} " != *"$mount_point"* ]]; then
      #echo "ADDING: $filesystem | $mount_point"
      storageDrive+=("$filesystem|$mount_point")
    fi
  done < <( df | grep ^/ | sort -n -k $order $fReverse )
  #echo "There are a total of ${#storageDrive[@]} storageDrive"


  # Echo the Header
  echo -en "${GREEN}"
  #formatting="${DARKGREY}${OnWhite}${Inv}${Undr}${Bold}"
  echo -en "Filesystems  Free  Used  Size  Used%" | awk -v indent="${indent}" '{printf indent "%-22s %5s %7s %7s %7s", $1, $2, $3, $4, $5}'
  #echo -e "\n  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "${NOCOLOR}"

  # Print OS drive first!!
  filesystem=$(df / | grep / | awk '{print $1}')
  mount_point=$(df / | grep / | awk '{print $6}')
  printDriveGraphic $filesystem $mount_point

  # Print the rest of the drives
  for key in "${storageDrive[@]}"; do
    filesystem=$(echo "$key" | cut -d "|" -f 1)
    mount_point=$(echo "$key" | cut -d "|" -f 2)
    if [[ $mount_point == "/" ]]; then
      continue
    fi
    printDriveGraphic $filesystem $mount_point
  done
}
printDriveGraphic () {
  filesystem=$1
  mount_point=$2
  #echo "Filesystem: $filesystem"
  #echo "mount_point: $mount_point"

  # Anything mounted in /etc/ is not a users harddrive
  if [[ ${mount_point} == *"/etc/"* ]]; then
    return
  fi

  # If a hard coded drive is passed in without a filesystem, find it. 
  if [[ -z "${2// }" ]]; then
    mount_point=$(df | grep $filesystem | awk '{print $6}')
  fi
  # Handle unmounted drives (that aren't the OS, cause techincally it's mount point is '/', not '/dev/xxx#')
  if  ! lsblk -f | grep -q "${mount_point}" || [ -z "${mount_point// }" ] ; then
    if [[ "${filesystem}" != '/' ]]; then
      #SPACES
      echo -e  "${indent}${filesystem} is ${RED}${Undr}${Bold}UNMOUNTED${NOCOLOR}..."
      echo -en "${indent}${LIGHTGRAY}[${REDHL}${DARKGRAY}"
      str=$(printf "%50s")
      echo -en "${str// /x}${NOCOLOR}"
      echo -e "${NOCOLOR}${LIGHTGRAY}]${NOCOLOR}"
      return
    fi  
    return
  fi

  mount_point=${mount_point}
  filesystem=${filesystem}
  tot_available=`df -h ${mount_point} | awk '{print $4}' | tail -n 1`
  tot_used=`df -h ${mount_point} | awk '{print $3}' | tail -n 1`
  tot_size=`df -h ${mount_point} | awk '{print $2}' | tail -n 1`
  tot_usedPerc=`df -h ${mount_point} | awk '{print $5}' | tail -n 1`

  if [[ "${mount_point}" = '/' ]]; then
    filesystem="/${DARKGREY}(${filesystem:1})${NOCOLOR}"
    output="${filesystem}  ${Bold}${tot_available}  ${tot_used}  ${tot_size}  ${tot_usedPerc}"
    echo -e "${output}" | awk -v indent="$indent" '{printf indent "%-34s %8s %7s %7s %7s", $1, $2, $3, $4, $5}'
  else
    output="${mount_point}  ${Bold}${tot_available}  ${tot_used}  ${tot_size}  ${tot_usedPerc}"
    echo -e "${output}" | awk -v indent="$indent" '{printf indent "%-23s %8s %7s %7s %7s", $1, $2, $3, $4, $5}'
  fi
  echo 

  perc=`echo ${tot_usedPerc} | sed 's/\d*%//'`
  usedPerc=$(( ${perc} / 2  ))
  str=$(printf "%${usedPerc}s")
  percDiff=$(( 50 - $usedPerc ))
  extraStr=$(printf "%${percDiff}s")

  # Colorize disk usage "progress bar" based on space used
  # Gradient from Green to Red. 
  echo -en "${indent}${LIGHTGRAY}["
  if [[ ${perc} -lt 50 ]]; then
    echo -en "${GREEN}"
  elif [[ ${perc} -ge 50 && ${perc} -lt 55 ]]; then
    echo -en "\033[38;5;076m"
  elif [[ ${perc} -ge 55 && ${perc} -lt 60 ]]; then
    echo -en "\033[38;5;112m"
  elif [[ ${perc} -ge 60 && ${perc} -lt 65 ]]; then
    echo -en "\033[38;5;148m"
  elif [[ ${perc} -ge 65 && ${perc} -lt 70 ]]; then
    echo -en "\033[38;5;184m"
  elif [[ ${perc} -ge 70 && ${perc} -lt 75 ]]; then
    echo -en "\033[38;5;220m"
  elif [[ ${perc} -ge 75 && ${perc} -lt 80 ]]; then
    echo -en "\033[38;5;214m"
  elif [[ ${perc} -ge 80 && ${perc} -lt 85 ]]; then
    echo -en "\033[38;5;208m"
  elif [[ ${perc} -ge 85 && ${perc} -lt 90 ]]; then
    echo -en "\033[38;5;202m"
  elif [[ ${perc} -ge 90 && ${perc} -lt 95 ]]; then
    echo -en "\033[38;5;124m"
  elif [[ ${perc} -ge 95 ]]; then
    echo -en "\033[38;5;009m"
  else
    echo -en
  fi

  echo -en "${str// /━}${NOCOLOR}"
  echo -en "${DARKGRAY}${extraStr// /━}${NOCOLOR}"
  echo -e "${LIGHTGRAY}]${NOCOLOR}"
}

##################################################
# Call Script directly via pass through variable #
##################################################

display="false"
while getopts 'hdlrn:c:o:' flag; do
  case "${flag}" in
    h) echo "$(basename "$0") [-h] [-d/l] [-r] [-n #] [-c X] [-o string]
  Options:
    -d  MUST BE USED TO DISPLAY OUTPUT: If calling the script file directly (ex. ./$(basename "$0"), this will display output. Otherwise, use it as a function in another script
    -l  Same as -d option

    -h  Show this help dialog

    -o  How to order the drives. Avail options: free, used, avail, perc. (Default: avail)
    -r  Reverse order of drives 

    -n  Set number of leading prefix characters/how much to indent final output (Default: ' ')
    -c  Set the character to be used as the prefix character (Default: 4)"
      exit 0
      ;;
    d|l|r|n|c|o) display="true" ;;
    *) echo -e "${ORANGE}BAD ARUGMENT: ${NOCOLOR}-${flag} ${OPTARG}" 
       exit 1 ;;
  esac
done


# Only run if explicitly told to do so, otherwise, this file is basically just a function. 
if [[ $display == "true" ]]; then
  OPTIND=1  # Reset the index of the next option to be processed
  OPTARG="" # Clear the value of the last option argument
  unset opt

  storageDrives ${@}
fi
