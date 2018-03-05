history_hack() {
    export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
    export HISTSIZE=100000                   # big big history
    export HISTFILESIZE=100000               # big big history
    case ${PROMPT_COMMAND} in
        *'history -a'*) ;;
        *)                export PROMPT_COMMAND="history -a;${PROMPT_COMMAND}" ;;
    esac
}

case ${PROMPT_COMMAND} in
    *'history_hack'*) ;;
    *)                export PROMPT_COMMAND="history_hack;${PROMPT_COMMAND}" ;;
esac

# append to history, don't overwrite it
if [ "x`shopt | awk '/histappend/{print $2}'`" != "xon" ];then
    shopt -s histappend
fi

# Search through history by arrows up\down
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
