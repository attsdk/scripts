#!/usr/bin/env bash

function print_error {
	__message="${1}"

	tput setaf 1;
	echo "${__message}"
	tput sgr0;
}

function print_message {
	__message="${1}"

	tput setaf 2;
	echo "${__message}"
	tput sgr0;
}

