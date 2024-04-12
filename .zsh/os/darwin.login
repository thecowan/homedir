alias go=open
alias ls="ls -FG"
alias top="top -F -R -o cpu"
alias man='man -P "less -+N"'

# MacPorts-friendly paths
path+=/opt/local/bin
path+=/opt/local/sbin
path+=/opt/homebrew/bin
path+=/opt/homebrew/sbin
path+=/opt/homebrew/opt/coreutils/libexec/gnubin
path+=/usr/local/git/current/bin

export SSH_ASKPASS="$HOME/bin/mac-ssh-askpass"

