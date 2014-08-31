export BASEDIR = $(shell pwd)

include src/Make.config

VDRVERSION = $(shell sed -ne '/define VDRVERSION/s/^.*"\(.*\)".*$$/\1/p' src/config.h)
DATE = $(shell date +%Y%m%d"_"%H%M)
TARBALL = vdr-$(VDRVERSION)-armhf$(DATE).tar.bz2

TMPLOGOS=tmp/logos/
LOGOS=logos.tar.gz
NOPACITYLOGOS="http://creimer.net/channellogos/nopacity-logos-white-20140724.tar.gz"

all clean clean-plugins install:
	(export PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig; cd src; $(MAKE) $@)

archive: $(DESTDIR)/usr/local/bin/vdr
	(cd $(DESTDIR) &&\
	$(STRIP) --strip-unneeded usr/local/bin/vdr &&\
	$(STRIP) --strip-unneeded `find . -name lib*.so.* -print` &&\
	tar -cjvf ../$(TARBALL) . \
	)

logos: $(TMPLOGOS)$(LOGOS)
	rm -rf $(TMPLOGOS)/nopacitylogos
	(	cd $(TMPLOGOS) &&\
		tar xzvf $(LOGOS) \
	)
	rm -rf $(DESTDIR)$(RESDIR)/plugins/skinflatplus/logos
	mkdir -p $(DESTDIR)$(RESDIR)/plugins/skinflatplus/logos
	(	cd $(TMPLOGOS)/nopacitylogos/white &&\
		cp -a * $(DESTDIR)$(RESDIR)/plugins/skinflatplus/logos \
	)

$(TMPLOGOS)$(LOGOS):
	rm -rf $(TMPLOGOS)
	mkdir $(TMPLOGOS)
	wget $(NOPACITYLOGOS) -O $(TMPLOGOS)$(LOGOS)
