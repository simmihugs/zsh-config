#######################################################
#######      Simons ZSH configuration file      #######
#######################################################

#######################################################
####### Export
#######################################################
export TERM="xterm-256color"                      # getting proper colors
export EDITOR="emacsclient -t -a ''"              # $EDITOR use Emacs in terminal
export VISUAL="emacsclient -c -a emacs"           # $VISUAL use Emacs in GUI mode


#######################################################
####### Bind keys 
#######################################################
autoload -U compinit
compinit
bindkey "^?" backward-delete-char
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

inTTY(){
    echo "Running in TTY - Some functionalities are currently unavailable"
}

notInTTY(){
    if [[ "$(which xsel)" != 'xsel not found' ]];then
        #######################################################
        ####### `kill-line` is the default ctrl+k binding
        #######################################################
        pb-kill-line () {
    	    zle kill-line      
    	    echo -n $CUTBUFFER | xsel --clipboard
        }
        zle -N pb-kill-line
        bindkey '^K' pb-kill-line  
    
        #######################################################
        ####### `yank` is the default ctrl+y binding
        #######################################################
        x-yank () {
    	    CUTBUFFER=$(xsel -o -b </dev/null)
    	    zle yank
        }
        zle -N x-yank
        bindkey -e '^Y' x-yank
        #######################################################
        ####### `copy-region-as-kill` is the default ctrl+shift+c binding
        #######################################################
	x-copy-region-as-kill () {
	    zle copy-region-as-kill
	    print -rn $CUTBUFFER | xsel -i -b
	}
	zle -N x-copy-region-as-kill
	bindkey -e '\ew' x-copy-region-as-kill
        #######################################################
        ####### `kill-region` is the default ctrl+shift+x binding
        #######################################################
	x-kill-region () {
	    zle kill-region
	    print -rn $CUTBUFFER | xsel -i -b
	}
	zle -N x-kill-region
	bindkey -e '^W' x-kill-region
    else
	echo "xsel not installed"
    fi
}

case $(tty) in 
  (/dev/tty[1-9]) inTTY;;
              (*) notInTTY;;
esac


#######################################################
####### Delete or Entf key 
#######################################################
bindkey  "^[[3~"  delete-char

#######################################################
####### Ctrl-backward workaround
#######################################################
bindkey "^[[1;5C" forward-word

#######################################################
####### Ctrl-backward workaround
#######################################################
bindkey "^[[1;5D" backward-word

#######################################################
####### Allow for negation syntax rm ^a.txt
#######################################################
setopt extended_glob 

#######################################################
####### Prompt
#######################################################

# Prompt ala
#╭[simmi@xubu] ~/Projects/xfce4-tint2tasks-plugin
#╰─>                                                                    on branch main

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

color1=36
color2=160
color3=81
color4=172
color5=11 

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats "%F{$color1} on branch %b"
 
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
NEWLINE=$'\n'
RPROMPT=\$vcs_info_msg_0_
# %F{X} <--> changes color to X
# %n <--> username
# %m <--> machine
# %(5~|%-1~/…/%2~|%4~) <--> shorten the path in prompt, if more then 3 directories deep, or more then 3 deep in ~
# PS1="%F{214}╭[%F{51}%n%F{255}@%F{197}%m%u%F{214}] %F{220}%(5~|%-1~/…/%2~|%4~) $NEWLINE%F{214}╰─>%F{255} "

PS1="%F{$color1}╭["
PS1+="%F{$color2}%n" #Username
PS1+="%F{$color3}@"
PS1+="%F{$color4}%m%u"
PS1+="%F{$color1}] "
PS1+="%F{$color5}%(5~|%-1~/…/%2~|%4~)"
PS1+="$NEWLINE"
PS1+="%F{$color1}╰─>%F{255} "

#######################################################
####### Aliases
#######################################################
alias ..="cd .."
alias cd..="cd .."
alias home="cd ~"
alias emacs_dir='~/.config/emacs/'
alias ionosServer='ssh simmi@212.227.213.103'
alias vpn.createctrl.com='xfreerdp /u:sgraetz /v:192.168.42.111 \
      				   /d:CreateCtrl /dynamic-resolution \
                                   /p:"$(gpg2 -q --for-your-eyes-only \
				    --no-tty -d ~/.password-store/work/email.gpg)"'
alias sshCip='ssh graetz@remote.cip.ifi.lmu.de "$(gpg2 -q --for-your-eyes-only --no-tty -d ~/.password-store/uni/remote-cip-ifi-lmu-de.gpg)"'

#######################################################
####### JAVA
#######################################################
export JAVA_HOME="/usr/lib64/openjdk-11/bin/"
if [ -d "/usr/lib64/openjdk-11/" ] ; then
    export PATH="/usr/lib64/openjdk-11/bin:$PATH"
fi

#######################################################
####### Autoload zsh modules when they are referenced
#######################################################
autoload -U history-search-end
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
#zmodload -ap zsh/mapfile mapfile
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

#######################################################
####### Set Variables
#######################################################
PATH="/usr/local/bin:/usr/local/sbin/:$PATH"
HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
HOSTNAME="$(echo /etc/hostname)"
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';

#######################################################
####### Load colors
#######################################################
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
   colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
done

#######################################################
####### Set Colors to use in in the script
#######################################################
# Normal
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

blue="#5FD7FF"
grey="#8A8A8A"
rosa="#FF5FD7"


#######################################################
####### Set alias 
#######################################################
alias ls="ls -CF --color=auto"


#######################################################
####### zstyle
#######################################################
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'


# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
#
#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}')
# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd\
        avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail\
        firebird gnats haldaemon hplip irc klog list man cupsys postfix\
        proxy syslog www-data mldonkey sys snort
# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show


export PATH=$PATH:~/.local/bin

#######################################################
###### rust
#######################################################
source /home/simmi/.cargo/env
#######################################################
## rust src
## rustup component add rust-src
#######################################################
#export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library
#######################################################
## racer
## https://github.com/racer-rust/racer
## rustup toolchain add nightly
## cargo +nightly install racer
#######################################################

#######################################################
####### nvm
#######################################################
alias start_nvm='export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'

# #######################################################
####### anaconda
#######################################################
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/simmi/.anaconda/bin/conda' 'shell.bash' 2> /dev/null)"
alias start_anaconda='
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/simmi/.anaconda/etc/profile.d/conda.sh" ]; then
        . "/home/simmi/.anaconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/simmi/.anaconda/bin:$PATH"
    fi
fi
unset __conda_setup
'

export PKG_CONFIG_PATH=/opt/local/lib/pkgconfig

######################################################
# CARGO
######################################################
PATH="/home/simon/.cargo/bin:$PATH"


######################################################
# COLOR
######################################################

autoload -U colors && colors	# Load colors


#######################################################
####### Source Plugins
#######################################################

#source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#ZSH_HIGHLIGHT_STYLES[default]=fg=red

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=222'

