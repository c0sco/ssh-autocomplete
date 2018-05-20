local PROGGIES='(ssh|scp|sftp|slogin|rsync)'
local KNOWN_HOSTS=~/.ssh/known_hosts
local SSH_CONFIG=~/.ssh/config

# Don't add users in the autocomplete list, .ssh/config should know who we want to ssh as
zstyle ':completion:*:'${PROGGIES}':*' users 

# Modified version of https://serverfault.com/a/170481
local autohosts=()
if [[ -r $SSH_CONFIG ]]; then
  autohosts=($autohosts ${${${(@M)${(f)"$(cat ${SSH_CONFIG})"}:#Host *}#Host }:#*[*?]*})
fi

if [[ -r $KNOWN_HOSTS ]]; then
  if [[ $(grep -c '^|' ${KNOWN_HOSTS}) -gt 0 ]]; then
    printf "${WHITE}*** `basename ${(%):-%x}` ***${RESET}\n"
    printf "${RED}[ERROR]${RESET} Not loading hashed ${KNOWN_HOSTS}\n\n"
  else
    autohosts=($autohosts ${${${(f)"$(cat ${KNOWN_HOSTS} || true)"}%%\ *}%%,*}) 2>/dev/null
  fi
fi

if [[ $#autohosts -gt 0 ]]; then
  zstyle ':completion:*:'${PROGGIES}':*' hosts $autohosts
fi
