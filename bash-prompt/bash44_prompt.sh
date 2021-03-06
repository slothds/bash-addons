###################################################
### Bash(v4.4) Prompt Generator [v2.2]
### by SlothDS
###################################################
if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    __bash_prompt_build() {
        local last_cmd_exit=$?
        local prompt_default prompt

        if ! [[ ${PROMPT_COMMAND} =~ ^__bash_prompt_build\;.+$ ]];then
            export PROMPT_COMMAND="__bash_prompt_build;${PROMPT_COMMAND//__bash_prompt_build;/}"
        fi

        if [[ -f /etc/bash.prompt && -r /etc/bash.prompt ]];then
            source /etc/bash.prompt
        fi

        if [[ -f ${HOME}/.bash_prompt && -r ${HOME}/.bash_prompt ]];then
            source ${HOME}/.bash_prompt
        fi

        color_enable=${color_enable:-yes}

        color_user=${color_user:-0;32}
        color_root=${color_root:-0;31}
        color_path=${color_path:-0;33}
        color_char=${color_char:-6;31}
        color_time=${color_time:--}
        color_git=${color_git:-6;36}

        string_user=${string_user:-\\u@\\h}
        string_path=${string_path:-\\w}
        string_char=${string_char:-\\$}
        string_time=${string_time:-[\\A] }
        string_git=${string_git:-(%s)}

        color_list=$(compgen -v|grep -P '^color_.+$'|tr '\n' ' ')
        if [[ -n ${color_enable} && ${color_enable} == yes ]];then
            REGEX='^((4|10)[0-7];)?([[:digit:]];)?(3|9)[0-7]$'
            for color in ${color_list};do
                [[ ! ${!color} =~ ${REGEX} ]] && unset ${color} || \
                eval ${color}='$(printf "\\\\[\\\\e[%sm\\\\]" "${!color}")'
            done
            unset color

            color_close="\[\e[0m\]"
            [[ $(id -u) == 0 ]] && color_user=${color_root} || true
        else
            unset ${color_list} color_list
        fi

        string_list=$(compgen -v|grep -P '^string_.+$'|tr '\n' ' ')
        for string in ${string_list};do
            part=${string#string_}
            eval color=\${color_${part}}
            [[ -n ${color} ]] && \
                eval ${string}="'${color}${!string}${color_close}'" \
            || \
                eval ${string}="'${!string}'"
            unset part color
        done
        unset string

        if [[ -z ${time_enable} || ${time_enable} != yes ]];then
            unset string_time
        fi
        if [[ -n ${git_enable} && ${git_enable} == yes ]];then
            if [ -f /etc/profile.d/git-prompt.sh ];then
                source /etc/profile.d/git-prompt.sh
                string_git=$(__git_ps1 "${string_git}")
            else
                unset string_git
            fi
        else
            unset string_git
        fi

        prompt_default="${string_time}${string_user} ${string_path}${string_git} ${string_char}"
        if [[ -z ${prompt} ]];then
            prompt=${prompt_default}
        else
            prompt="${prompt@P}"
        fi

        export PS1=" ${prompt@P} "

        unset ${string_list} string_list
        unset ${color_list} color_close color_list
        unset color_enable time_enable git_enable
        unset prompt_default prompt
        unset last_cmd_exit
    }

    [[ ! ${PROMPT_COMMAND} =~ .*__bash_prompt_build\;.* ]] && export PROMPT_COMMAND="__bash_prompt_build;${PROMPT_COMMAND#;}" || true
fi
