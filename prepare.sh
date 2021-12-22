#!/usr/bin/env bash

function help() {
    echo "Usage: ./prepare.sh"
}

function setup_corpnet_proxy() {
    echo "use corpnet proxy: ${use_corpnet_proxy}"
    export http_proxy=
    export https_proxy=
    export ftp_proxy=
    curl http://google.com 1>/dev/null && echo "http proxy is ready."
    curl https://google.com 1>/dev/null && echo "https proxy is ready."
}

function main() {
    SUDO=""
    
    if [[ $(command -v sudo 2>/dev/null) ]]; then
        SUDO="sudo "
    fi
    
    verbose="FALSE"
    dryrun="FALSE"
    use_corpnet_proxy="FALSE"
    key=$1

    while [[ $# -gt 0 ]]; do
        case $1 in
            --use-corpnet-proxy )
                use_corpnet_proxy="TRUE"
            ;;
            -v|--verbose )    
                verbose="TRUE"
  	    ;;
            --dry-run )    
                dryrun="TRUE"
            ;;
            -h | --help )    
                help
                exit
            ;;
            * )              
                help
                exit 1
        esac
        shift
    done 

    if [[ "${use_corpnet_proxy}" == "TRUE" ]]; then 
            setup_corpnet_proxy 
    fi
   
    if [[ "${dryrun}" == "TRUE" ]]; then
	echo "dry-run finished."
	exit
    fi

    if [[ ! $(command -v node 2>/dev/null) ]]; then
        if [[ ! -f "./node-v16.13.1-linux-x64.tar.xz" ]]; then    
	        wget --no-check-certificate  https://nodejs.org/dist/v16.13.1/node-v16.13.1-linux-x64.tar.xz 
        fi
        ${SUDO} rm -rf /usr/local/node ; ${SUDO} tar -C /usr/local -xf node-v16.13.1-linux-x64.tar.xz && ${SUDO} mv /usr/local/node-v16.13.1-linux-x64  /usr/local/node 
        echo "export PATH=\$PATH:/usr/local/node/bin" 
    fi
    echo "Done."
}

main "$@" 
