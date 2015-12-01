#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://opencv.org/downloads.html"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP '(?<=opencv-)\d[0-9.]+\d'|sort -V|tail -1`
echo $oldver $newver

if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/${oldver}/${newver}/g" _service
  osc commit -m bump
fi
