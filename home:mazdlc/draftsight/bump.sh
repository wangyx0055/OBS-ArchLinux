#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://www.3ds.com/products-services/draftsight-cad-software/free-download/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP '(?<=for DraftSight )\d{4} [A-Za-z0-9]+'`
if [[ z${newver} != "z" && $oldver != ${newver/ /} ]] ; then
  echo "$oldver -> ${newver/ /}"
  sed -i "s/^pkgver=\S*$/pkgver=${newver/ /}/g" PKGBUILD
  #sed -i "s/${oldver}/${newver}/g" _service
  osc commit -m bump
fi