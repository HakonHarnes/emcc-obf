FROM archlinux:base-devel-20230312.0.133040

# Install dependencies
RUN pacman -Syyu vim git nodejs gcc cmake ninja python3 npm --noconfirm

# Clone repositories
RUN mkdir -p src build/hikari build/binaryen
RUN git clone --recursive -b llvm-16.0.0rel https://github.com/61bcdefg/Hikari-LLVM15.git /src/hikari
RUN git clone https://github.com/emscripten-core/emscripten.git /src/emscripten 
RUN git clone https://github.com/WebAssembly/binaryen.git /src/binaryen 

# Update Hikari submodules
WORKDIR /src/hikari  
RUN git submodule update --remote --recursive 

# Build Hikari 
WORKDIR /build/hikari  
RUN cmake -G "Ninja" -DCMAKE_BUILD_TYPE=MinSizeRel -DLLVM_APPEND_VC_REV=on -DLLVM_ENABLE_PROJECTS='lld;clang' -DLLVM_TARGETS_TO_BUILD="host;WebAssembly" -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DENABLE_LLVM_SHARED=1 /src/hikari/llvm
RUN ninja
RUN ninja install

# Update Binaryen submodules
WORKDIR /src/binaryen 
RUN git checkout ecbebfbee12f2f25af648119604915fc37427f6f
RUN git submodule init
RUN git submodule update

# Build Binaryen
WORKDIR /build/binaryen 
RUN cmake -G "Ninja" /src/binaryen
RUN ninja 
RUN ninja install 

# Configure Emscripten 
WORKDIR /src/emscripten 
RUN git checkout fab93a2bff6273c882b0c7fb7b54eccc37276e03
ENV PATH="$PATH:/src/emscripten"
RUN emcc --generate-config
RUN npm i

WORKDIR /
