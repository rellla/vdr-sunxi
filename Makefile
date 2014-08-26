all clean clean-plugins install:
	(export PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig;cd src; $(MAKE) $@)
