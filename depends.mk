#!/bin/bash

VDR_SOURCE="ftp://ftp.tvdr.de/vdr/Developer/vdr-2.1.6.tar.bz2"

declare -A ext_pluginlist

ext_pluginlist=(
    [dummydevice]="http://phivdr.dyndns.org/vdr/vdr-dummydevice/vdr-dummydevice-2.0.0.tgz"
    [epgsearch]="http://winni.vdr-developer.org/epgsearch/downloads/beta/vdr-epgsearch-1.0.1.beta5.tgz"
    [epgsync]="http://vdr.schmirler.de/epgsync/vdr-epgsync-1.0.1.tgz"
    [femon]="http://www.saunalahti.fi/~rahrenbe/vdr/femon/files/vdr-femon-2.1.1.tgz"
    [live]="http://projects.vdr-developer.org/git/vdr-plugin-live.git/snapshot/vdr-plugin-live-69f84f95fa875c6f562294b1a6a1ea6f584d3f6c.tar.gz"
    [markad]="http://projects.vdr-developer.org/git/vdr-plugin-markad.git/snapshot/vdr-plugin-markad-c55f43f413dff8740f99d684e8879835d4409920.tar.gz"
    [peer]="http://vdr.schmirler.de/peer/vdr-peer-0.0.1.tgz"
    [remoteosd]="http://vdr.schmirler.de/remoteosd/vdr-remoteosd-1.0.0.tgz"
    [remotetimers]="http://vdr.schmirler.de/remotetimers/vdr-remotetimers-1.0.1.tgz"
    [sc]="http://85.17.209.13:6100/archive/29b7b5f231c8.tar.gz"
    [skinflatplus]="http://projects.vdr-developer.org/git/skin-flatplus.git/snapshot/skin-flatplus-c9150927a9e4aa00c64419503c8d3fc2d363f68b.tar.gz"
    [smarttvweb]="http://projects.vdr-developer.org/git/vdr-plugin-smarttvweb.git/snapshot/vdr-plugin-smarttvweb-b098218e1dc48b8e707f03c8fb495bb786ad1fba.tar.gz"
    [softhddevice]="http://projects.vdr-developer.org/git/vdr-plugin-softhddevice.git/snapshot/vdr-plugin-softhddevice-a3c0052c4b87b44679d8264c89d085fcda721a2e.tar.gz"
    [svdrposd]="http://vdr.schmirler.de/svdrposd/vdr-svdrposd-1.0.0.tgz"
    [svdrpservice]="http://vdr.schmirler.de/svdrpservice/vdr-svdrpservice-1.0.0.tgz"
    [streamdev]="http://projects.vdr-developer.org/git/vdr-plugin-streamdev.git/snapshot/vdr-plugin-streamdev-dd556ee7fdaea2ade54e9b6c383f44fa88a483f8.tar.gz"
    [vdrmanager]="http://projects.vdr-developer.org/git/vdr-manager.git/snapshot/vdr-manager-4119f8234452ad9fa01cd4950b31a3408e5b30c0.tar.gz"
    [vnsiserver]="http://github.com/FernetMenta/vdr-plugin-vnsiserver/tarball/3f11c8e92d72f43177ce143d4bd79ddbe5778c74"
)
