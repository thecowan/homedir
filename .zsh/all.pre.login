#----------------------------------------------------------#
# zsh Options
#----------------------------------------------------------#

setopt autocd
setopt autopushd
setopt histignoredups
setopt histignorespace
export HISTSIZE=1000000
export HISTORY_IGNORE="(&|ls|jobs:[bf]g:exit:clear"


# Bash options I haven't replaced, TBD if useful
# shopt -s cdspell
# shopt -s cmdhist
# shopt -s dotglob
# shopt -s extglob
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

# Misc standard stuff

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# ##################################################################
# Fix broken termdefs. From https://gist.github.com/1167205
if [ "$TERM" = "xterm" ]; then
    if [ -z "$COLORTERM" ]; then
        if [ -z "$XTERM_VERSION" ]; then
            echo "Warning: Terminal wrongly calling itself 'xterm'."
        else
            case "$XTERM_VERSION" in
            "XTerm(256)") TERM="xterm-256color";;
            "XTerm(88)") TERM="xterm-88color";;
            "XTerm") ;;
            *)
                echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION";;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="gnome-256color";;
            Terminal)
                # special-case xfce4-terminal
                TERM="gnome-256color";;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM";;
        esac
    fi
fi

SCREEN_COLORS="`tput colors`"
if [ -z "$SCREEN_COLORS" ]; then
    case "$TERM" in
        screen-*color-bce)
            echo "Unknown terminal $TERM. Falling back to 'screen-bce'."
            export TERM=screen-bce  ;;
        *-88color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-88color'."
            export TERM=xterm-88color  ;;
        *-256color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-256color'."
            export TERM=xterm-256color  ;;
    esac
    SCREEN_COLORS=`tput colors`
fi
if [ -z "$SCREEN_COLORS" ]; then
    case "$TERM" in
        gnome*|xterm*|konsole*|aterm|[Ee]term)
            echo "Unknown terminal $TERM. Falling back to 'xterm'."
            export TERM=xterm  ;;
        rxvt*)
            echo "Unknown terminal $TERM. Falling back to 'rxvt'."
            export TERM=rxvt  ;;
        screen*)
            echo "Unknown terminal $TERM. Falling back to 'screen'."
            export TERM=screen  ;;
    esac
    SCREEN_COLORS=`tput colors`
fi
# ##################################################################

# set a fancy prompt (non-color, unless we know we "want" color)
tput setaf 1 >& /dev/null && color_prompt=yes
if [ "$SCREEN_COLORS" = "256" ]; then
    color_prompt=full;
fi


if [ "$color_prompt" = yes ]; then
    USER_COLOR=%F{13}
    DIR_COLOR=%F{blue}
    COLOR_SCM_BRANCH=%F{red}
    COLOR_SCM_STATE=%F{9}
    COLOR_PROMPT_OK=%F{green}
    COLOR_PROMPT_ERROR=%F{red}
elif [ "$color_prompt" = full ]; then
    USER_COLOR=%F{025}
    DIR_COLOR=%F{111}
    COLOR_SCM_BRANCH=%F{172}
    COLOR_SCM_STATE=%F{160}
    COLOR_PROMPT_OK=%F{green}
    COLOR_PROMPT_ERROR=%K{red}%F{15}
    PROMPT_COLOR=%F{100}
fi




# Load custom functions
[[ -r ${HOME}/.zsh/functions ]] && source ${HOME}/.zsh/functions


PS2="moar!> "

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."

