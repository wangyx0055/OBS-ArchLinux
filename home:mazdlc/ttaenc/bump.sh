#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://sourceforge.net/projects/tta/files/tta/ttaenc-src/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "ttaenc-[0-9.]*(?=-src\.tgz)"|sed "s/ttaenc-//g"|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/ttaenc-\S*-src\.tgz/ttaenc-${newver}-src\.tgz/g" _service
  osc commit -m bump
fi
