#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
PKGBUILD_PREFIX="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h="
CHECK_URL=${PKGBUILD_PREFIX}qwt-qt5
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP '(?<=^pkgver=)\S*$'`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/wineasio-\S*\.tar/qwt-${newver}\.tar/g" _service
  osc commit -m bump
fi