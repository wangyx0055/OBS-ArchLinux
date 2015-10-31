#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://sourceforge.net/projects/buzztard/files/buzztard%20gstreamer%20extensions/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "gst-buzztrax-[0-9.]*(?=\.tar.gz)"|sed "s/gst-buzztrax-//g"|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/gst-buzztrax-\S*\.tar/gst-buzztrax-${newver}\.tar/g" _service
  osc commit -m bump
fi