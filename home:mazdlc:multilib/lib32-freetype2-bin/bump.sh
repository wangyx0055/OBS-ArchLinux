#!/bin/zsh
basedir=$(cd `dirname $0`;pwd)
cd $basedir

REPO='home:mazdlc:multilib'
SRC_REPO=community
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/${SRC_REPO}.git/plain/trunk/PKGBUILD?h=packages/"
PKGNAME=lib32-freetype2

osc up
pkgname=""
pkgver=""
pkgrel=""
depends=""
eval "`curl -s "${PKGBUILD_PREFIX}${PKGNAME}"`"
if [[ $pkgver != "" ]] ; then
    curver=`cat PKGBUILD | grep -oP '(?<=pkgver=)\S+$'`
    currel=`cat PKGBUILD | grep -oP '(?<=pkgrel=)\S+$'`
    if [[ ${pkgver}${pkgrel} != ${curver}${currel} ]] ; then
        
        sed -i "s:^pkgver=\S*:pkgver=${pkgver}:g" PKGBUILD
        sed -i "s:^pkgrel=\S*:pkgrel=${pkgrel}:g" PKGBUILD
        echo "Bump gcc-libs-multilib from ${curver}-${currel} to $pkgver-$pkgrel"
        osc commit -m bump
        
    else
        echo "SKIP"
    fi
else
    echo "Not found on Archlinux repo"
fi
