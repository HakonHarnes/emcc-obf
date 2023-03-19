# emcc-obf

This repository contains a modified version of the Emscripten compiler that includes an LLVM-based obfuscator. Specifically, it uses the [Hikaru](https://github.com/61bcdefg/Hikari-LLVM15) obfuscator which is based on the [obfuscator-llvm](https://github.com/obfuscator-llvm/obfuscator)
project.

## Usage

A brief description of each flag can be found [here](https://github.com/HakonHarnes/emcc-obf/blob/main/docs/flags.md). Some of them are translated from 中國人 at the best of my ability, sorry!
The flags operate at the LLVM-level and have to be passed to Emscripten through the `-mllvm` flag. For instance, if you want to add bogus control flow and set the probability to 100% for each basic block, you would have to do:

```
emcc -mllvm -enable-bcfobf -bcf_prob 100 <file>.c
```

To only obfuscate certain functions, see [Function Annotations](https://github.com/HikariObfuscator/Hikari/wiki/Functions-Annotations).

## Building

### Docker

```shell
docker build -t emcc-obf .
docker run -it emcc-obf
```

You can now use `emcc`.

## Building locally

### Dependencies

Building locally requires the following dependencies:

- nodejs
- gcc
- cmake
- ninja
- python3

### Building LLVM

```shell
git clone --recursive -b llvm-16.0.0rel https://github.com/61bcdefg/Hikari-LLVM15.git hikari
cd hikari
git submodule update --remote --recursive
mkdir build && cd build
cmake -G "Ninja" -DCMAKE_BUILD_TYPE=MinSizeRel -DLLVM_APPEND_VC_REV=on -DLLVM_ENABLE_PROJECTS='lld;clang' -DLLVM_TARGETS_TO_BUILD="host;WebAssembly" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DENABLE_LLVM_SHARED=1 ../llvm
ninja && ninja install
```

### Building Binaryen

```shell
git clone https://github.com/WebAssembly/binaryen.git binaryen
cd binaryen
git checkout ecbebfbee12f2f25af648119604915fc37427f6f
git submodule init
git submodule update
mkdir build && cd build
cmake -G "Ninja" ..
ninja && ninja install
```

### Configure emscripten

```shell
git clone https://github.com/emscripten-core/emscripten.git emscripten
git checkout fab93a2bff6273c882b0c7fb7b54eccc37276e03
emcc --generate-config
```

Ensure `LLVM_ROOT` and `BINARYEN_ROOT` are correct in the `.emscripten` file. Also, for convenience the Emscripten folder should be added to your path.
