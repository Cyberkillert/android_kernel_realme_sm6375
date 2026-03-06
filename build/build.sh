#!/bin/bash

set -e

export ARCH=arm64
export SUBARCH=arm64

export PATH=$PWD/clang/bin:$PATH

mkdir -p out

echo "Loading defconfig..."

DEFCONFIG=$(grep -h "^DEFCONFIG=" build.config* | head -n1 | cut -d= -f2)

if [ -z "$DEFCONFIG" ]; then
  DEFCONFIG=gki_defconfig
fi

echo "Using $DEFCONFIG"

make O=out ARCH=arm64 $DEFCONFIG
make O=out ARCH=arm64 olddefconfig

echo "Building kernel..."

make -j$(nproc) \
O=out \
ARCH=arm64 \
LLVM=1 \
LLVM_IAS=1
