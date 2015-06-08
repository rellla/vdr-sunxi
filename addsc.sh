#!/bin/bash

	if [[ $# -eq 1 ]]; then
	    REPO=$1
	else
	    echo "arguments not valid"
	    echo $#
	    exit 1
	fi

	if [ ! -e src/vdr-plugin-sc ]; then
		echo "vdr-plugin-sc directory missing"
		exit 1
	else
		sed -e s/URL0/${REPO}/g src/vdr-plugin-sc/vdr-plugin-sc.template > src/vdr-plugin-sc/vdr-plugin-sc.conf
		sed -e s/BUILD=n/BUILD=y/g -i src/vdr-plugin-sc/vdr-plugin-sc.conf
	fi
