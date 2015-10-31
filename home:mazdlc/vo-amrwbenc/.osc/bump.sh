#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "vo-amrwbenc-[0-9.]*(?=\.tar.gz)"|sed "s/vo-amrwbenc-//g"|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/vo-amrwbenc-\S*\.tar/vo-amrwbenc-${newver}\.tar/g" _service
  osc commit -m bump
fi