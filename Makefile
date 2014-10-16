export BASEDIR = $(shell pwd)

include src/Make.config

VDRVERSION = $(shell sed -ne '/define VDRVERSION/s/^.*"\(.*\)".*$$/\1/p' src/config.h)
DATE = $(shell date +%Y%m%d"_"%H%M)
TARBALL = vdr-$(VDRVERSION)-armhf$(DATE).tar.bz2

TMPLOGOS=tmp/logos/
LOGOS=logos.tar.bz2
NOPACITYLOGOS="http://creimer.net/channellogos/nopacity-white-20140918.tar.bz2"

all clean clean-plugins plugins install:
	(export PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig; cd src; $(MAKE) $@)

archive: $(DESTDIR)/usr/local/bin/vdr
	(cd $(DESTDIR) &&\
	$(STRIP) --strip-unneeded usr/local/bin/vdr &&\
	$(STRIP) --strip-unneeded `find . -name lib*.so.* -print` &&\
	tar -cjvf ../$(TARBALL) . \
	)

logos: $(TMPLOGOS)$(LOGOS)
	rm -rf $(TMPLOGOS)/nopacity-white
	(	cd $(TMPLOGOS) &&\
		tar xjvf $(LOGOS) \
	)
	rm -rf $(DESTDIR)$(RESDIR)/plugins/skinflatplus/logos
	mkdir -p $(DESTDIR)$(RESDIR)/plugins/skinflatplus/logos
	(	cd $(TMPLOGOS)/nopacity-white &&\
		cp -a * $(DESTDIR)$(RESDIR)/plugins/skinflatplus/logos \
	)

$(TMPLOGOS)$(LOGOS):
	rm -rf $(TMPLOGOS)
	mkdir -p $(TMPLOGOS)
	wget $(NOPACITYLOGOS) -O $(TMPLOGOS)$(LOGOS)
