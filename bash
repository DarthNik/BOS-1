#!/bin/bash

users()
{
	awk -F: '$3 >= 1000 {print $1 "\t" $6}' /etc/passwd | sort
}

processes()
{
	ps aux
}

help()
{
	echo "Usage: $0 [OPTION]."
	echo 'option:'
	echo '-u, --users	Display a list of users and their home directories'
	echo '-p, -processes	Display a list of running processes'
	echo '-h, --help	Show this message'
	echo '-l, --log PATH	Redirect the input to a file'
	echo '-e, --errors PATH	Redirect errors output to a file'
}

path_check()
{
	if !( echo $PATH | grep "$1" > 0); then
		echo 'Error: file does not exist' >&2
		exit 1
	fi
}

log()
{
	path_check "$1"
	exec 1> "$1"
}

errors()
{
	path_check "$1"
	exec 2> "$1" 
}

ARGS=$(getopt -o "upl:e:h" -l "users,processes,log:,errors:,help" -n "$0" -- "$@")

if [ $? != "0" ]; then
	echo 'Error: Incorrect input' >&2
	exit 1
fi

eval set - "$ARGS"

while true; do
	case "$1" in
		-u| --users) 
			users
			shift;;
		-p| --processes)
			processes
			shift;;
		-h| --help) 
			help
			shift;;
		-l| --log) 
			log "$2"
			shift 2;;
		-e| --errors)
			errors "$2"
			shift 2;;
		--)
			shift
			break;;
		*) echo "Error: Unknown parametr $1" >&2
		exit 1
	esac
done
