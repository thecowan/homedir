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
export LESS=-XRNF
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
  command -v dircolors > /dev/null 2>&1 && eval $(dircolors ~/.dir_colors/dircolors.256dark)
else
  command -v dircolors > /dev/null 2>&1 && eval "`dircolors -b 2>/dev/null`"
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


# Sane Defaults
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias grep='grep --color=always'
alias ax='chmod a+x'

alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
alias ~="cd ~"


# Prefer `prettyping` over `ping` when installed
[[ "$(command -v prettyping)" ]] \
    && alias ping="prettyping --nolegend"
# Prefer `htop` over `top` when installed
[[ "$(command -v htop)" ]] \
    && alias top="htop"
# Prefer `bat` over `cat` when installed
[[ "$(command -v bat)" ]] \
    && alias cat="bat"

if eza --icons &>/dev/null; then
    alias ls='eza --git --icons'
    alias ll='eza --git --icons -lF'
elif command -v eza &>/dev/null; then
    alias ls='eza --git'
    alias ll='eza --git -lF'
elif [[ $(command -v ls) =~ gnubin || $OSTYPE =~ linux ]]; then
    alias ls="ls --color=auto"
else
    alias ls="ls -G"
fi

alias tmux='tmux -f ~/.tmux.conf.interactive'

alias fuck='sudo $(history -p \!\!)'

command -v toilet > /dev/null 2>&1 && print -P "$USER_COLOR"; toilet -f smblock $HOST; print -P "$USER_COLOR"

command -v keychain > /dev/null 2>&1 && eval $(keychain --eval id_rsa --eval id_ed25519 --inherit any --noask -q)
command -v atuin > /dev/null 2>&1 && eval "$(atuin init zsh)"
