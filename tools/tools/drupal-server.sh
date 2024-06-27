#!/usr/bin/env bash
TYPE=$1
if [[ "$TYPE" == "start" ]]; then
	colima start --cpu=4 --disk=100 --memory=6 --dns=1.1.1.1
	ddev start
elif [[ "$TYPE" == "stop" ]]; then
	ddev stop
elif [[ "$TYPE" == "restart" ]]; then
	ddev stop
	colima stop
	colima start --cpu=4 --disk=100 --memory=6 --dns=1.1.1.1
	ddev start
else
	echo No type i.e. start stop resart provided
fi
