#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/"
CHECK_URL=${PKGBUILD_PREFIX}wine-staging
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
oldrel=`cat PKGBUILD|grep -oP '(?<=^pkgrel=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP '(?<=^pkgver=)\S*$'`
newrel=`curl -s $CHECK_URL|grep -oP '(?<=^pkgrel=)\S*$'`
if [[ z$newver != "z" && ${oldver}${oldrel} != ${newver}${newrel} ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/^pkgrel=\S*$/pkgrel=${newrel}/g" PKGBUILD
  sed -i "s/staging-\S*\.tar/staging-${newver/rc/-rc}\.tar/g" _service
  osc commit -m bump
fi