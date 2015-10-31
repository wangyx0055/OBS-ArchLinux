#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://sourceforge.net/projects/twolame/files/twolame/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "twolame-\d+\.\d+\.\d+"|sed "s/twolame-//g"|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/${oldver}/${newver}/g" _service
  osc commit -m bump
fi