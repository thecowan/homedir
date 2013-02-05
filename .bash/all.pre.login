#----------------------------------------------------------#
# Bash Options
#----------------------------------------------------------#
set -o vi
# set -o ignoreeof

shopt -s cdspell
shopt -s cmdhist
shopt -s dotglob
shopt -s extglob
shopt -s autocd

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize




# Bash History Options

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Prevent common commands from being added to .bash_history
export HISTIGNORE="&:ls:jobs:[bf]g:exit:clear"
export HISTTIMEFORMAT="%F %T "

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000000
export HISTFILESIZE=1000000000



# Misc standard stuff

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"





# Color & Prompt stuff
# bashified from https://raw.github.com/sykora/etc/master/zsh/functions/spectrum/
declare -A FX FG BG
FX=(
  [reset]="\[\033[00m\]"
  [bold]="\[\033[01m\]"
  [no-bold]="\[\033[22m\]"
  [italic]="\[\033[03m\]"
  [no-italic]="\[\033[23m\]"
  [underline]="\[\033[04m\]"
  [no-underline]="\[\033[24m\]"
  [blink]="\[\033[05m\]"
  [no-blink]="\[\033[25m\]"
  [blink]="\[\033[07m\]"
  [no-blink]="\[\033[27m\]"
)

FG=()
BG=()
for color in {000..255}; do
  FG+=([$color]="\[\033[38;5;${color}m\]")
  BG+=([$color]="\[\033[48;5;${color}m\]")
done

declare -A rawcolors
rawcolors=([black]=30 [red]=31 [green]=32 [yellow]=33 [blue]=34 [magenta]=35 [cyan]=36 [white]=37)
for color in ${!rawcolors[*]}; do
  fgcode=${rawcolors[$color]}
  bgcode=$((${rawcolors[$color]} + 10))
  FG+=([$color]="\[\033[${fgcode}m\]" [light_$color]="\[\033[1;${fgcode}m\]")
  BG+=([$color]="\[\033[${bgcode}m\]" [light_$color]="\[\033[1;${bgcode}m\]")
done
FG+=([grey]="${FG[light_black]}" [gray]="${FG[light_black]}")
BG+=([grey]="${BG[light_black]}" [gray]="${BG[light_black]}")

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

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


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi


# Load custom functions
[[ -r ${HOME}/.bash/functions ]] && source ${HOME}/.bash/functions

COLOR_OFF=${FX[reset]}
if [ "$color_prompt" = yes ]; then
    USER_COLOR=${FG[light_blue]}
    DIR_COLOR=${FG[blue]}
    COLOR_SCM_BRANCH=${FG[red]}
    COLOR_SCM_STATE=${FG[light_red]}
    COLOR_PROMPT_OK=${FG[green]}
    COLOR_PROMPT_ERROR=${FG[red]}
elif [ "$color_prompt" = full ]; then
    USER_COLOR=${FG[025]}
    DIR_COLOR=${FG[111]}
    COLOR_SCM_BRANCH=${FG[172]}
    COLOR_SCM_STATE=${FG[160]}
    COLOR_PROMPT_OK=${FG[green]}
    COLOR_PROMPT_ERROR=${BG[red]}${FG[light_white]}
    PROMPT_COLOR=${FG[100]}
fi

# unset color_prompt force_color_prompt

PS2="moar!> "


export M2_HOME=/usr/local/maven
addToPath ${M2_HOME}/bin

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."


# Save bash log lines..
mkdir -p ~/.shell_logs
LASTSAVEDCMD="$(fc -l -n -1)"
function command_log() {
    local -i return_value=$?
    local last_line="$(fc -l -n -1)"
    local logfile="${HOME}/.shell_logs/${HOSTNAME}"
    local current_ts="$(date '+%Y-%m-%d %H:%M:%S')"
    if [ "${last_line}" != "$LASTSAVEDCMD" ]; then
        LASTSAVEDCMD="${last_line}"
        echo "${current_ts} [${$}%${LOGNAME}@${HOSTNAME%%.*}:${PWD}]'${last_line# }' → ${return_value}" >> "${logfile}"
    fi
}
# trap command_log DEBUG

f() {
    grep -h "$@"~/.shell_logs/* | sort | tail -n15
}


# From Nik's bash tips, modified not to include setPS1
case "$-" in
*i*)
  # Interactive shell

  # Breaks babysitter test if run automatically
  trap 'history -a; history -n; if [ "$BASH_COMMAND" != setPS1 ]; then echo -ne "\e]0;${USER}@${HOST}:$BASH_COMMAND\007"; fi' DEBUG
  ;;
*)
  # Non-interactive shell
  ;;
esac

