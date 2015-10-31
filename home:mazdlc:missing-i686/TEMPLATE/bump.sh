#!/bin/zsh
basedir=$(cd `dirname $0`;pwd)
REPO='home:mazdlc:missing-i686'
SRC_REPO=community
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/${SRC_REPO}.git/plain/trunk/PKGBUILD?h=packages/"
rm $basedir/do_by_hand.txt
cd $basedir/../
ls|grep -v TEMPLATE|while read line
do
    cd $basedir/../$line
    pkgname=""
    pkgver=""
    depends=""
    eval "`curl -s "${PKGBUILD_PREFIX}${line}"`"
    if [[ $pkgver != "" ]] ; then
        curver=`cat PKGBUILD | grep -oP '(?<=pkgver=)\S+$'`
        if [[ $pkgver != $curver ]] ; then
            sed -i "s:^pkgver=\S*:pkgver=${pkgver}:g" PKGBUILD
            echo "Bump $line to $pkgver"
            osc commit -m bump
        else
            echo "SKIP"
        fi
    else
        echo "$line Not found on Archlinux repo"
        echo $line >> $basedir/do_by_hand.txt
    fi
done

zsh ${basedir}/../ffmpeg/bump.sh