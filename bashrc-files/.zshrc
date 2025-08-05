# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=20000000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

# configure_prompt() {
#     prompt_symbol=㉿
#     # Skull emoji for root terminal
#     #[ "$EUID" -eq 0 ] && prompt_symbol=💀
#     case "$PROMPT_ALTERNATIVE" in
#         twoline)
#             PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
#             # Right-side prompt with exit codes and background processes
#             #RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
#             ;;
#         oneline)
#             PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
#             RPROMPT=
#             ;;
#         backtrack)
#             PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
#             RPROMPT=
#             ;;
#     esac
#     unset prompt_symbol
# }

# https://chatgpt.com/c/683e3a6f-3cfc-8000-930b-3acfb619f33c aka https://chatgpt.com/share/683e3ad1-fef4-8000-aefd-e64592499410
configure_prompt() {
    prompt_symbol=㉿
    # Skull emoji for root terminal
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀

    # Show virtualenv name inline, unstyled (uses inherited color)
    local venv_info=''
    [ -n "$VIRTUAL_ENV" ] && venv_info="($(basename $VIRTUAL_ENV))─"

    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}'$venv_info$'(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            ;;
        oneline)
            PROMPT='${debian_chroot:+($debian_chroot)}'"$venv_info"'%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT='${debian_chroot:+($debian_chroot)}'"$venv_info"'%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac

    unset prompt_symbol
}


# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH=/home/peter/.local/bin:/home/peter/.local/bin:/home/peter/.pyenv/shims:/home/peter/.pyenv/bin:/home/peter/.goenv/bin:/home/peter/.local/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/peter/.dotnet/tools:/home/peter/.goenv/shims

alias ls='ls -lah --color=auto'

alias refresh='source /home/peter/.zshrc'

alias r='source /home/peter/.zshrc ; clear'

alias f='source /home/peter/.zshrc ; clear'

alias c='source /home/peter/.zshrc ; clear'

alias d='source /home/peter/.zshrc ; clear'

alias g='source /home/peter/.zshrc ; clear'

alias t='source /home/peter/.zshrc ; clear'

alias fd='source /home/peter/.zshrc ; clear'

alias cl='clear'

alias ex='exit'

. "$HOME/.cargo/env"
export PATH="$HOME:$PATH"

export hosts="/etc/hosts"

export Hosts="/etc/hosts"

export settings="/home/peter/.zshrc"

export Desktop='/home/peter/Desktop'
export desktop='/home/peter/Desktop'
export Downloads='/home/peter/Downloads'
export downloads='/home/peter/Downloads'

#------------------------------------------------------------------------------
# fancy_date(): print a complex timestamp with date, time, nanoseconds, timezone,
#               week/day, and day of year before each prompt.
#------------------------------------------------------------------------------
fancy_date() {
  local Y M D h m s N W DayOfWeek DayOfYear TimeZone
  Y=$(date +%Y)
  M=$(date +%m)
  D=$(date +%d)
  h=$(date +%H)
  m=$(date +%M)
  s=$(date +%S)
  N=$(date +%N) # Get nanoseconds

  W=$(date +%V) # %V gives the week number (01-53)
  DayOfWeek=$(date +%u) # %u gives the day of the week (1-7, Monday=1)
  DayOfYear=$(date +%j) # %j gives the day of the year (001-366)

  TimeZone=$(timedatectl show --property=Timezone --value 2>/dev/null || date +%Z)
  N=$(awk -v N_val="$N" 'BEGIN { printf "%09d", N_val }')

  printf "%s-%03d-%03d %03d.%03d.%03d.%s %s %s-W%03d-%03d %s-%03d\n" \
    "$Y" "$M" "$D" "$h" "$m" "$s" "$N" \
    "$TimeZone" \
    "$Y" "$W" "$DayOfWeek" \
    "$Y" "$DayOfYear"
}

# Ensure precmd_functions is an array
typeset -ga precmd_functions

# Check if fancy_date is already in precmd_functions before adding it
if ! (( ${precmd_functions[(I)fancy_date]} )); then
  precmd_functions+=(fancy_date)
fi

alias nmaphistory="history | grep nmap"
alias nmap-history="history | grep nmap"

alias scphistory='history | grep scp'
alias scp-history='history | grep scp'

alias rustscanhistory='history | grep rustscan'
alias rustscan-history='history | grep rustscan'

alias p002-wreath='sudo openvpn "/home/peter/Desktop/try hack me Wreath/Peter.Burbery.002/Peter.Burbery.002-wreath.ovpn"'

alias sshhistory='history | grep ssh'
alias ssh-history='history | grep ssh'

alias ipconfig='ifconfig'

