#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://sourceforge.net/projects/opencore-amr/files/vo-aacenc/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "vo-aacenc-[0-9.]*(?=\.tar.gz)"|sed "s/vo-aacenc-//g"|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/vo-aacenc-\S*\.tar/vo-aacenc-${newver}\.tar/g" _service
  osc commit -m bump
fi