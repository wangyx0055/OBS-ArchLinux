#!/bin/zsh
basedir=$(cd `dirname $0`;pwd)
REPO='home:mazdlc'
SRC_REPO=packages
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/${SRC_REPO}.git/plain/trunk/PKGBUILD?h=packages/"
cd $basedir

pkgname=""
pkgver=""
pkgrel=""
eval "`curl -s "${PKGBUILD_PREFIX}qt5"`"
if [[ $pkgver != "" ]] ; then
        curver=`cat PKGBUILD | grep -oP '(?<=pkgver=)\S+$'`
        currel=`cat PKGBUILD | grep -oP '(?<=pkgrel=)\S+$'`
        if [[ ${pkgver}${pkgrel} != ${curver}${currel} ]] ; then
            osc up
            sed -i "s:^pkgrel=\S*:pkgrel=${pkgrel}:g" PKGBUILD
            sed -i "s:^pkgver=\S*:pkgver=${pkgver}:g" PKGBUILD
            echo "Bump qt5-base from ${curver}-${currel} to $pkgver-$pkgrel"
            osc commit -m bump
        else
            echo "SKIP"
        fi
else
        echo "$line Not found on Archlinux repo"
        #echo $line >> $basedir/do_by_hand.txt
fi
