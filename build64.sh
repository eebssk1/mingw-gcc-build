#!/bin/sh

checkreturn(){
  if [ $1 -ne 0 ]; then
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

export CFLAGS="$(cat $SDIR/ff.txt)"
export CXXFLAGS="-fdeclone-ctor-dtor $CFLAGS"

cd m_binutils/build

../configure --target=x86_64-w64-mingw32 --prefix=$SDIR/x86_64-w64-mingw32 --enable-64-bit-bfd --enable-nls --disable-rpath --disable-multilib --enable-install-libiberty --enable-plugins --enable-deterministic-archives --disable-werror --enable-lto --disable-gdb --disable-gprof --without-gdb --without-gprof; checkreturn $?

make -j2 all; checkreturn $?
make install

rm -rf * .*

cd $SDIR

cp -a x86_64-w64-mingw32 x86_64-w64-mingw32-legacy

cp -a mingw-crt/ucrt64/. x86_64-w64-mingw32/x86_64-w64-mingw32/
cp -a mingw-crt/ucrt64-legacy/. x86_64-w64-mingw32-legacy/x86_64-w64-mingw32/

cd m_gcc/build

export lt_cv_deplibs_check_method='pass_all'

export CPPFLAGS_FOR_TARGET="-DWIN32_LEAN_AND_MEAN -DCOM_NO_WINDOWS_H"
export CFLAGS_FOR_TARGET="-fno-stack-protector -fdata-sections $(cat $SDIR/f.txt)"
export CXXFLAGS_FOR_TARGET="-fdeclone-ctor-dtor $CFLAGS_FOR_TARGET"

../configure --prefix=$SDIR/x86_64-w64-mingw32 --with-local-prefix=$SDIR/x86_64-w64-mingw32/local --target=x86_64-w64-mingw32 --enable-checking=release --with-arch=broadwell --with-tune=skylake --enable-libatomic --enable-threads=posix --enable-graphite --enable-fully-dynamic-string --enable-libstdcxx-filesystem-ts --enable-libstdcxx-time --disable-libstdcxx-pch --enable-lto --enable-libgomp --disable-multilib --disable-rpath --enable-nls --disable-werror --disable-symvers --disable-libstdcxx-debug --enable-languages=c,c++,lto; checkreturn $?
make -j2 all; checkreturn $?
make install

rm -rf * .*

mv $SDIR/x86_64-w64-mingw32 $SDIR/x86_64-w64-mingw32-m
mv $SDIR/x86_64-w64-mingw32-legacy $SDIR/x86_64-w64-mingw32

../configure --prefix=$SDIR/x86_64-w64-mingw32 --with-local-prefix=$SDIR/x86_64-w64-mingw32/local --target=x86_64-w64-mingw32 --enable-checking=release --with-arch=x86-64-v2 --with-tune=skylake --enable-libatomic --enable-threads=posix --enable-graphite --enable-fully-dynamic-string --enable-libstdcxx-filesystem-ts --enable-libstdcxx-time --disable-libstdcxx-pch --enable-lto --enable-libgomp --disable-multilib --disable-rpath --enable-nls --disable-werror --disable-symvers --disable-libstdcxx-debug --enable-languages=c,c++,lto; checkreturn $?
make -j2 all; checkreturn $?
make install

mv $SDIR/x86_64-w64-mingw32 $SDIR/x86_64-w64-mingw32-legacy
mv $SDIR/x86_64-w64-mingw32-m $SDIR/x86_64-w64-mingw32

rm -rf * .* || true

