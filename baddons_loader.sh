###################################################
### Bash Add-Ons Loader
### by SlothDS (sloth[at]devils.su)
###################################################
if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    badd_pcl() {
        local pcl_position=$1
        local pcl_commands=$2
        local pcl_regexcln=$3
        local pcl_regexsrh

        case ${pcl_position} in
            '1' | 'begin' | 'start')
                pcl_position=1
                pcl_regexsrh="^${pcl_commands}(.*)"
                ;;
            '2' | 'end' | 'last')
                pcl_position=2
                pcl_regexsrh="(.*)${pcl_regexsrh}([;]{1})?\$"
                ;;
            *)
                pcl_position=0
                pcl_regexsrh="(.*)${pcl_commands}(.*)"
                ;;
        esac

        until [[ ${PROMPT_COMMAND} =~ ${pcl_regexsrh} ]]; do
            PROMPT_COMMAND=${PROMPT_COMMAND//${pcl_commands}/}
            if [[ -n ${pcl_regexcln} ]]; then
                PROMPT_COMMAND=${PROMPT_COMMAND//${pcl_regexcln}/}
            fi

            if [[ ${pcl_position} -gt 1 ]]; then
                PROMPT_COMMAND="${PROMPT_COMMAND};${pcl_commands};"
            else
                PROMPT_COMMAND="${pcl_commands};${PROMPT_COMMAND}"
            fi

            while [[ ${PROMPT_COMMAND} =~ (.*)[\;]{2,}(.*) ]]; do
                PROMPT_COMMAND="${BASH_REMATCH[1]};${BASH_REMATCH[2]}"
            done
            [[ ! ${PROMPT_COMMAND} =~ \;$ ]] && PROMPT_COMMAND="${PROMPT_COMMAND};" || true
            [[ ${PROMPT_COMMAND} =~ ^\; ]] && PROMPT_COMMAND=${PROMPT_COMMAND##\;} || true

            export PROMPT_COMMAND
        done
    }

    badd_loader() {
        if [[ -f /etc/bash-addons.conf && -r /etc/bash-addons.conf ]]; then
            source /etc/bash-addons.conf
        fi
        badd_ldir=${addons_directory:-'/usr/local/share/bash-addons.d'}
        badd_ltyp=${addons_lodertype:-'standalone'}

        case ${badd_ltyp} in
            'standalone')
                badd_loader
                ;;
            'autoload')
                badd_pcl 2 badd_loader
                ;;
        esac
        for bpc_addon in ${badd_ldir}/*.sh; do
            source ${bpc_addon}
        done
    }

    badd_loader
fi
