alias go=open
alias ls="ls -FG"
alias top="top -F -R -o cpu"

# Not yet working - need to fix (and also make iTerm2-only)
# GROWL_ENABLED=true

# PS1COLOR='\[\033[0;34m\]' # blue prompt

# MacPorts-friendly paths
addToPath /opt/local/bin
addToPath /opt/local/sbin

export SSH_ASKPASS="$HOME/bin/mac-ssh-askpass"
