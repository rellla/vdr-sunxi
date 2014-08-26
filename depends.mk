#!/bin/bash

VDR_SOURCE="ftp://ftp.tvdr.de/vdr/Developer/vdr-2.1.6.tar.bz2"


declare -A ext_pluginlist

ext_pluginlist=(
    [dummydevice]="http://phivdr.dyndns.org/vdr/vdr-dummydevice/vdr-dummydevice-2.0.0.tgz"
    [epgsearch]="http://winni.vdr-developer.org/epgsearch/downloads/beta/vdr-epgsearch-1.0.1.beta5.tgz"
    [epgsync]="http://vdr.schmirler.de/epgsync/vdr-epgsync-1.0.1.tgz"
    [femon]="http://www.saunalahti.fi/~rahrenbe/vdr/femon/files/vdr-femon-2.1.1.tgz"
    [live]="http://projects.vdr-developer.org/git/vdr-plugin-live.git/snapshot/vdr-plugin-live-69f84f95fa875c6f562294b1a6a1ea6f584d3f6c.tar.gz"
    [markad]="http://projects.vdr-developer.org/git/vdr-plugin-markad.git/snapshot/vdr-plugin-markad-3c99d4782fa62a1e24aabb510ce6230dc00a5b31.tar.gz"
    [peer]="http://vdr.schmirler.de/peer/vdr-peer-0.0.1.tgz"
    [remoteosd]="http://vdr.schmirler.de/remoteosd/vdr-remoteosd-1.0.0.tgz"
    [remotetimers]="http://vdr.schmirler.de/remotetimers/vdr-remotetimers-1.0.1.tgz"
    [sc]="http://85.17.209.13:6100/archive/29b7b5f231c8.tar.gz"
    [skinflatplus]="http://projects.vdr-developer.org/git/skin-flatplus.git/snapshot/skin-flatplus-e50baedac033c52788f89ad7cb82a21860536147.tar.gz"
    [smarttvweb]="http://projects.vdr-developer.org/git/vdr-plugin-smarttvweb.git/snapshot/vdr-plugin-smarttvweb-b098218e1dc48b8e707f03c8fb495bb786ad1fba.tar.gz"
    [softhddevice]="http://projects.vdr-developer.org/git/vdr-plugin-softhddevice.git/snapshot/vdr-plugin-softhddevice-8b7402a397bf460e25a75add8059aa2eb83709ee.tar.gz"
    [svdrposd]="http://vdr.schmirler.de/svdrposd/vdr-svdrposd-1.0.0.tgz"
    [svdrpservice]="http://vdr.schmirler.de/svdrpservice/vdr-svdrpservice-1.0.0.tgz"
    [streamdev]="http://projects.vdr-developer.org/git/vdr-plugin-streamdev.git/snapshot/vdr-plugin-streamdev-703dffa0cbc324c30210b7a65e1d7f86eab4d463.tar.gz"
    [vdrmanager]="http://projects.vdr-developer.org/git/vdr-manager.git/snapshot/vdr-manager-4119f8234452ad9fa01cd4950b31a3408e5b30c0.tar.gz"
    [vnsiserver]="http://github.com/FernetMenta/vdr-plugin-vnsiserver/tarball/3f11c8e92d72f43177ce143d4bd79ddbe5778c74"
)