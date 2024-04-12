#
# This zsh(1) config file is read during login on all machines, 
# after any host or OS specific files
#

path+=$HOME/bin
path+=$HOME/.local/bin
cdpath+=~

export EDITOR=vim
export VISUAL=${EDITOR}
export PAGER="less"
# Not using -N because of the weird linewrapping in man
export LESS=-XNF
export BLOCKSIZE=1024


# General ZSH settings
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %d
zstyle ':completion:*:descriptions' format %F{green}%d%f # green foreground
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' max-exports 5
zstyle ':vcs_info:git:*' formats '%b ' '±' ' on '
zstyle ':vcs_info:hg:*' formats '%b ' '☿' ' on '
zstyle ':vcs_info:svn:*' formats '%b ' '∫' ' on '


#----------------------------------------------------------#
# Let's add a little color to the world
#----------------------------------------------------------#
# TODO: build custom color DB (dircolor -p, example seq. '00;48;5;11;38;5;100')
# enable color support of ls (may be named dircolors or gdircolors)
#
#
if [ "$color_prompt" = full ]; then
  eval $(dircolors ~/.dir_colors/dircolors.256dark)
else
  eval "`dircolors -b 2>/dev/null`"
fi


# Prompt setup
newline=$'\n'
setopt PROMPT_SUBST
precmd() { vcs_info }
# TODO: prefix HISTORY_WARNING based on Bash (right at start):
#  if [ -z "$HISTFILE" ]; then
#    HISTORY_WARNING="✪ "
#  else
#    HISTORY_WARNING=""
#  fi
# TODO: update titlebar per the below?
PROMPT='${USER_COLOR}%n@%m%f%k:${DIR_COLOR}%~%f%k${vcs_info_msg_2_}${COLOR_SCM_BRANCH}${vcs_info_msg_0_}%f%k'$newline'[ %h %(?.${COLOR_PROMPT_OK}ʘ‿ʘ%f%k.${COLOR_PROMPT_ERROR}ಠ_ಠ%f%k) ] ${vcs_info_msg_1_:-$} '


# Callback function to set the command prompt PS1
# function setPS1
# {
#   # add information to titlebar if using xterm
#   if [ -z "${PS1_NO_TITLEBAR}" ]; then
#     case $TERM in
#       xterm*|rxvt*|gnome*|screen*)
#         local PS1_TITLEBAR="\[\e]0;${debian_chroot:+($debian_chroot)}$(whoami)@${HOST}:\w\a\]"
#         ;;
#       *)
#         local PS1_TITLEBAR=''
#         ;;
#     esac
#   fi
# 
#   export PS1="${PS1_TITLEBAR}${PS1}"
# }




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


alias tmux='tmux -f ~/.tmux.conf.interactive'

alias fuck='sudo $(history -p \!\!)'

eval $(keychain --eval id_rsa --eval id_ed25519 --inherit any --noask -q)
