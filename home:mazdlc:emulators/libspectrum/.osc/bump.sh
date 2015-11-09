#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://sourceforge.net/projects/fuse-emulator/files/libspectrum/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "libspectrum-\d\.\d[0-9abrc.-]*[0-9abrc]"|sed "s/libspectrum-//g"|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/libspectrum-\S*\.tar/libspectrum-${newver}\.tar/g" _service
  osc commit -m bump
fi