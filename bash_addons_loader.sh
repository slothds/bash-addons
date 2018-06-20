###################################################
### Bash Add-Ons Loader [v3.0.1]
### by SlothDS (sloth[at]devils.su)
###################################################
set -x
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
            [[ ${PROMPT_COMMAND} =~ ^\; ]] && PROMPT_COMMAND=${PROMPT_COMMAND##;} || true

            export PROMPT_COMMAND
        done
    }

    # badd_dir=${addons_directory:-/usr/share/bash_addons.d}

    # for bpc_addon in ${badd_dir}/*; do
    #     source ${bpc_addon}
    # done
fi
