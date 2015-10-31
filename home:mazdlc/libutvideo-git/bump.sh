#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
PKGBUILD_PREFIX="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h="
CHECK_URL=${PKGBUILD_PREFIX}libutvideo-git
oldver=`cat PKGBUILD|grep -oP '(?<=branch=)[0-9.]*'`
newver=`curl -s $CHECK_URL|grep -oP '(?<=branch=)[0-9.]*'`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/${oldver}/${newver}/g" PKGBUILD
  sed -i "s/${oldver}/${newver}/g" _service
  osc commit -m bump
fi