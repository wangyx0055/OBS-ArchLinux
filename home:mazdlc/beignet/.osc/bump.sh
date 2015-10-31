#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=beignet"
oldver=$(cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$')
newver=$(curl -s $CHECK_URL|grep -oP '(?<=^pkgver=)\S*$')
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  ls|grep -v _service|grep -v bump.sh|while read line
  do
    osc remove --force $line
  done
  
  yaourt -G beignet
  mv beignet/* ./
  rm -rf beignet
  ls|while read line;do osc add $line;done
  sed -i "s/${oldver}/${newver}/g" _service
  osc commit -m bump
fi