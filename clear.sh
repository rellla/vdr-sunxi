#!/bin/bash

BASE=`pwd`
TMP=$BASE/tmp
VDR=$TMP/vdr
PLUGINSRCDIR=$VDR/PLUGINS/src
PLUGINSCFG=$BASE/plugins.cfg

delete_single_plugin() {
	echo Deleting vdr-plugin-$1 ...
}

delete_plugin() {
	declare -a PLUGIN
	for argument in $*; do
		PLUGIN[$i]="$argument"
		delete_single_plugin ${PLUGIN[$i]}
		i=$i+1
		shift
	done
}

delete_vdr() {
	echo "delete vdr"
}

delete_sc() {
    sed -i /"vdr-plugin-sc"/d $PLUGINSCFG
    rm -f $BASE/src/vdr-plugin-sc/vdr-plugin-sc.conf
}

delete_all() {
	rm -rf $TMP
	rm VDR
	delete_sc
	echo "delete all"
}

force_all() {
	echo "forced delete all"
}

delete_plugins() {
	echo "delete all plugins"
}


if [[ $# -lt 1 ]]; then
    echo "at least one argument needed"
    exit 1
fi

if [[ $# -eq 1 ]]; then
    case $1 in
    vdr)
	delete_vdr
	;;
    plugins)
	delete_plugins
	;;
    all)
	delete_all
	;;
    force)
	force_all
	;;
    *)
	echo "wrong argument"
	;;
    esac
fi

if [[ $# -gt 1 ]]; then
    case $1 in
    plugin)
	shift
	delete_plugin $*
	;;
    *)
	echo "wrong argument"
	;;
    esac
fi
