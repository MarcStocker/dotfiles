#-----------------
#--  Variables  --
#-----------------
  gitEmail="your_email@example.com"
#-----------------

# Update System
sudo apt update
yes | sudo apt upgrade

# Install Software
yes | sudo apt install vim htop git jq -y

# Setup Git
#--------------------------------------------------------------------------
## Generate SSH Key
  # Testing no user input, but already ran, so I'll test later. 
  # ssh-keygen -q -t ed25519 -f ~/.ssh/id_ed25519 -C "your_email@example.com" -N ""
ssh-keygen -t ed25519 -C "${gitEmail}"
## Add to ssh-agent
### start the ssh-agent in the background
$ eval "$(ssh-agent -s)"
## Add private key to agent
$ ssh-add ~/.ssh/id_ed25519
# Echo Public key for easy copy/paste
echo; echo; echo "SSH Public Key for GitHub";
echo "=============================="
cat ~/.ssh/id_ed25519.pub
echo "=============================="
echo; echo; echo;
#--------------------------------------------------------------------------

# Download/Clone DotFiles Git Repo
cd ~/
git clone git@github.com:MarcStocker/dotfiles.git

# Create Symbolic links for Configuration files so they can be used, editted, and updated in the repo, without having to copy the files over every time. 
# Also makes it so updates to the repo, are automatically applied to the config files.
ln -s ~/dotfiles/.bashrc ~/.
ln -s ~/dotfiles/.vimrc ~/.
# Apply config files
source ~/.bashrc

#Enable execution of some scripts
sudo chmod 755 ~/dotfiles/scripts/sshToServers.sh
