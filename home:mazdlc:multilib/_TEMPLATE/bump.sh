#!/bin/zsh
basedir=$(cd `dirname $0`;pwd)
REPO='home:mazdlc:multilib'
SRC_REPO=community
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/${SRC_REPO}.git/plain/trunk/PKGBUILD?h=packages/"
rm $basedir/do_by_hand.txt
cd $basedir/../
ls | grep -v TEMPLATE | while read line
do
    cd $basedir/../$line
    #osc up
    
    #osc results|grep broken && osc rebuildpac $REPO/$line
    
    pkgname=""
    pkgver=""
    pkgrel=""
    depends=""
    eval "`curl -s "${PKGBUILD_PREFIX}${line}"`"
    if [[ z$pkgver != "z" ]] ; then
        curver=`cat PKGBUILD | grep -oP '(?<=pkgver=)\S+$'`
        currel=`cat PKGBUILD | grep -oP '(?<=pkgrel=)\S+$'`
        if [[ ${pkgver}${pkgrel} != ${curver}${currel} ]] ; then
            osc up
            sed -i "s:^pkgver=\S*:pkgver=${pkgver}:g" PKGBUILD
            sed -i "s:^pkgrel=\S*:pkgrel=${pkgrel}:g" PKGBUILD
            echo "Bump $line from ${curver}-${currel} to $pkgver-$pkgrel"
            osc commit -m bump
        else
            echo "SKIP"
        fi
    else
        echo "$line Not found on Archlinux repo"
        #echo $line >> ${basedir}/do_by_hand.txt
    fi
done


cd $basedir/../
ls */bump.sh | grep -v TEMPLATE | while read line
do
  zsh $line
done

