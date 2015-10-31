#!/bin/zsh
basedir=$(cd `dirname $0`;pwd)
REPO='home:mazdlc:multilib'
PREFIX="lib32-"
SRC_REPO=community
PKGBUILD_PREFIX="https://projects.archlinux.org/svntogit/${SRC_REPO}.git/plain/trunk/PKGBUILD?h=packages/"


for line in "$@"
do
    cd $basedir/../
    export EDITOR="${basedir}/editor.sh"
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
    pkgrel=""
    depends=""
    provides=""
    conflicts=""
    eval "`curl -s "${PKGBUILD_PREFIX}${PREFIX}$line"|grep -vP "^options="`"
    echo $pkgname $pkgver ${depends[@]}
    sed -i "s:PKGNAME:${pkgname#lib32-}:g" PKGBUILD
    sed -i "s:VERSION:${pkgver}:g" PKGBUILD
    sed -i "s:DEPENDENCY:${depends[@]}:g" PKGBUILD
    sed -i "s:REVISION:${pkgrel}:g" PKGBUILD
    sed -i "s:PROVIDES:${provides[@]}:g" PKGBUILD
    sed -i "s:CONFLICTS:${conflicts[@]}:g" PKGBUILD
    sed -i "s:PKGNAME:${pkgname#lib32-}:g" _service
    osc add `ls`
    osc commit -m init
done