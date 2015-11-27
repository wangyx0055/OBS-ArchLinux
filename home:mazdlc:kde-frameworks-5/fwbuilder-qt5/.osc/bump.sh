#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="https://github.com/UNINETT/fwbuilder/releases"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP '(?<=>v)\d\.\d\.\d'|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/${oldver}/${newver}/g" _service
  osc commit -m bump
fi