# emcc-obf

This repository contains a modified version of the Emscripten compiler that includes an LLVM-based obfuscator. Specifically, it uses the [Hikari](https://github.com/61bcdefg/Hikari-LLVM15) obfuscator which is based on the [obfuscator-llvm](https://github.com/obfuscator-llvm/obfuscator)
project.

## Usage

A brief description of each flag can be found [here](https://github.com/HakonHarnes/emcc-obf/blob/main/docs/flags.md). Some of them are translated from 中文 to the best of my ability, sorry!
The flags operate at the LLVM-level and have to be passed to Emscripten through the `-mllvm` flag. For instance, if you want to add bogus control flow and set the probability to 100% for each basic block, you would have to do:

```shell
emcc -mllvm -enable-bcfobf -mllvm -bcf_prob 100 <file>.c
```

To only obfuscate certain functions, see [Function Annotations](https://github.com/HikariObfuscator/Hikari/wiki/Functions-Annotations).

## Building

Building LLVM from source can be a resource-intensive and time-consuming process, especially on slower or less powerful machines. Consider using the pre-built docker image instead: 

```shell
docker run -it hawkis/emcc-obf:latest
```

### Building with Docker

```shell
docker build -t emcc-obf .
docker run -it emcc-obf
```

### Building from source

Emscripten does not require compilation as it uses Python. However, the LLVM (which provides `Clang` and `wasm-ld`) and Binaryen components need to be compiled. Once compiled, you can simply modify the `.emscripten` file to specify the correct paths for these tools using the 
`LLVM_ROOT` and `BINARYEN_ROOT` variables. These variables may already be correct depending on the output of `emcc --generate-config`. Also, for convenience the Emscripten folder should be added to your path.

Note that `ninja install` installs the compiled binaries in the appropriate directories (usually `/usr/local/bin`), which may conflict with existing installations. If you've already installed LLVM and Binaryen, omit the `ninja install` command and edit the `.emscripten` file accordingly. 

#### Dependencies

Building locally requires the following dependencies:

- nodejs
- gcc
- cmake
- ninja
- python3

#### Building LLVM

```shell
git clone --recursive -b llvm-16.0.0rel https://github.com/61bcdefg/Hikari-LLVM15.git hikari
cd hikari
git submodule update --remote --recursive
mkdir build && cd build
cmake -G "Ninja" -DCMAKE_BUILD_TYPE=MinSizeRel -DLLVM_APPEND_VC_REV=on -DLLVM_ENABLE_PROJECTS='lld;clang' -DLLVM_TARGETS_TO_BUILD="host;WebAssembly" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DENABLE_LLVM_SHARED=1 ../llvm
ninja && ninja install
```

#### Building Binaryen

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

#### Configure emscripten

```shell
git clone https://github.com/emscripten-core/emscripten.git emscripten
git checkout fab93a2bff6273c882b0c7fb7b54eccc37276e03
emcc --generate-config
```
