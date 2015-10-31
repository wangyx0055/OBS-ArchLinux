#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="https://github.com/seriyps/NetworkManager-l2tp/releases"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "\d\.\d.\d[0-9.]*"|head -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  rm _service
  cp temp_service _service
  sed -i "s/VERSION/${newver}/g" _service
  osc commit -m bump
fi