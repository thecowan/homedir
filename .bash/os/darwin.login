alias go=open
alias ls="ls -FG"
alias top="top -F -R -o cpu"

# Not yet working - need to fix (and also make iTerm2-only)
# GROWL_ENABLED=true

# PS1COLOR='\[\033[0;34m\]' # blue prompt

# MacPorts-friendly paths
addToPath /opt/local/bin
addToPath /opt/local/sbin
addToPath /opt/homebrew/bin
addToPath /opt/homebrew/sbin
addToPath /opt/homebrew/opt/coreutils/libexec/gnubin
addToPath /usr/local/git/current/bin

export SSH_ASKPASS="$HOME/bin/mac-ssh-askpass"

export M2_HOME=/Users/cow/src/oss/apache-maven-3.2.3
export M2=$M2_HOME/bin
addToPath $M2
