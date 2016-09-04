#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

__usage="USAGE: $ ./attsdk-commit.sh COMMIT_MESSAGE [REPO_DIR]"
__email="att.drt.sdk@gmail.com"
__author="attsdk"
__src_dir=$(pwd)

COMMIT_MSG="${1:-}"
REPO_DIR="${2:-}"

###############
## FUNCTIONS ##
###############
function check_required_params {
  __commit_message="${1:-}"

  if [[ -z ${__commit_message} ]] ; then
    print_error "Error: Missing params, please check usage!"
    print_message "${__usage:-}"
    
    exit 1
  fi
}

function exit_program {
	echo "Switching back to ${__src_dir}"
	echo "Exiting..."

	cd ${__src_dir}
	exit 1
}

##########
## MAIN ##
##########

echo "Loading common.sh"
if ! source "common.sh" ; then
	echo "Failed to load module common.sh"
	exit 1
fi

check_required_params ${COMMIT_MSG}

if [[ -z ${REPO_DIR} ]] ; then
	echo "Current directory is the working directory"
else
	echo "Switching to repository directory ${REPO_DIR}"
	cd ${REPO_DIR}	
fi

if ! git commit --author "${__author} <${__email}>" -m "${COMMIT_MSG}" ; then
	print_error "Error: Failed to commit changes"

	exit_program
fi

if ! git push ; then
	print_error "Error: Failed to push changes"
	print_message "Fix the issue and try to push changes manually"
	echo "git push"

	exit_program
fi

