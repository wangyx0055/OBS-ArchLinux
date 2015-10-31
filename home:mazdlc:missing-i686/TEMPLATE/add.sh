#!/bin/zsh
basedir=$(cd `dirname $0`;pwd)
REPO='home:mazdlc:missing-i686'
PREFIX=""
SRC_REPO=community
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/${SRC_REPO}.git/plain/trunk/PKGBUILD?h=packages/"
for line in "$@"
do
    cd $basedir/../
    [ -d ${PREFIX}$line ] || osc meta pkg -e ${REPO} ${PREFIX}$line
    cd $basedir/../../
    osc co ${REPO}/${PREFIX}$line
    true
done

#osc up

for line in "$@"
do
    cd $basedir/../${PREFIX}$line || continue
    cp $basedir/_service ./
    cp $basedir/PKGBUILD ./
    pkgname=""
    pkgver=""
    depends=""
    
    eval "`curl -s "${PKGBUILD_PREFIX}${PREFIX}$line"`"
    echo $pkgname $pkgver $depends
    sed -i "s:PKGNAME:${pkgname}:g" PKGBUILD
    sed -i "s:VERSION:${pkgver}:g" PKGBUILD
    sed -i "s:DEPENDENCY:${depends}:g" PKGBUILD
    sed -i "s:PKGNAME:${pkgname}:g" _service
    osc add `ls`
    osc commit -m init
done