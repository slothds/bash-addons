export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
case ${PROMPT_COMMAND} in
    *'history'*) ;;
    *)         export PROMPT_COMMAND="history -a;${PROMPT_COMMAND}" ;;
esac

# append to history, don't overwrite it
shopt -s histappend

# Search through history by arrows up\down
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
