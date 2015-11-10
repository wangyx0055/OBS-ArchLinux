#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=firefox-kde-opensuse"
oldver=$(cat PKGBUILD|grep -oP '(?<=^pkgver=)\d{1,2}\.\d{1,2}')
newver=$(curl -s $CHECK_URL|grep -oP '(?<=^pkgver=)\d{1,2}\.\d{1,2}')
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/${oldver}/${newver}/g" _service
  sed -i "s/${oldver}/${newver}/g" PKGBUILD
  sed -i "s/${oldver}/${newver}/g" urls.txt
  osc commit -m bump
fi