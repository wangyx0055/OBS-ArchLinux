#!/bin/zsh
#curl "https://projects.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/lib32-$1"|source /dev/stdin
#echo $pkgname
#echo $pkgver
#echo $depends
basedir=$(cd `dirname $0`;pwd)
cd $basedir/../

for line in "$@"
do
    osc meta pkg -e home:mazdlc:multilib lib32-$line
done

osc up

for line in "$@"
do
    cd $basedir/../lib32-$line
    cp $basedir/* ./
    curl "https://projects.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/lib32-$1"|source /dev/stdin
    sed -i "s:PKGNAME:${pkgname}:g" PKGBUILD
    sed -i "s:VERSION:${pkgver}:g" PKGBUILD
    sed -i "s:DEPENDENCY:${depends}:g" PKGBUILD
    sed -i "s:PKGNAME:${pkgname}:g" _service
    osc add `ls`
    osc commit -m init
done