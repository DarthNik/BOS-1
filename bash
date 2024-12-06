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
	if [ -f $1 ]; then
		echo 'File exist'
	else
		echo 'Error: file does not exist' >&2
		exit 1
	fi
}

LOGFILE=""
ERRORFILE=""

log()
{
	LOGFILE="$1"
	path_check "$LOGFILE"
	exec 1> "$LOGFILE"
}

errors()
{
	ERRORFILE="$1"
	path_check "$ERRORFILE"
	exec 2> "$ERRORFILE" 
}

ARGS=$(getopt -o "upl:e:h" --long "users,processes,log:,errors:,help" -n "$0" -- "$@")

if [ $? != "0" ]; then
	echo 'Error: Incorrect input' >&2
	exit 1
fi

eval set -- "$ARGS"

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
			shift;
			break;;
		*) echo "Error: Unknown parametr $1" >&2
		exit 1;;
	esac
done
