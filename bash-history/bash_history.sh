if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    __bash_history_hack() {
        local history_size=100000

        [[ ${HISTCONTROL} != ignoredups:erasedups ]] && export HISTCONTROL=ignoredups:erasedups || true # no duplicate entries
        [[ ${HISTSIZE} < ${history_size} ]]          && export HISTSIZE=100000                  || true # big big history
        [[ ${HISTFILESIZE} < ${history_size} ]]      && export HISTFILESIZE=100000              || true # big big history

        if ! [[ ${PROMPT_COMMAND} =~ ^.+\;history\ \-a\;history\ \-r\;$ ]];then
            export PROMPT_COMMAND="$(echo "${PROMPT_COMMAND}"|sed 's/history \-a\;//g;s/history \-r\;//g;s/^\(.*\)\;$/\1/;');history -a;history -r;"
        fi

        unset history_size
    }

    [[ ! ${PROMPT_COMMAND} =~ .*__bash_history_hack.* ]] && export PROMPT_COMMAND="$(echo "${PROMPT_COMMAND}"|sed 's/^\(.*\)\;$/\1/;');__bash_history_hack;" || true

    # append to history, don't overwrite it
    if [[ $(shopt | awk '/histappend/{print $2}') != on ]];then
        shopt -s histappend
    fi

    # Search through history by arrows up\down
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi
