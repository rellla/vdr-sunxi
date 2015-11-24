#!/bin/bash

BASE=`pwd`
TMP=$BASE/tmp
VDR=$TMP/vdr
PLUGINSRCDIR=$VDR/PLUGINS/src
PLUGINSCFG=$BASE/plugins.cfg

create_dirs() {
	if [ ! -e $TMP ]; then
		mkdir $TMP
	fi
}

is_downloaded() {
	if [ -e $TMP/.$1"_downloaded" ]; then
		return 0;
	else
		return 1;
	fi
}

is_patched() {
	if [ -e $TMP/.$1"_patched" ]; then
		return 0;
	else
		return 1;
	fi
}

download_vdr() {
    for i in $(find ./src/vdr-base -type f -name *.conf); do
	. $i
	if ! is_downloaded $PKGNAME; then
	    echo "downloading $NAME... $DOWNLOAD"
	    wget -O - "$DOWNLOAD" | tar x$ARCHIVE -C $TMP | touch $TMP/.$PKGNAME"_downloaded"
	    ln -sf $PKGNAME $TMP/$NAME
	    ln -sf $TMP/$NAME VDR
	else
	    echo $NAME already downloaded, please delete first!
	fi
    done
}

patch_vdr() {
    for c in $(find ./src/vdr-base -type f -name *.conf); do
	. $c
        for i in $(find ./src/vdr-base -type f -name *.diff); do
	    if ! is_patched $PKGNAME; then
		if is_downloaded $PKGNAME; then
		    echo "patching $NAME..."
		    patch -d $VDR -f -r - -p 0 < $i
		    touch $TMP/.$PKGNAME"_patched"
		fi
	    else
		echo $NAME already patched, please undo or delete first!
	    fi
	done
    done
}

download_plugin() {
	PLUGIN=$1
	PLUGIN_NAME=${PLUGIN/vdr-plugin-/}
	if ! is_downloaded $PLUGIN; then
	    echo "downloading $PLUGIN_NAME... $DOWNLOAD"
	    if [ "$ARCHIVE" == "git" ]; then
		git clone $DOWNLOAD $TMP/$PLUGIN_NAME | touch $TMP/.$PLUGIN"_downloaded"
	    else
		if [ ! -e $TMP/$PLUGIN_NAME ]; then
			mkdir $TMP/$PLUGIN_NAME
		fi
		wget -O - "$DOWNLOAD" | tar x$ARCHIVE -C $TMP/$PLUGIN_NAME --strip=1 | touch $TMP/.$PLUGIN"_downloaded"
	    fi
	    if [ "$BUILD" == "y" ]; then
		ln -sf $TMP/$PLUGIN_NAME$SUBDIR $PLUGINSRCDIR/$PLUGIN_NAME
	    fi
	else
	    echo $PLUGIN already downloaded, please delete first!
	fi
}

patch_plugin() {
    PLUGIN=$1
    PLUGIN_NAME=${PLUGIN/vdr-plugin-/}
    for i in $(find ./src/$PLUGIN/ -type f -name *.diff); do
	    if ! is_patched $PLUGIN; then
		if is_downloaded $PLUGIN; then
		    echo "patching $PLUGIN_NAME..."
		    patch -d $PLUGINSRCDIR/$PLUGIN_NAME -f -r - -p 0 < $i
		fi
	    else
		echo $NAME already patched, please undo or delete first!
	    fi
    done
    touch $TMP/.$PKGNAME"_patched"
}

create_dirs
download_vdr
patch_vdr

while read line
do
    PLUGIN=${line// =*/};
    BUILD=${line//vdr*= /};
    f="./src/$PLUGIN/$PLUGIN.conf"
    if [ "$BUILD" == "y" ]; then
	. $f
	download_plugin $PLUGIN
	patch_plugin $PLUGIN
    fi
done < $PLUGINSCFG
