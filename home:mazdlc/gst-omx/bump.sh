#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://gstreamer.freedesktop.org/src/gst-omx/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "gst-omx-[0-9.]*(?=\.tar.xz)"|sed "s/gst-omx-//g"|sort -V|tail -1`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/gst-omx-\S*\.tar/gst-omx-${newver}\.tar/g" _service
  osc commit -m bump
fi