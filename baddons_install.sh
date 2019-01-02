#!/usr/bin/env bash

workdir=$(dirname $(realpath $0))
workgit='https://raw.githubusercontent.com/slothds/bash-addons/master/'

if [[ -f ${workdir}/addons.list && -r ${workdir}/addons.list ]]; then
    addons_list=$(cat ${workdir}/addons.list)
else
    addons_list=$(curl -kfSL ${workgit}/addons.list)
fi

while read -r addon; do
    IFS=':' read -ra add <<<"${addon}"

    echo "Installing ${add[0]}"
    if [[ -d ${workdir}/${add[1]} && -r ${workdir}/${add[1]}/install ]]; then
        irules=$(cat ${workdir}/${add[1]}/install)
    else
        irules=$(curl -kfSL ${workgit}/${add[1]}/install)
    fi

    while IFS=':' read -ra iarg; do
        case ${iarg[0]} in
            'script')
                _script=${iarg[1]}
                ;;
            'version')
                _version=${iarg[1]}
                ;;
        esac
        continue
    done <<<"${irules}"
done <<<"${addons_list}"
