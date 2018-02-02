#!/usr/bin/env bash

set -e

# https://llvm.org/docs/CMake.html
# https://libcxx.llvm.org/docs/BuildingLibcxx.html

VERSION=$1

curl http://releases.llvm.org/${VERSION}/llvm-${VERSION}.src.tar.xz | tar -xJ
curl http://releases.llvm.org/${VERSION}/cfe-${VERSION}.src.tar.xz | tar -xJ
curl http://releases.llvm.org/${VERSION}/clang-tools-extra-${VERSION}.src.tar.xz | tar -xJ
curl http://releases.llvm.org/${VERSION}/libcxx-${VERSION}.src.tar.xz | tar -xJ
curl http://releases.llvm.org/${VERSION}/libcxxabi-${VERSION}.src.tar.xz | tar -xJ
curl http://releases.llvm.org/${VERSION}/compiler-rt-${VERSION}.src.tar.xz | tar -xJ

mv llvm-${VERSION}.src llvm
mv cfe-${VERSION}.src llvm/tools/clang
mv clang-tools-extra-${VERSION}.src llvm/tools/clang/tools/extra
mv libcxx-${VERSION}.src llvm/projects/libcxx
mv libcxxabi-${VERSION}.src llvm/projects/libcxxabi
mv compiler-rt-${VERSION}.src llvm/projects/compiler-rt

ABI=$PWD/llvm/projects/libcxxabi

mkdir clang-${VERSION}
pushd clang-${VERSION}

cmake -G "Unix Makefiles" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/usr/local/clang/clang-${VERSION} \
-DLIBCXX_CXX_ABI=libcxxabi \
-DLIBCXX_CXX_ABI_INCLUDE_PATHS=$ABI/include \
-DLIBCXX_CXX_ABI_LIBRARY_PATH=$PWD/lib \
../llvm

cmake --build .
cmake --build . --target cxx
cmake --build . --target install
cmake --build . --target install-cxx
cmake --build . --target install-cxxabi

popd

tar -cf - /usr/local/clang/clang-${VERSION} | xz -c -9 > standalone-clang-${VERSION}.tar.xz
