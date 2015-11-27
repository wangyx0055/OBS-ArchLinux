#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=k9copy-frameworks"
oldver=$(cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$')
newver=$(curl -s $CHECK_URL|grep -oP '(?<=^pkgver=)\S*$')
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  ls|grep -v _service|grep -v bump.sh|while read line
  do
    osc remove --force $line
  done
  
  yaourt -G k9copy-frameworks
  mv k9copy-frameworks/* ./
  rm -rf k9copy-frameworks
  
  eval "`cat ./PKGBUILD|grep -vP "^options="`"
  
  ls|while read line;do osc add $line;done
  sed -i "s/k9copy-${oldver}.tar/k9copy-${newver}.tar/g" _service
  
  
  osc commit -m bump
fi

#kdelibs4support