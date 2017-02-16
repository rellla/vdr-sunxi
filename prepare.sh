#!/bin/bash

# Defaults
HOST="client"
PLATFORM="armhf"

BASE=`pwd`
TMP=$BASE/tmp
VDR=$TMP/vdr
PLUGINSRCDIR=$VDR/PLUGINS/src

# Parse command line arguments and evaluate them
while [[ $# -gt 1 ]]
do
    key="$1"
    case $key in
	-h|--host)
	HOST="$2"
	shift
	;;
	-p|--platform)
	PLATFORM="$2"
	shift
	;;
	*)
	;;
    esac
    shift
done

if [ "$HOST" != "server" -a "$HOST" != "client" ]; then
	echo "Parameter error: -h | --host [server,client]"
	ERROR=1
fi
if [ "$PLATFORM" != "armhf" -a "$PLATFORM" != "i386" ]; then
	echo "Parameter error: -p | --platform [armhf,i386]"
	ERROR=1
fi

if [ "$ERROR" == "1" ]; then
	exit 0
fi

echo "Building with $HOST.cfg"
echo "Building for $PLATFORM"

# Set variables
cp $BASE/$HOST.cfg.template $BASE/plugins.cfg
PLUGINSCFG=$BASE/plugins.cfg

create_dirs() {
	if [ ! -e $TMP ]; then
		mkdir $TMP
	fi
}

create_makefile() {
	if [ -f $BASE/Makefile ]; then
		rm -f $BASE/Makefile
	fi
	cp $BASE/Makefile.$PLATFORM.template $BASE/Makefile
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
	if ! is_downloaded "vdr"; then
	    for i in $(find ./src/vdr-base -type f -name *.conf); do
		. $i
		echo "downloading $NAME... $DOWNLOAD"
		wget -O - "$DOWNLOAD" | tar x$ARCHIVE -C $TMP | touch $TMP/.vdr_downloaded
		ln -sf $PKGNAME $TMP/$NAME
		ln -sf $TMP/$NAME VDR
	    done
	else
	    echo $NAME already downloaded, please delete first!
	fi
}

patch_vdr() {
    for c in $(find ./src/vdr-base -type f -name *.conf); do
	. $c
	if ! is_patched "vdr"; then
	    if is_downloaded "vdr"; then
		# Dry-run
		for i in $(find ./src/vdr-base -type f -name *.diff); do
		    echo "DRYRUN: patching VDR..."
		    patch -d $VDR -f --dry-run -p0 < $i
		    if [ $? -ne 0 ]; then
			ERROR=1
		    fi
		done

		if [ "$ERROR" == "1" ]; then
		    echo "Some error occured during patching vdr"
		    exit 0
		fi

		# Action
		for i in $(find ./src/vdr-base -type f -name *.diff); do
		    echo "patching VDR..."
		    patch -d $VDR -f -r - -p0 < $i
		    touch $TMP/.vdr_patched
		done
	    else
		echo Please first download $NAME!
	    fi
	else
		echo $NAME already patched, please undo or delete first!
	fi
    done
}

download_plugin() {
	PLUGIN=$1
	PLUGIN_NAME=${PLUGIN/vdr-plugin-/}
	if ! is_downloaded $PLUGIN; then
	    echo "downloading $PLUGIN... $DOWNLOAD"
	    if [ "$ARCHIVE" == "git" ]; then
		git clone $DOWNLOAD $TMP/$PLUGIN | touch $TMP/.$PLUGIN"_downloaded"
	    else
		if [ ! -e $TMP/$PLUGIN ]; then
			mkdir $TMP/$PLUGIN
		fi
		wget -O - "$DOWNLOAD" | tar x$ARCHIVE -C $TMP/$PLUGIN --strip=1 | touch $TMP/.$PLUGIN"_downloaded"
	    fi
	    if [ "$BUILD" == "y" ]; then
		ln -sf $TMP/$PLUGIN$SUBDIR $PLUGINSRCDIR/$PLUGIN_NAME
	    fi
	else
	    echo $PLUGIN already downloaded, please delete first!
	fi
}

patch_plugin() {
    PLUGIN=$1
    PLUGIN_NAME=${PLUGIN/vdr-plugin-/}
    if ! is_patched $PLUGIN; then
	if is_downloaded $PLUGIN; then
	    # Dry-run
	    for i in $(find ./src/$PLUGIN/ -type f -name *.diff); do
		echo "DRYRUN: patching PLUGIN $NAME..."
		patch -d $PLUGINSRCDIR/$PLUGIN_NAME -f --dry-run -p0 < $i
		if [ $? -ne 0 ]; then
		    ERROR=1
		fi
	    done

	    if [ "$ERROR" == "1" ]; then
		echo "Some error occured during patching PLUGIN $PLUGIN_NAME"
		exit 0
	    fi

	    # Action
	    for i in $(find ./src/$PLUGIN/ -type f -name *.diff); do
		echo "patching PLUGIN $PLUGIN_NAME..."
		patch -d $PLUGINSRCDIR/$PLUGIN_NAME -f -r - -p0 < $i
	    done
	    touch $TMP/.$PLUGIN"_patched"
	else
	    echo Please first download $NAME!
	fi
    else
	echo $NAME already patched, please undo or delete first!
    fi
}

create_dirs
create_makefile

# Download
download_vdr
while read line
do
    PLUGIN=${line// =*/};
    BUILD=${line//vdr*= /};
    f="./src/$PLUGIN/$PLUGIN.conf"
    if [ "$BUILD" == "y" ]; then
	. $f
	download_plugin $PLUGIN
    fi
done < $PLUGINSCFG

# Patch
patch_vdr
while read line
do
    PLUGIN=${line// =*/};
    BUILD=${line//vdr*= /};
    f="./src/$PLUGIN/$PLUGIN.conf"
    if [ "$BUILD" == "y" ]; then
	. $f
	patch_plugin $PLUGIN
    fi
done < $PLUGINSCFG
