if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    __bash_prompt_build() {
        local user_string path_string char_string time_string git_string
        local cc cu cw cp ct cg
        local user_color path_color char_color time_color git_color
        local time_enable git_enable
        local _user _path _char _time _git
        local prompt_default prompt_string

        if [ -f "${HOME}/.bash_prompt" ];then
            source ${HOME}/.bash_prompt
        fi

        color_enable=${color_enable:-yes}

        if [ -n "${color_enable}" -a "x${color_enable}" = "xyes" ];then
            cc="\[\e[0m\]"
            [ `id -u` -gt 0 ] && cu="\[\e[${user_color:-0;32}m\]" || cu="\[\e[0;31m\]"
            cw="\[\e[${path_color:-3;33}m\]"
            cp="\[\e[${char_color:-2;33}m\]"
            ct="\[\e[${time_color:-0;00}m\]"
            cg="\[\e[${git_color:-6;36}m\]"
        else
            unset cc cu cw cp ct cg
        fi
        user_string="${user_string:-\\u}"
        path_string="${path_string:-\\W}"
        char_string="${char_string:- \\$}"

        _user="${cu}${user_string}${cc}"
        _path="${cw}${path_string}${cc}"
        _char="${cp}${char_string}${cc}"
        if [ -n "${time_enable}" -a "x${time_enable}" = "xyes" ];then
            time_string="${time_string:-\\A }"
            _time="${ct}${time_string}${cc}"
        fi
        if [ -n "${git_enable}" -a "x${git_enable}" = "xyes" ];then
            if [ -f /etc/profile.d/git-prompt.sh ];then
                source /etc/profile.d/git-prompt.sh
                git_string="${git_string:- (%s)}"
                _git="${cg}`__git_ps1 "${git_string}"`${cc}"
            fi
        fi

        prompt_default="${_time}[ ${_user} ${_path}${_git} ]${_char}"
        if [ -z "${prompt_string}" ];then
            prompt_string="${prompt_default}"
        else
            prompt_string=`eval echo "${prompt_string}"`
        fi

        export PS1=" ${prompt_string} "

        unset user_string path_string char_string time_string git_string
        unset cc cu cw cp ct cg
        unset user_color path_color char_color time_color git_color
        unset time_enable git_enable
        unset _user _path _char _time _git
        unset prompt_default prompt_string
    }

    case ${PROMPT_COMMAND} in
        *'__bash_prompt_build'*)   ;;
        *)                  PROMPT_COMMAND="__bash_prompt_build;${PROMPT_COMMAND}" ;;
    esac
fi
