#!/bin/bash

BASE=`pwd`
TMP=$BASE/tmp
VDR=$TMP/vdr
PLUGINSRCDIR=$VDR/PLUGINS/src
PLUGINSCFG=$BASE/plugins.cfg

delete_plugin() {
	PLUGIN=$1
	echo "Deleting vdr-plugin-$PLUGIN ..."
	rm -rf $TMP/vdr-plugin-"$PLUGIN"
	rm -rf $TMP/.vdr-plugin-"$PLUGIN"_patched
	rm -rf $TMP/.vdr-plugin-"$PLUGIN"_downloaded
	rm -rf $PLUGINSRCDIR/$PLUGIN
}

delete_vdr() {
	echo "Deleting vdr ..."
	rm -rf $BASE/VDR
	rm -rf $TMP/vdr
	rm -rf $TMP/vdr-*.*.*
	rm -rf $TMP/.vdr_patched
	rm -rf $TMP/.vdr_downloaded
}

delete_sc() {
    echo "Deleting sc config ..."
    sed -i /"vdr-plugin-sc"/d $PLUGINSCFG
    rm -f $BASE/src/vdr-plugin-sc/vdr-plugin-sc.conf
}

delete_all() {
	echo "Deleting all ..."
	delete_plugins
	delete_vdr
	rm -rf $BASE/Makefile
	rm -rf $BASE/plugins.cfg
	rm -rf $TMP
}

delete_plugins() {
    echo "Deleting all plugins ..."
    while read line
    do
	if [[ $line == *"vdr-plugin-"* ]]; then
	    PLUGIN=${line// =*/};
	    PLUGIN_NAME=${PLUGIN//vdr-plugin-/}
	    delete_plugin $PLUGIN_NAME
	fi
    done < $PLUGINSCFG
    delete_sc
}

if [[ $# -lt 1 ]]; then
    echo "Error: at least one argument needed"
    exit 1
fi

while [[ $# -gt 0 ]]
do
    case $1 in
    vdr)
	delete_vdr
	shift
	;;
    plugins)
	delete_plugins
	shift
	;;
    plugin)
	delete_plugin $2
	shift
	shift
	;;
    all)
	delete_all
	shift
	;;
    *)
	echo "wrong argument (vdr|plugins|all| plugin *)"
	shift
	;;
    esac
done
