#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://labs.divx.com/divx265/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
oldver_underline=`echo $oldver|sed 's/\./_/g'`
newver_underline=`curl -s $CHECK_URL|grep -oP '(?<=DivX265_)\d{1,2}_\d{1,2}_\d{1,2}'|head -1`
newver=`echo $newver_underline|sed 's/_/\./g'`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/${oldver_underline}/${newver_underline}/g" _service
  osc commit -m bump
fi