log_file=~/install_progress_log.txt

sudo apt-get -y install zsh
if type -p zsh > /dev/null; then
    echo "zsh Installed" >> $log_file
else
    echo "zsh FAILED TO INSTALL!!!" >> $log_file
fi

sudo apt-get install zsh-syntax-highlighting

sudo apt-get -y install curl
if type -p curl > /dev/null; then
    echo "curl Installed" >> $log_file
else
    echo "curl FAILED TO INSTALL!!!" >> $log_file
fi


# ---
# Install git-completion and git-prompt
# ---
cd ~/
curl -OL https://github.com/git/git/raw/master/contrib/completion/git-completion.bash
mv ~/git-completion.bash ~/.git-completion.bash
curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
echo "git-completion and git-prompt Installed and Configured" >> $log_file


sudo apt-get -y install tmux
if type -p tmux > /dev/null; then
    echo "tmux Installed" >> $log_file
else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
fi

#==============
# Set zsh as the default shell
#==============
sudo chsh -s /bin/zsh


#==============
# Give the user a summary of what has been installed
#==============
echo -e "\n====== Summary ======\n"
cat $log_file
echo
rm $log_file
