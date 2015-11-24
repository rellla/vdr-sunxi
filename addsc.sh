#!/bin/bash

BASE=`pwd`
PLUGINSCFG=$BASE/plugins.cfg

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
		echo "vdr-plugin-sc = y" >> $PLUGINSCFG
	fi
