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
alias cpwd='pwd | tr -d "\n" | pbcopy' # Copy the working path to clipboard
alias showHidden='defaults write com.apple.finder AppleShowAllFiles TRUE'
alias hideHidden='defaults write com.apple.finder AppleShowAllFiles FALSE'


unquarantine() {
    # DESC:  Manually remove a downloaded app or file from the MacOS quarantine
    # ARGS:  $1 (required): Path to file or app
    # USAGE: unquarantine [file]

    local attribute
    for attribute in com.apple.metadata:kMDItemDownloadedDate com.apple.metadata:kMDItemWhereFroms com.apple.quarantine; do
        xattr -r -d "${attribute}" "$@"
    done
}
