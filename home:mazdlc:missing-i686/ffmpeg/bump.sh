#!/bin/zsh
basedir=$(cd `dirname $0`;pwd)
REPO='home:mazdlc:missing'
SRC_REPO=packages
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/${SRC_REPO}.git/plain/trunk/PKGBUILD?h=packages/"
cd $basedir
    pkgname=""
    pkgver=""
    depends=""
    eval "`curl -s "${PKGBUILD_PREFIX}ffmpeg"`"
    if [[ $pkgver != "" ]] ; then
        curver=`cat PKGBUILD | grep -oP '(?<=pkgver=)\S+$'`
        if [[ $pkgver != $curver ]] ; then
            sed -i "s:^pkgver=\S*:pkgver=${pkgver}:g" PKGBUILD
            sed -i "s:^depends=(\S*):depends=(${depends}):g" PKGBUILD
            echo "Bump ffmpeg to $pkgver"
            #osc commit -m bump
        else
            echo "SKIP"
        fi
    else
        echo "ffmpeg Not found on Archlinux repo"
    fi


