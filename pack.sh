#!/bin/sh

mkdir mingw-gcc

cp -a ./x86_64-w64-mingw32 ./i686-w64-mingw32 ./mingw-gcc/

cat rev > mingw-gcc/infs.txt
cat tag >> mingw-gcc/infs.txt

cd m_binutils
git log -7 > ../mingw-gcc/breplog.txt
cd ..

cd m_gcc
git log -7 > ../mingw-gcc/greplog.txt
cd ..

git log -7 > mingw-gcc/mreplog.txt

tar --gzip -cf mingw-gcc.tgz mingw-gcc
