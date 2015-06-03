export BASEDIR = $(shell pwd)

SRCDIR=VDR

include $(SRCDIR)/Make.config

VDRVERSION = $(shell sed -ne '/define VDRVERSION/s/^.*"\(.*\)".*$$/\1/p' $(SRCDIR)/config.h)
DATE = $(shell date +%Y%m%d"_"%H%M)

all clean clean-plugins plugins install:
	(export PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig; cd $(SRCDIR); $(MAKE) $@)
