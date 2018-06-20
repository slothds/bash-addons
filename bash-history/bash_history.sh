###################################################
### Bash History Hack [v3.0.1]
### by SlothDS (sloth[at]devils.su)
###################################################
if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    badd_history() {
        local history_size=100000
        local history_rule='history -a;history -n;history -w;history -c;history -r;'

        [[ ${HISTCONTROL} != ignoredups:erasedups ]] && export HISTCONTROL=ignoredups:erasedups || true # no duplicate entries
        [[ ${HISTSIZE} -lt ${history_size} ]] && export HISTSIZE=100000 || true                         # big big history
        [[ ${HISTFILESIZE} -lt ${history_size} ]] && export HISTFILESIZE=100000 || true                 # big big history

        badd_pcl begin "${history_rule}" 'history -[acnprsw]'

        unset history_size history_rule _hist_regex
    }

    badd_pcl end badd_history

    # append to history, don't overwrite it
    if [[ $(shopt | awk '/histappend/{print $2}') != on ]]; then
        shopt -s histappend
    fi
    # allow save multi-line commands
    if [[ $(shopt | awk '/cmdhist/{print $2}') != on ]]; then
        shopt -s cmdhist
    fi

    # Search through history by arrows up\down
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi
