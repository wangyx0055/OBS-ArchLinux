#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
PKGBUILD_PREFIX="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h="
CHECK_URL=${PKGBUILD_PREFIX}vhba-dkms
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`-`cat PKGBUILD|grep -oP '(?<=^pkgrel=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP '(?<=^pkgver=)\S*$'`-`curl -s $CHECK_URL|grep -oP '(?<=^pkgrel=)\S*$'`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  yaourt -G vhba-dkms
  if [ -d vhba-dkms ] ; then
    ls|grep -v _service|grep -v bump|grep -v vhba-dkms|while read line
    do
        osc remove $line
    done
    
    mv vhba-dkms/* ./
    rm -rf vhba-dkms
    ls|while read line;do osc add $line;done
    #sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
    sed -i "s/vhba-module-\S*-source\.tar/vhba-module-${newver}-source\.tar/g" _service
    osc commit -m bump
  fi
fi