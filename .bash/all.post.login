#
# This bash(1) config file is read during login on all machines, 
# after any host or OS specific files
#
PROMPT_COMMAND='setPS1'

PROMPT="${USER_COLOR}\u@${HOST}${COLOR_OFF}:${DIR_COLOR}\w${COLOR_OFF} \$(in_repo)${COLOR_SCM_BRANCH}\$(hg_branch)\$(git_branch)\$(p4_client_name)\$(cloud_client)${COLOR_OFF}${COLOR_SCM_STATE}\$(hg_status)${COLOR_OFF}\n${PROMPT_COLOR}[\!] \$(prompt_char)${COLOR_OFF}"

addToPath $HOME/bin
addToPathVar CDPATH ~
addToPathVar CDPATH .
export EDITOR=vim
export VISUAL=${EDITOR}
export PAGER="less"



#----------------------------------------------------------#
# Let's add a little color to the world
#----------------------------------------------------------#
# enable color support of ls (may be named dircolors or gdircolors)
eval "`dircolors -b 2>/dev/null`"

# have `ls` output color if it knows how
if [[ `ls --version 2>/dev/null | grep coreutils` ]]; then
   alias ls &> /dev/null || alias ls="ls --color=auto -F"
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# general aliases

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Not yet working
if [ "$GROWL_ENABLED" = true ]; then
    alias alert="echo $'\e]9;Beep!\007'" 
else
    alias alert="echo -en \"\\007\""
fi
