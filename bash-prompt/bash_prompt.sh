if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    __bash_prompt_build() {
        local string_list string_user string_path string_char string_time string_git
        local color_list color_user color_path color_char color_time color_git
        local color_enable time_enable git_enable
        local prompt_default prompt

        if [ -f "${HOME}/.bash_prompt" ];then
            source ${HOME}/.bash_prompt
        fi

        color_enable=${color_enable:-yes}

        color_user=${color_user:-0;32}
        color_path=${color_path:-3;33}
        color_char=${color_char:-2;33}
        color_time=${color_time:-0;00}
        color_git=${color_git:-6;36}

        string_user=${string_user:-\\u}
        string_path=${string_path:-\\w}
        string_char=${string_char:-\\$}
        string_time=${string_time:-\\A }
        string_git=${string_git:- (%s)}

        color_list=`compgen -v | grep -P '^color_.+$' | tr '\n' ' '`

        if [ -n "${color_enable}" -a "x${color_enable}" = "xyes" ];then
            REGEX='^[0-9]{1};[0-9]{2,3}$'
            for color in ${color_list};do
                if [[ ${!color} =~ ${REGEX} ]];then
                    eval ${color}='`printf "\\\\\\[\\\\\\e[%sm\\\\\\]" "${!color}"`'
                fi
            done
            unset color

            color_close="\[\e[0m\]"
            [ `id -u` -eq 0 ] && color_user="\[\e[0;31m\]" || true
        else
            unset ${color_list} color_list
        fi

        string_list=`compgen -v | grep -P '^string_.+$' | tr '\n' ' '`

        for string in ${string_list};do
            part=`echo ${string}|awk -F'_' '{print $2}'`
            eval color=\${color_${part}}
            if [ -n "${color}" -a "${color}" != "-" ];then
                eval ${string}="'${color}${!string}${color_close}'"
            else
                eval ${string}="\${!string}"
            fi
            unset part color
        done
        unset string

        if [ -n "${time_enable}" -a "x${time_enable}" != "xyes" ];then
            unset string_time
        fi
        if [ -n "${git_enable}" -a "x${git_enable}" = "xyes" ];then
            if [ -f /etc/profile.d/git-prompt.sh ];then
                source /etc/profile.d/git-prompt.sh
                string_git=`__git_ps1 "${string_git}"`
            else
                unset string_git
            fi
        else
            unset string_git
        fi

        prompt_default="${string_time}[ ${string_user} ${string_path}${string_git} ] ${string_char}"
        if [ -z "${prompt}" ];then
            prompt="${prompt_default}"
        else
            prompt=`eval echo "${prompt}"`
        fi

        export PS1=" ${prompt} "

        unset string_list ${string_list}
        unset color_list color_close ${color_list}
        unset color_enable time_enable git_enable
        unset prompt_default prompt
    }

    case ${PROMPT_COMMAND} in
        *'__bash_prompt_build'*)   ;;
        *)                  PROMPT_COMMAND="__bash_prompt_build;${PROMPT_COMMAND}" ;;
    esac
fi
