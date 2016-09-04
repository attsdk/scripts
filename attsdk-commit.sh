#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

__usage="USAGE: $ ./attsdk-commit.sh COMMIT_MESSAGE"
__email="att.drt.sdk@gmail.com"
__author="attsdk"

arg1="${1:-}"

function check_params {
  __commit_message="${1:-}"

  if [[ -z ${__commit_message} ]]; then
    tput setaf 1;
    echo "Error: Missing params, please check usage!"
    tput sgr0;

    tput setaf 2;
    echo "${__usage:-}"
    tput sgr0;
    
    exit 1
  fi
}

##########
## MAIN ##
##########

check_params ${arg1}

if ! git commit --author "${__author} <${_email}>" -m "${arg1}" ; then
  tput setaf 1;
	echo "Error: Failed to commit changes"
	tput sgr0;

	exit 1
fi

