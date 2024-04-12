# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit -C
# End of lines added by compinstall
#


# ZSH version of multi-bash install
#
HOSTNAME=`hostname`
# allow for vanity hostname override
if [[ -r "/etc/vanity-hostname" ]]; then
  HOSTNAME=`cat /etc/vanity-hostname`
fi
if [[ -r "$HOME/.vanity-hostname" ]]; then
  HOSTNAME=`cat $HOME/.vanity-hostname`
fi

HOSTNAME=`echo ${HOSTNAME} | tr A-Z a-z`
HOST=${HOSTNAME%%.*}
OS=`uname | sed -e "s/_.*//" | tr A-Z a-z`
#
# build networks array -- this allows for login scripts that apply to increasinly more specific
# portions of a network.  For example, given the hostname 'server.sfo.example.com', the NETWORKS
# array would be: ( 'com', 'example.com', 'sfo.example.com' )
DOMAIN=${HOSTNAME#*.}
NETWORKS=()
while [[ "$HOST" != "$DOMAIN" && -n $DOMAIN ]]
do
  [[ "$DOMAIN" == "${NETWORKS[0]}" ]] && break
  NETWORKS=( "$DOMAIN" "${NETWORKS[@]}" )
  NEWDOMAIN=${DOMAIN#*.}
  [[ "$DOMAIN" == "$NEWDOMAIN" ]] && break
  DOMAIN=${NEWDOMAIN}
done
DOMAIN=


[[ -r ${HOME}/.zsh/all.pre.login ]] && source ${HOME}/.zsh/all.pre.login
[[ -r ${HOME}/.zsh/os/${OS}.login ]] && source ${HOME}/.zsh/os/${OS}.login

# iterate through networks
for NETWORK in "${NETWORKS[@]}"
do
  [[ -r ${HOME}/.zsh/network/${NETWORK}.login ]] && source ${HOME}/.zsh/network/${NETWORK}.login
done

# hostname or default -- this is necessary when I plugin to something like a DSL
# line and it assigns me some weird hostname based on the ip address.
if [[ -r ${HOME}/.zsh/host/${HOST}.login ]]; then 
	source ${HOME}/.zsh/host/${HOST}.login
elif [[ -r ${HOME}/.zsh/host/default.login ]]; then 
	source ${HOME}/.zsh/host/default.login
fi


# The HOST variable above resolves only to the local portion of the machine 
# hostname. For example, it would not differentiate between the machines
# "foo.bar.com" and "foo.example.com".  This last line allows you to create 
# a file that uses the fully qualified hostname.  
#
# Note that this should only be necessary if you have two machines with the 
# same name on two different networks and they need individual configurations
if [[ "$HOSTNAME" != "$HOST" && -r ${HOME}/.zsh/host/${HOSTNAME}.login ]]; then
   source ${HOME}/.zsh/host/${HOSTNAME}.login
fi


#FROM_HOST=`getConnectingHost`
#FROM_DOMAIN=`echo $FROM_HOST | sed -r "s/^.*?\.([^\.]*\.[^\.]*)$/\1/"`
#if [ -r $HOME/.bash/fromhost/$FROM_HOST.login ]; then
#	source $HOME/.bash/fromhost/$FROM_HOST.login
#fi
#
#if [ -r $HOME/.bash/fromhost/$FROM_DOMAIN.login ]; then
#	source $HOME/.bash/fromhost/$FROM_DOMAIN.login
#fi


[[ -r ${HOME}/.zsh/all.post.login ]] && source ${HOME}/.zsh/all.post.login

