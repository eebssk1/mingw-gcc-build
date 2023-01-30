#!/bin/sh

checkreturn(){
  if [ x$1 != x0 ]; then
    exit $1
  fi
}

if [ "x$(which ccache)" != "x" ]; then
ccache -o compression_level=3
ccache -o limit_multiple=0.7
ccache -o sloppiness=random_seed
fi

git clone https://github.com/eebssk1/m_gcc; checkreturn $?
git clone https://github.com/eebssk1/m_binutils; checkreturn $?

wget "https://github.com/eebssk1/mingw-crt-build/releases/download/520f40da/mingw-crt.tgz"
tar -xf mingw-crt.tgz
rm -rf mingw-crt.tgz

cd m_gcc
echo "GCC: $(git rev-parse --short HEAD)" >> ../rev
cd ..

cd m_binutils
echo "BinUtils: $(git rev-parse --short HEAD)" >> ../rev
cd ..

echo "UC: $(git rev-parse --short HEAD)" >> rev

date "+%Y-%m-%d_%H:%M:%S_%z" >> rev

od -x /dev/random | head -1 | awk '{print $2$3}' > tag

mkdir m_gcc/build
mkdir m_binutils/build
