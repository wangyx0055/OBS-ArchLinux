#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://sourceforge.net/projects/aften/files/aften/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "Download aften-[0-9.]*(?=\.tar.bz2)"|sed "s/Download aften-//g"|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/aften-\S*\.tar/aften-${newver}\.tar/g" _service
  osc commit -m bump
fi
