#!/bin/sh
# problemtic
basedir=$(cd `dirname $0`;pwd)
cd $basedir
CHECK_URL="http://sourceforge.net/projects/sstp-client/files/network-manager-sstp/"
oldver=`cat PKGBUILD|grep -oP '(?<=^pkgver=)\S*$'`
oldrel=`cat PKGBUILD|grep -oP '(?<=^pkgrel=)\S*$'`
newver=`curl -s $CHECK_URL|grep -oP "(?<=title=\")\d{1,2}\.\d{1,2}\.\d{1,2}"|sort -V|tail -1`
newrel=`curl -s $CHECK_URL|grep -oP "(?<=title=\")\d{1,2}\.\d{1,2}\.\d{1,2}-\d"|sort -V|tail -1|grep -oP "(?<=-)\d"`

if [[ z${oldver}${oldrel} != z${newver}${newrel} && z$newver != "z" ]] ; then
    echo "${oldver}-${oldrel} \-\> ${newver}-${newrel}"
    sed -i "s/^pkgver=\S*$/pkgver=${newver}/g" PKGBUILD
    sed -i "s/^pkgrel=\S*$/pkgrel=${newrel}/g" PKGBUILD
    sed -i "s/${oldver}-${oldrel}/${newver}-${newrel}/g" _service
    sed -i "s/${oldver}/${newver}/g" _service
    osc commit -m bump
fi