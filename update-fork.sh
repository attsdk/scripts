#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

__usage="USAGE: $ ./update-fork.sh [UPSTREAM_REPO_URL] [REPO_DIR]"
__src_dir=$(pwd)
__spaces="            "

UPSTREAM_REPO_URL="${1:-}"
REPO_DIR="${2:-}"

###############
## FUNCTIONS ##
###############
function exit_program {
  cd ${__src_dir}
  exit 1
}

function check_params {
  if [[ -z ${REPO_DIR} ]] ; then
    echo "Current directory is the working directory"
  else
    echo "Switching to repository director ${REPO_DIR}"
    cd ${REPO_DIR}
  fi

  if [[ -z ${UPSTREAM_REPO_URL} ]] ; then
    echo "Checking if Upstream is available"

    if ! git remote get-url --push upstrem ; then
      print_error "No upstream defined for this repo, in this case upstream repo URL is required"
      print_message "${__usage}"
      exit_program
    else
        echo "Adding upstream ${UPSTREAM_REPO_URL}..."
        if ! git remote add upstream ${UPSTREAM_REPO_URL} ; then
          print_error "Unable to add remote upstream, check the URL and try again!"
          exit_program
        fi
    fi
  else
    __url="$(git remote get-url --push upstream)"
    if [ ${__url} != ${UPSTREAM_REPO_URL} ] ; then
      print_error "Upstream repo provided url doesn't match the current one:"
      echo "${__url}"
      exit_program
    fi
  fi
}

##########
## MAIN ##
##########

echo "Loading common.sh"
if ! source "common.sh" ; then
  echo "Failed to load module common.sh"
  exit 1
fi

check_params

print_message "Fetching all branches from ${UPSTREAM_REPO_URL}"
if ! git fetch upstream ; then
  print_error "Cannot connect to remote"
  exit_program
fi

print_message "Checking out master branch"
if ! git checkout master ; then
  print_error "Something went wrong, exiting"
  exit_program
fi

print_message "Rewriting origin/master commits that aren't already in upstream/master"
if ! git rebase upstream/master ; then
  print_error "Something went wrong, exiting"
  print_message "${__spaces} git rebase upstream/master"
  print_message "${__spaces} git push -f origin master"
  exit_program
fi

print_message "Pushing changes to master"
if ! git push -f origin master ; then
  print_error "Failed to push to master, run the following command manually:"
  print_message "${__spaces} git push -f origin master"
  exit_program
fi

