#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=libqxt"
oldver=$(cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$')
newver=$(curl -s $CHECK_URL|grep -oP '(?<=^pkgver=)\S*$')
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/${oldver}/${newver}/g" _service
  osc commit -m bump
fi