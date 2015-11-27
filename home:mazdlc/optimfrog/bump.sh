#!/bin/sh
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://losslessaudio.org/Downloads.php"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
_newver=`curl -s "${CHECK_URL}"|grep -oP '(?<=OptimFROG_Linux_x64_)\d+'|sort -V|tail -1`
newver=`echo ${_newver}|sed 's/^\(.\{1\}\)/\1\./'`
if [[ z$newver != "z" && $oldver != $newver ]] ; then
  echo "$oldver -> $newver"
  sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
  sed -i "s/_${oldver//./}\.zip/_${_newver}\.zip/g" _service
  osc commit -m bump
fi