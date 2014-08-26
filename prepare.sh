#!/bin/bash

. ./depends.mk

prepare_vdr() {
    if [ ! -e ".vdr_downloaded" ]; then
	rm -rf src
	(wget -O - "$VDR_SOURCE" | tar xjv )
	(ln -s vdr-* src | touch .vdr_installed)
    fi

    if [ ! -e ".vdr_patched" ] && [ -e .vdr_installed ]; then
	for p in patches/*-vdr-*.diff; do
	    patch -f -r - -p 0 < $p
	done
	touch .vdr_patched
    fi
}

prepare_plugins() {
    for i in "${!ext_pluginlist[@]}"; do
	if [ ! -e "src/PLUGINS/src/$i/Makefile" ]; then
	    if [ $i == "vdrmanager" ]; then
		(cd src/PLUGINS/src/; wget -O - "${ext_pluginlist[$i]}" | tar xzv; ln -s vdr-manager-*/vdr-vdrmanager $i | echo "installed: $i")
	    elif [ $i == "skinflatplus" ]; then
		(cd src/PLUGINS/src/; wget -O - "${ext_pluginlist[$i]}" | tar xzv; ln -s *flatplus-* $i | echo "installed: $i")
	    else
		(cd src/PLUGINS/src/; wget -O - "${ext_pluginlist[$i]}" | tar xzv; ln -s *$i-* $i | echo "installed: $i")
	    fi
	fi
    done
    for p in patches/*-plugin-*.diff; do
	patch -f -r - -p 0 < $p
    done
    touch .plugins_patched
}

prepare_vdr
prepare_plugins
