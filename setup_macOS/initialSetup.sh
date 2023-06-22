# Terminal output control (http://www.termsys.demon.co.uk/vtansi.htm) 
#TC='\e[' 

TC="\033["

CLEARSCREEN="${TC}2J"
CLR_SCREEN="${TC}2J"
CLR_LINE_START="${TC}1K" 
CLR_LINE_END="${TC}K" 
CLR_LINE="${TC}2K" 

# Hope no terminal is greater than 1k columns 
RESET_LINE="${CLR_LINE}${TC}1000D" 

# Colors and styles (based on https://github.com/demure/dotfiles/blob/master/subbash/prompt) 

Bold="${TC}1m"    # Bold text only, keep colors 
Undr="${TC}4m"    # Underline text only, keep colors 
Inv="${TC}7m"     # Inverse: swap background and foreground colors 
Reg="${TC}22;24m" # Regular text only, keep colors 
RegF="${TC}39m"   # Regular foreground coloring 
RegB="${TC}49m"   # Regular background coloring 
Rst="${TC}0m"     # Reset all coloring and style 

# Basic            High Intensity      Background           High Intensity Background   
Black="${TC}30m";  IBlack="${TC}90m";  OnBlack="${TC}40m";  OnIBlack="${TC}100m";       
Red="${TC}31m";    IRed="${TC}91m";    OnRed="${TC}41m";    OnIRed="${TC}101m";         
Green="${TC}32m";  IGreen="${TC}92m";  OnGreen="${TC}42m";  OnIGreen="${TC}102m";       
Yellow="${TC}33m"; IYellow="${TC}93m"; OnYellow="${TC}43m"; OnIYellow="${TC}103m";      
Blue="${TC}34m";   IBlue="${TC}94m";   OnBlue="${TC}44m";   OnIBlue="${TC}104m";      
Purple="${TC}35m"; IPurple="${TC}95m"; OnPurple="${TC}45m"; OnIPurple="${TC}105m";    
Cyan="${TC}36m";   ICyan="${TC}96m";   OnCyan="${TC}46m";   OnICyan="${TC}106m";      
White="${TC}37m";  IWhite="${TC}97m";  OnWhite="${TC}47m";  OnIWhite="${TC}107m";       

#examples 
#echo -e "${Bold}${Red}bold red on ${OnBlue}blue background,${RegB} now back to regular background, ${RegF}regular foreground and ${Reg}regular text" 
#echo -e "${Bold}${Undr}${Green}You can reset this whole style in one${Rst} command" 
#echo -en "And here we have a line"
#echo -e "${RESET_LINE}And now the line is gone"

# Emojies 
GREENCHECK="\xE2\x9C\x85"
REDCROSS="\xE2\x9D\x8C"

#==========================================================================
#==========================================================================
#==========================================================================
#==========================================================================
USERCHOICE=""

installHomebrew() {
  echo -en "${Bold}Checking for HomeBrew Installation...${Rst}"
  brewInstalled=`which brew`
  if [[ $? -eq 1 ]]; then
    echo -e "${REDCROSS}"
    echo -e "${Yellow}Installing Homebrew...${Rst}"
    `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
  else
    echo -e "${GREENCHECK}"
  fi
}

installPackage() {
  echo -en "   - $@"
  packageInstalled=`brew list ${@} &>/dev/null`
  if [[ $? -eq 0 ]]; then 
    echo -e "${RESET_LINE}${GREENCHECK} - $@"
  else
    echo -e "${RESET_LINE}${REDCROSS} - $@"
    `brew install ${@}`
  fi
  
}
installCask() {
  echo -en "   - $@"
  packageInstalled=`brew list ${@} &>/dev/null`
  if [[ $? -eq 0 ]]; then 
    echo -e "${RESET_LINE}${GREENCHECK} - $@"
  else
    echo -e "${RESET_LINE}${REDCROSS} - $@"
    `brew install --cask ${@}`
  fi
  
}

importFile() {
  #importFile(fileName, fileLocation, destination)
  # Check if file exists, and force user to confirm overwriting
  echo -e "Import ${Bold}${Purple}$1${Rst}?"
  fileExists=`find $3/$1`
  if [[ $? -eq 0 ]]; then
    echo -e "${Bold}${Purple}${1} ${Rst}already exists, do you want to ${Undr}${Yellow}overwrite${Rst} it?${Rst}"
    if yesNo; then importFile=0; else importFile=1; fi
  fi

  if [[ ${importFile} -eq 0 ]]; then
    echo -e "${Rst}${Bold}Importing...${Rst}"
    mv $3/$1 $3/$1.old
    cp $2/$1 $3/$1
    if [[ $? -eq 0 ]]; then echo -e "${Rst}${Bold}${Green}Success${Rst}"; fi
  else
    echo -e "${Rst}${Bold}${Red}Skipping${Rst}"
  fi
  echo
}

yesNo() {
  echo -en "${Yellow}${Bold}Y/n: ${Rst}"
  read USERCHOICE
  if [[ $USERCHOICE = 'y' ]]; then
    return 0
  else
    return 1
  fi
}

echo -e "${Bold}${Purple}--- MacOS First Time Setup ---${Rst}"
installHomebrew

echo -e "${Rst}${BOLD}Install Brew Packages?${Rst}"
if yesNo; then
  echo -e "${Rst}${Bold}${Undr}Installing Brew Packages:${Rst}"
  installPackage python
  installPackage sublime-text
  installPackage vim
  installPackage bash
  installPackage zsh
  installCask iterm2
fi

echo

echo -e "${Rst}${BOLD}Import dotfiles?${Rst}"
echo -en "${Yellow}"
echo -e " - .vimrc"
echo -e " - .bashrc"
if yesNo; then
  importFile .vimrc ../ ~/
  importFile .bashrc ../ ~/
fi


echo -e "${Rst}${Bold}Which shell do you want to use?${Rst}"
echo -e "1. Bash"
echo -e "2. zsh"


Shell: /bin/zsh








