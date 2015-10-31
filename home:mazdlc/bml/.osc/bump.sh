#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://sourceforge.net/projects/buzztard/files/buzz%20machine%20loader/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "bml-[0-9.]*(?=\.tar.gz)"|sed "s/bml-//g"|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/bml-\S*\.tar/bml-${newver}\.tar/g" _service
  osc commit -m bump
fi