alias ncathistory='history | grep nc'
alias ncat-history='history | grep nc'
alias nchistory='history | grep nc'
alias nc-history='history | grep nc'

alias sshuttlehistory='history | grep sshuttle'
alias sshuttle-history='history | grep sshuttle'
alias shuttlehistory='history | grep sshuttle'
alias shuttle-history='history | grep sshuttle'

alias vpn='sudo openvpn "/home/peter/Desktop/try hack me access codes/Peter.Burbery.ovpn"'

alias listener='sudo rlwrap nc -lnvp 443'

alias root='sudo su'

alias update='sudo apt update && sudo apt upgrade -y'

alias upgrade='sudo apt update && sudo apt upgrade -y'

# Function to make a directory and change into it
makedirectory() {
    mkdir -p "$1" && cd "$1"
}

make-directory() {
    mkdir -p "$1" && cd "$1"
}

makdir() {
    mkdir -p "$1" && cd "$1"
}

alias neofetch='fastfetch'

alias 100history='history | tail -n 100'

alias 100-history='history | tail -n 100'



alias 30history='history | tail -n 30'

alias 30-history='history | tail -n 30'

openvpn () {
    sudo openvpn "$@"
}

# Function to call xfreerdp3 when 'xfreerdp' is typed
xfreerdp () {
    xfreerdp3 "$@"
}

export rockyou="/usr/share/wordlists/rockyou.txt"

export rockyoutxt="/usr/share/wordlists/rockyou.txt"

export rockyou_txt="/usr/share/wordlists/rockyou.txt"

alias curlhistory='history | grep curl'
alias curl-history='history | grep curl'

# https://chatgpt.com/c/683f1d05-a764-8000-9447-79b6438ac1eb https://chatgpt.com/share/683f2d00-c090-8000-9745-226708bfa2d5

port() {
  if [ -z "$1" ]; then
    echo "Usage: check_port <port_number>"
    return 1
  fi

  PORT=$1
  if ss -tuln | grep -q ":$PORT "; then
    echo "Port $PORT is in use."
    return 1
  else
    echo "Port $PORT is available."
    return 0
  fi
}

alias vulnlab='sudo openvpn "/home/peter/Desktop/vulnlab/vulnlab access codes/machines and chains.ovpn"'

alias vuln='sudo openvpn "/home/peter/Desktop/vulnlab/vulnlab access codes/machines and chains.ovpn"'

alias vul='sudo openvpn "/home/peter/Desktop/vulnlab/vulnlab access codes/machines and chains.ovpn"'

alias vu='sudo openvpn "/home/peter/Desktop/vulnlab/vulnlab access codes/machines and chains.ovpn"'

alias re='source /home/peter/.zshrc'

alias hosts='tail $hosts'

export PATH=$PATH:/snap/bin

export proxychains='/etc/proxychains4.conf'

# for vulnlab control linux-chain

# export JWT="Qxhwdjli3lqu9fRvBo2tM3hISNJWZJldoOjDWZuzd14.H__O79eHmbIhoTkSJ4mmzzbgyfOI0IpekbUZcae3Rj4"

export JWT="E0foCNbTDOIFaOk6xkwmFZkBU4hNNVJd10cDXoP1jTw.4aO9Soebh3hMATiwJ9wYDl2VUQVuONy9z_Bd_Y-75mc"

alias sshpasshistory='history | grep sshpass'
alias sshpass-history='history | grep sshpass'

# This is to add .venv to path

# export PATH="$HOME/.venv/bin:$PATH"

alias hashcathistory='history | grep hashcat'
alias hashcat-history='history | grep hashcat'

export hybrid1='10.10.162.85'

export baby2='10.10.74.148'

alias githistory='history | grep git'
alias git-history='history | grep git'

export breach='10.10.127.41'

export tun0='10.8.6.152'

export sendai='10.10.81.213'

export Sendai='10.10.81.213'

alias wgethistory='history | grep wget'
alias wget-history='history | grep wget'

alias bloodhound_legacy='/home/peter/Desktop/bloodhound/BloodHound-linux-x64/BloodHound --no-sandbox > /dev/null 2>&1 &'

export sweep='10.10.116.175'

export Sweep='10.10.116.175'

export PATH=$PATH:~/go/bin

alias systemcontrolhistory='history | grep systemctl'
alias systemcontrol-history='history | grep systemctl'
alias system-control-history='history | grep systemctl'
alias system-controlhistory='history | grep systemctl'

export delegate='10.10.66.103'

export Delegate='10.10.66.103'

export media='10.10.97.70'

create_file() {
  touch "$@"
}

export bruno='10.10.68.117'

alias peas='peass'