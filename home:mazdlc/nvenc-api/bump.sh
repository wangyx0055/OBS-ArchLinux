#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
PKGBUILD_PREFIX="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h="
CHECK_URL=${PKGBUILD_PREFIX}nvenc-api
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP '(?<=^pkgver=)\S*$'`
oldsubdir=`echo $oldver|grep -oP "\d+\.\d+"`
newsubdir=`echo $newver|grep -oP "\d+\.\d+"`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  echo "$oldsubdir -> $newsubdir"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/${oldver}/${newver}/g" _service
  sed -i "s/${oldsubdir}/${newsubdir}/g" _service
  osc commit -m bump
fi