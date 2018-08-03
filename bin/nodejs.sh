#!/bin/bash
#
# Exécute le container docker dgricci/nodejs
#
# Constantes :
VERSION="0.0.1"
# Variables globales :
#readonly -A commands=(
#[nodejs]=""
#[node]=""
#[yarn]=""
#[npm]=""
#[gulp]=""
#)
#
proxyEnv=""
theShell="$(basename $0 | sed -e 's/\.sh$//')"
dockerCmd="docker run -e USER_ID=${UID} -e USER_NAME=${USER} --name=\"nodejs$$\""
dockerSpecialOpts="--rm=true"
dockerImg="dgricci/nodejs"
cmdToExec="$theShell"
#
unset show
unset noMoreOptions
#
# Exécute ou affiche une commande
# $1 : code de sortie en erreur
# $2 : commande à exécuter
run () {
    local code=$1
    local cmd=$2
    if [ -n "${show}" ] ; then
        echo "cmd: ${cmd}"
    else
        eval ${cmd}
    fi
    # go|godoc|gofmt --help returns 2 ...
    [ ${code} -ge 0 -a $? -ne 0 ] && {
        echo "Oops #################"
        exit ${code#-} #absolute value of code
    }
    [ ${code} -ge 0 ] && {
        return 0
    }
}
#
# Affichage d'erreur
# $1 : code de sortie
# $@ : message
echoerr () {
    local code=$1
    shift
    [ ${code} -ne 0 ] && {
        echo -n "$(tput bold)" 1>&2
        [ ${code} -gt 0 ] && {
            echo -n "$(tput setaf 1)ERR" 1>&2
        }
        [ ${code} -lt 0 ] && {
            echo -n "$(tput setaf 2)WARN" 1>&2
        }
        echo -n ": $(tput sgr 0)" 1>&2
    }
    echo -e "$@" 1>&2
    [ ${code} -ge 0 ] && {
        usage ${code}
    }
}
#
# Usage du shell :
# $1 : code de sortie
usage () {
    cat >&2 <<EOF
usage: `basename $0` [--help -h] | [--show|-s] commandAndArguments

    --help, -h          : prints this help and exits
    --show, -s          : do not execute $theShell, just show the command to be executed

    commandAndArguments : arguments and/or options to be handed over to ${theShell}.
                          The directory where this script is lauched is a
                          nodejs's project stands.
EOF
    exit $1
}
#
# Process argument
#
processArg () {
    arg="$1"
    cmdToExec="${cmdToExec} $arg"
}
#
# main
#
[ ! -z "${http_proxy}" ] && {
    dockerCmd="${dockerCmd} -e http_proxy=${http_proxy}"
}
[ ! -z "${https_proxy}" ] && {
    dockerCmd="${dockerCmd} -e https_proxy=${https_proxy}"
}
dockerCmd="${dockerCmd} -v${PWD}:/src"
case ${theShell} in
yarn|npm|gulp)
    dockerCmd="${dockerCmd} -it"
    ;;
esac
dockerCmd="${dockerCmd} -w/src"
while [ $# -gt 0 ]; do
    # protect back argument containing IFS characters ...
    arg="$1"
    [ $(echo -n ";$arg;" | tr "$IFS" "_") != ";$arg;" ] && {
        arg="\"$arg\""
    }
    if [ -n "${noMoreOptions}" ] ; then
        processArg "$arg"
    else
        case $arg in
        --help|-h)
            [ -z "${noMoreOptions}" ] && {
                run -1 "${dockerCmd} ${dockerSpecialOpts} ${dockerImg} ${cmdToExec} --help"
                usage 0
            }
            processArg "$arg"
            ;;
        --show|-s)
            show=true
            noMoreOptions=true
            ;;
        --)
            noMoreOptions=true
            ;;
        *)
            [ -z "${noMoreOptions}" ] && {
                noMoreOptions=true
            }
            processArg "$arg"
            ;;
        esac
    fi
    shift
done

run 100 "${dockerCmd} ${dockerSpecialOpts} ${dockerImg} ${cmdToExec}"

exit 0

