#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/packages.git/plain/trunk/PKGBUILD?h=packages/"
CHECK_URL=${PKGBUILD_PREFIX}ffmpeg
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
#oldrel=`cat PKGBUILD|grep -oP '(?<=^pkgrel=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP '(?<=^pkgver=)\S*$'`
newrel=`curl -s $CHECK_URL|grep -oP '(?<=^pkgrel=)\S*$'`
if [[ z$newver != "z" && ${oldver} != ${newver} ]] ; then
  echo "${oldver}-${oldrel} -> ${newver}-${newrel}"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/^pkgrel=\S*$/pkgrel=${newrel}/g" PKGBUILD
  sed -i "s/ffmpeg-\S*\.tar/ffmpeg-${newver}\.tar/g" _service
  osc commit -m bump
fi