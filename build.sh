#!/bin/bash

BASE=`pwd`
TMP=$BASE/tmp
VDRDIR=$TMP/vdr
PLUGINSRCDIR=$VDRDIR/PLUGINS/src

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
		    patch -d $VDRDIR -f -r - -p 0 < $i
		    touch $TMP/.$PKGNAME"_patched"
		fi
	    else
		echo $NAME already patched, please undo or delete first!
	    fi
	done
    done
}

patch_plugins() {
    for i in $(find $p -type f -name *.diff); do
	    if ! is_patched $PKGNAME; then
		if is_downloaded $PKGNAME; then
		    echo "patching $NAME..."
		    patch -d $PLUGINSRCDIR/$NAME -f -r - -p 0 < $i
		    touch $TMP/.$PKGNAME"_patched"
		fi
	    else
		echo $NAME already patched, please undo or delete first!
	    fi
    done
}


download_plugins() {
	if ! is_downloaded $PKGNAME; then
	    echo "downloading $NAME... $DOWNLOAD"
	    wget -O - "$DOWNLOAD" | tar x$ARCHIVE -C $TMP | touch $TMP/.$PKGNAME"_downloaded"
	    ln -sf $(find $TMP -type d -name $PKGNAME*) $PLUGINSRCDIR/$NAME
	else
	    echo $NAME already downloaded, please delete first!
	fi
}

create_dirs
download_vdr
patch_vdr

for p in $(find ./src -type d -name vdr-plugin*); do
    for i in $(find $p -type f -name *.conf); do
	. $i
	if [ "$BUILD" == "y" ]; then
	    download_plugins
	    patch_plugins
	fi
    done
done
