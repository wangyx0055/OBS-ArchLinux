#!/bin/zsh
basedir=$(cd `dirname $0`;pwd)
REPO='home:mazdlc:missing'
SRC_REPO=packages
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/${SRC_REPO}.git/plain/trunk/PKGBUILD?h=packages/"
PKGNAME=mplayer
cd $basedir
#osc up
pkgname=""
pkgver=""
pkgrel=""
depends=""
eval "`curl -s "${PKGBUILD_PREFIX}${PKGNAME}"|grep -vP "^options="`"
if [[ $pkgver != "" ]] ; then
    curver=`cat PKGBUILD | grep -oP '(?<=pkgver=)\S+$'`
    currel=`cat PKGBUILD | grep -oP '(?<=pkgrel=)\S+$'`
    if [[ ${pkgver}${pkgrel} != ${curver}${currel} ]] ; then
        sed -i "s:^pkgver=\S*:pkgver=${pkgver}:g" PKGBUILD
        sed -i "s:^pkgrel=\S*:pkgrel=${pkgrel}:g" PKGBUILD
        #sed -i "s:^depends=\(.*?\):depends=\(${depends[@]}\):g" PKGBUILD
        echo "Bump ${PKGNAME} from ${curver}-${currel} to $pkgver-$pkgrel"
        osc commit -m bump
        
    else
        echo "SKIP"
    fi
else
    echo "Not found on Archlinux repo"
fi
