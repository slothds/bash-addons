###################################################
### Bash History Hack [v1.2]
### by SlothDS
###################################################
if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    __bash_history_hack() {
        local history_size=100000
        local _tmp_pcmd

        [[ ${HISTCONTROL} != ignoredups:erasedups ]] && export HISTCONTROL=ignoredups:erasedups || true # no duplicate entries
        [[ ${HISTSIZE} -lt ${history_size} ]]        && export HISTSIZE=100000                  || true # big big history
        [[ ${HISTFILESIZE} -lt ${history_size} ]]    && export HISTFILESIZE=100000              || true # big big history

        if ! [[ ${PROMPT_COMMAND} =~ ^.+\;history\ \-a\;history\ \-r\;$ ]];then
            _tmp_pcmd="${PROMPT_COMMAND//history -[cnrw];/}"
            _tmp_pcmd="${_tmp_pcmd%;}"
            export PROMPT_COMMAND="${_tmp_pcmd};history -n;history -w;history -c;history -r;"
        fi

        unset history_size _tmp_pcmd
    }

    [[ ! ${PROMPT_COMMAND} =~ .*\;__bash_history_hack.* ]] && export PROMPT_COMMAND="${PROMPT_COMMAND%;};__bash_history_hack;" || true

    # append to history, don't overwrite it
    if [[ $(shopt|awk '/histappend/{print $2}') != on ]];then
        shopt -s histappend
    fi
    # allow save multi-line commands
    if [[ $(shopt|awk '/cmdhist/{print $2}') != on ]];then
        shopt -s cmdhist
    fi
#    if [[ $(shopt|awk '/lithist/{print $2}') != on ]];then
#        shopt -s lithist
#    fi

    # Search through history by arrows up\down
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi
