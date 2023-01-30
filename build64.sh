#!/bin/sh

checkreturn(){
  if [ x$1 != x0 ]; then
    exit $1
  fi
}

export CC=gcc-12
export CXX=g++-12
if [ "x$(which ccache)" != "x" ]; then
export CC="ccache gcc-12"
export CXX="ccache g++-12"
fi

export SDIR=$PWD

export PATH=$SDIR/x86_64-w64-mingw32/bin:$PATH

cd m_binutils/build

../configure --target=x86_64-w64-mingw32 --prefix=$SDIR/x86_64-w64-mingw32 --enable-64-bit-bfd --enable-nls --disable-rpath --disable-multilib --enable-install-libiberty --enable-plugins --enable-deterministic-archives --disable-werror --enable-lto --disable-gdb --disable-gprof; checkreturn $?

make -j3 all; checkreturn $?
make install

rm -rf * .*

cd $SDIR

cp -a mingw-crt/ucrt64/. x86_64-w64-mingw32/x86_64-w64-mingw32/

cd m_gcc/build

export lt_cv_deplibs_check_method='pass_all'

export CPPFLAGS_FOR_TARGET="-DWIN32_LEAN_AND_MEAN -DCOM_NO_WINDOWS_H"
export CFLAGS_FOR_TARGET="-fno-stack-protector -ffunction-sections -fdata-sections $(cat $SDIR/f.txt)"
export CXXFLAGS_FOR_TARGET=$CFLAGS_FOR_TARGET

../configure --prefix=$SDIR/x86_64-w64-mingw32 --with-local-prefix=$SDIR/x86_64-w64-mingw32/local --target=x86_64-w64-mingw32 --enable-checking=release --with-arch=haswell --with-tune=skylake --enable-libatomic --enable-threads=posix --enable-graphite --enable-fully-dynamic-string --enable-libstdcxx-filesystem-ts --enable-libstdcxx-time --disable-libstdcxx-pch --enable-lto --enable-libgomp --disable-multilib --disable-rpath --enable-nls --disable-werror --disable-symvers --disable-libstdcxx-debug --with-languages=c,c++,lto; checkreturn $?
make -j3 all; checkreturn $?
make install

rm -rf * .* || true

