#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

__usage="USAGE: $ ./attsdk-commit.sh COMMIT_MESSAGE"
__email="att.drt.sdk@gmail.com"
__author="attsdk"

arg1="${1:-}"

function print_error {
 	__message="${1:-}"
 
 	tput setaf 1;
 	echo "${__message}"
 	tput sgr0;
}

function print_message {
	 __message="${1:-}"

	tput setaf 2;
	echo "${__message}"
	tput sgr0;
}

function check_params {
  __commit_message="${1:-}"

  if [[ -z ${__commit_message} ]]; then
    print_error "Error: Missing params, please check usage!"
    print_message "${__usage:-}"
    
    exit 1
  fi
}

##########
## MAIN ##
##########

check_params ${arg1}

if ! git commit --author "${__author} <${__email}>" -m "${arg1}" ; then
	print_error "Error: Failed to commit changes"

	exit 1
fi

if ! git push ; then
	print_error "Error: Failed to push changes "
	print_message "Fix the issue and try to push changes manually"
	echo "git push"
fi

