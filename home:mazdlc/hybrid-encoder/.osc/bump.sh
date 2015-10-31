#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://www.xl-project.com/downloads.html"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
filename=`curl -s "http://www.selur.de/downloads"|grep -oP "Hybrid_\d{6}_64bit_binary_qt5\d*"`
newver=`echo $filename|grep -oP '\d{6}'`
qtver=`echo $filename|grep -oP 'qt5\d*'`
old_qtver=`cat PKGBUILD|grep -oP 'qt5\d+'|head -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/${oldver}/${newver}/g" _service
  sed -i "s/${old_qtver}/${qtver}/g" PKGBUILD
  sed -i "s/${old_qtver}/${qtver}/g" _service
  osc commit -m bump
fi