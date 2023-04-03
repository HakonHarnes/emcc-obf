# emcc-obf

This repository contains a modified version of the Emscripten compiler that includes an LLVM-based obfuscator. Specifically, it uses the [Hikari](https://github.com/61bcdefg/Hikari-LLVM15) obfuscator which is based on the [obfuscator-llvm](https://github.com/obfuscator-llvm/obfuscator) project.

**Disclaimer:** Some of the documentation is translated from 中文 to the best of my ability, sorry!

## Table of Contents

- [Usage](#usage)
  - [Flags](#flags)
  - [Environment Variables](#environment-variables)
- [Building](#building)
  - [Building with Docker](#building-with-docker)
  - [Building from Source](#building-from-source)
    - [Dependencies](#dependencies)
    - [Building LLVM](#building-llvm)
    - [Building Binaryen](#building-binaryen)
    - [Configure Emscripten](#configure-emscripten)
- [License](#license)

## Usage

The flags operate at the LLVM-level and have to be passed to Emscripten through the `-mllvm` flag. For instance, if you want to add bogus control flow and set the probability to 100% for each basic block, you would have to do:

```shell
emcc -mllvm -enable-bcfobf -mllvm -bcf_prob 100 <file>.c
```

To only obfuscate certain functions, see [Function Annotations](https://github.com/HikariObfuscator/Hikari/wiki/Functions-Annotations).

**Note:** You may need to turn off optimization so that the obfuscation is not optimized away by the compiler.

### Flags

| Flag                       | Description                                                                                      | Default  |
| -------------------------- | ------------------------------------------------------------------------------------------------ | -------- |
| **All obfuscation**        |                                                                                                  |          |
| `enable-allobf`            | Enable all obfuscation passes.                                                                   | `false`  |
| **AntiClassDump**          |                                                                                                  |          |
| `enable-acdobf`            | Enable AntiClassDump pass.                                                                       | `false`  |
| `acd-use-initialize`       | Inject codes to initialize.                                                                      | `true`   |
| `acd-rename-methodimp`     | Rename methods imp.                                                                              | `false`  |
| **AntiDebugging**          |                                                                                                  |          |
| `enable-adb`               | Enable AntiDebugging pass.                                                                       | `false`  |
| `adbextirpath`             | External path pointing to pre-compiled AntiDebugging IR.                                         | `""`     |
| `adb_prob`                 | Probability (%) for each function to be obfuscated by AntiDebugging.                             | `40`     |
| **AntiHooking**            |                                                                                                  |          |
| `enable-antihook`          | Enable AntiHooking pass.                                                                         | `false`  |
| `adhexrirpath`             | External path pointing to pre-compiled AntiHooking IR.                                           | `""`     |
| `ah_inline`                | Check Inline Hook for AArch64.                                                                   | `true`   |
| `ah_objcruntime`           | Check Objective-C Runtime Hook.                                                                  | `true`   |
| `ah_antirebind`            | Make fishhook unavailable.                                                                       | `false`  |
| **BogusControlFlow**       |                                                                                                  |          |
| `enable-bcfobf`            | Enable BogusControlFlow pass.                                                                    | `false`  |
| `bcf_prob`                 | Probability (%) for each basic block to be obfuscated by BogusControlFlow.                       | `70`     |
| `bcf_loop`                 | How many times the BogusControlFlow pass is applied per basic block.                             | `1`      |
| `bcf_cond_compl`           | The complexity of the expression used to generate branching condition.                           | `3`      |
| `bcf_junkasm`              | Add junk assembly to each basic block.                                                           | `false`  |
| `bcf_onlyjunkasm`          | Only add junk assembly to each basic block.                                                      | `false`  |
| `bcf_junkasm_maxnum`       | The maximum number of junk assembly per basic block.                                             | `4`      |
| `bcf_junkasm_minnum`       | The minimum number of junk assembly per basic block.                                             | `2`      |
| `bcf_createfunc`           | Create function for each opaque predicate.                                                       | ``       |
| **BasicBlockSplit**        |                                                                                                  |          |
| `enable-splitobf`          | Enable BasicBlockSplit pass.                                                                     | `false`  |
| `split_num`                | How many times the BasicBlockSplit pass is applied per basic block.                              | `2`      |
| **ConstantEncryption**     |                                                                                                  |          |
| `enable-constenc`          | Enable ConstantEncryption pass.                                                                  | `false`  |
| `constenc_prob`            | Probability (%) that an instruction will be obfuscated by the ConstantEncryption pass.           | `50`     |
| `constenc_times`           | How many times the ConstantEncryption pass is applied per function.                              | `1`      |
| `constenc_subxor`          | Substitute xor operator of ConstantEncryption.                                                   | `false`  |
| `constenc_togv`            | Replace ConstantInt with GlobalVariable.                                                         | `false`  |
| **Flattening**             |                                                                                                  |          |
| `enable-cffobf`            | Enable Flattening pass.                                                                          | `false`  |
| **FunctionCallObfuscate**  |                                                                                                  |          |
| `enable-fco`               | Enable FunctionCallObfuscate pass.                                                               | `false`  |
| `fcoconfig`                | FunctionCallObfuscate configuration path.                                                        | `"+-x/"` |
| `fco_flag`                 | The value of `RTLD_DEFAULT` on your platform.                                                    | `-1`     |
| **FunctionWrapper**        |                                                                                                  |          |
| `enable-funcwra`           | Enable FunctionWrapper pass.                                                                     | `false`  |
| `fw_prob`                  | Probability (%) for each CallSite to be obfuscated by the FunctionWrapper pass.                  | `30`     |
| `fw_times`                 | How many times the FunctionWrapper pass is applied per CallSite.                                 | `2`      |
| **IndirectBranches**       |                                                                                                  |          |
| `enable-indibran`          | Enable IndirectBranches pass.                                                                    | `false`  |
| `indibran-use-stack`       | Enable stack-based indirect jumps.                                                               | `false`  |
| `indibran-enc-jump-target` | Encrypt jump target.                                                                             | `false`  |
| **Substitution**           |                                                                                                  |          |
| `enable-subobf`            | Enable Substitution pass.                                                                        | `false`  |
| `sub_prob`                 | Probability (%) that an instruction will be obfuscated by the Substitution pass.                 | `50`     |
| `sub_loop`                 | How many times the Substitution pass is applied per function.                                    | `1`      |
| **StringEncryption**       |                                                                                                  |          |
| `enable-strcry`            | Enable StringEncryption pass.                                                                    | `false`  |
| `strcry_prob`              | Probability (%) that the StringEncryption pass is applied per element of ConstantDataSequential. | `100`    |
| **Seed**                   |                                                                                                  |          |
| `aesSeed`                  | Seed for the PRNG.                                                                               | `0x1337` |

### Environment variables

| Environment Variable | Description                        |
| -------------------- | ---------------------------------- |
| `ALLOBF`             | Enable all obfuscation passes.     |
| `ACDOBF`             | Enable AntiClassDump pass.         |
| `ADB`                | Enable AntiDebugging pass.         |
| `ANTIHOOK`           | Enable AntiHooking pass.           |
| `BCFOBF`             | Enable BogusControlFlow pass.      |
| `SPLITOBF`           | Enable BasicBlockSplit pass.       |
| `CONSTENC`           | Enable ConstantEncryption pass.    |
| `CFFOBF`             | Enable Flattening pass.            |
| `FCO`                | Enable FunctionCallObfuscate pass. |
| `FUNCWRA`            | Enable FunctionWrapper pass.       |
| `INDIBRAN`           | Enable IndirectBranches pass.      |
| `SUBOBF`             | Enable Substitution pass.          |
| `STRCRY`             | Enable StringEncryption pass.      |

## Building

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

- gcc
- cmake
- ninja
- nodejs
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
npm i
```

## License

See [Hikari/License](https://github.com/HikariObfuscator/Hikari/wiki/License).
