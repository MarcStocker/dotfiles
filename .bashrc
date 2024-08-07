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
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[0;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

ESCAPE='\033['
CURSORSAVE='\033[s'
SAVECURSOR='\033[s'
CURSORLOAD='\033[u'
LOADCURSOR='\033[u'
CURSORLEFT='\033[1D'
CURSORRIGHT='\033[s'

CLEARSCREEN='\033[2J'

ERASELINE='\033[K'

# Original PS1
# export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"
# Must wrap not printed characters with \[NOT PRINTED\] -- For example, colors\: \[${CYAN}\]
# otherwise bash shell will think the prompt is longer than it is and will wrap text in a weird way
#NEWPS1="`echo =e \r` || \[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[${CYAN}\]\u\[${PURPLE}\]@\[${LIGHTCYAN}\]\h\[${NOCOLOR}\]:\[${PURPLE}\]\w\[${CYAN}\]\$\[${NOCOLOR}\] "
NEWPS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[${CYAN}\]\u\[${PURPLE}\]@\[${LIGHTCYAN}\]\h\[${NOCOLOR}\]:\[${PURPLE}\]\w\[${CYAN}\]\$\[${NOCOLOR}\] "




#========================================================
#========================================================
#
# Bash for Ubuntu for Windows Aliases and commands
#
#========================================================
#========================================================

#Test from Maxx
alias bk='function _bk() { cp "$1" "$(basename "$1")_$(date +'%Y%m%d_%H%M%S')"; }; _bk'




#alias apt="nala"
alias e="exit"
alias sourcerc="source ~/.*rc"

alias editbash="vim ~/.bashrc 
	source ~/.bashrc"

alias la="ls -l -a -v -h"
alias ll="ls -l -v"
alias l="ls -v"
alias ls="ls -v"

alias rcopy="rlcone copy -P --size-only"

alias shutdown="sudo shutdown 0"
alias reboot="sudo shutdown -r 0"
alias restart="sudo shutdown -r 0"

alias server="~/dotfiles/scripts/sshToServers.sh"

alias tmuxh="~/dotfiles/scripts/tmuxHelper.sh"
alias htmux="~/dotfiles/scripts/tmuxHelper.sh"

alias motd="/etc/profile.d/motd.sh"
alias emotd="sudo vim /etc/profile.d/motd.sh"

alias updatedns="sudo ~/cronjobs/updateAllDnsRecords.sh"
alias downloads="cd /mnt/FatTerry/Downloads/Transmission"

alias recordings="cd /mnt/raid5/recordings/"

alias temp="watch -n 0.1 sensors"
alias temps="watch -n 0.1 sensors"

alias revertinterfaces="sudo cp ~/Documents/broken.interfaces /etc/network/interfaces"

# Network diag
alias networkdiag="~/dotfiles/scripts/networkDiagnostics.sh"
alias netdiag="~/dotfiles/scripts/networkDiagnostics.sh"

alias ipa="ip -c a | head -n 25"
alias network="cd /etc/network/"
alias interfaces="sudo vim /etc/network/interfaces"

alias myip="~/dotfiles/scripts/publicIP.sh"
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"

# Samba 
alias sambaedit="sudo vim /etc/samba/smb.conf"
alias sambals="sudo smbclient -L localhost"
alias sambarestart="sudo systemctl restart smbd; sudo service smbd restart"
alias sambatest="testparm /etc/samba/smb.conf"
alias sambalogs="sudo less /var/log/samba/smbd.log"

# Disk Usage Script
alias disk="~/dotfiles/scripts/diskUsage.sh -d -n 2"
alias space="~/dotfiles/scripts/diskUsage.sh -d -n 2" 
alias diskr="~/dotfiles/scripts/diskUsage.sh -d -r"


#========================================================
#========================================================
#
# Docker Commands
#
#========================================================
#========================================================
alias dockers="cd /mnt/ServerBackup/docker/"
alias testvpn="~/dotfiles/scripts/testDockerVpn.sh"
alias fixvpn="~/Scripts/fixvpn.sh"
alias updatedockers="~/Scripts/updateContainers.sh"
alias updatecontainers="~/Scripts/updateContainers.sh"
alias dcu="docker compose up"
alias dcd="docker compose down"
alias dcrm="docker compose rm"
alias dcs="docker compose stop"
alias dcp="docker compose pull"
alias dcpu="docker compose pull && docker compose up"
alias dcr="docker compose stop && dcrm; y; && dcp && dcu"
alias dcrc="docker compose stop && dcr; y; && dcp && dcu"
alias dce="sudo vim docker-compose.yml"
alias dcstats="docker compose stats"
alias dcl="docker compose logs -f"

# LetsEncrypt Docker Commands
alias editle='vim /mnt/ServerBackup/docker/storage/swag/config/nginx/site-confs/default'
alias logsle="docker logs -f --tail 50 swag"
alias alogsle='tail -f -n 20 /mnt/ServerBackup/docker/storage/swag/config/log/nginx/access.log'
alias restartle="docker restart organizr; docker restart swag; logsle"
alias proxies=" cd /mnt/ServerBackup/docker/storage/swag/config/nginx/proxy-confs"

# Organizr Docker Commands
alias editorg='vim /mnt/ServerBackup/docker/organizr/config/nginx/site-confs/default'
alias logsorg='docker logs -f --tail 50 organizr'
alias alogsorg='tail -f -n 20 /mnt/ServerBackup/docker/organizr/config/log/nginx/access.log'

#Minecraft Commands
alias minecraft="docker exec -it minecraft-regular bash"

# Open Web Servers
alias ojackett="firefox localhost:9117"
alias oradarr="firefox localhost:7878"
alias osonarr="firefox localhost:8989"
alias oplex="firefox localhost:32400/web"
alias otautulli="firefox localhost:3579"

# Wireguard Commands
alias wg="docker exec wireguard wg"
alias wireguard="cd /mnt/ServerBackup/docker/storage/wireguard/config/"


# Frigate Docker Commands
alias frigate="sudo vim /mnt/ServerBackup/docker/storage/frigate/config.yml"
alias frigatelogs="docker logs -f frigate"


#========================================================
#========================================================
#
# Proxmox Commands
#
#========================================================
#========================================================

alias vms="sudo cat /etc/pve/.vmlist"
alias vm="sudo qm"
alias stopvm="sudo qm stop"






# Reassign better tools to default commands
alias bat="batcat"

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PS1="${NEWPS1}"

#original_rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:

        #echo -en "   \033[38;5;$(echo $second)m█ "
LS_COLORS="rs=0:di=\033[38;5;033:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

# Hishtory Config:
export PATH="$PATH:/root/.hishtory"
source /root/.hishtory/config.sh

export PATH="$PATH:/root/fabric"

# Created by `pipx` on 2024-05-29 07:56:56
export PATH="$PATH:/root/.local/bin"
if [ -f "/root/.config/fabric/fabric-bootstrap.inc" ]; then . "/root/.config/fabric/fabric-bootstrap.inc"; fi
