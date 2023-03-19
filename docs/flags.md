# Flags

### All obfuscation passes

| **Flag**         | **Description**                |
| ---------------- | ------------------------------ |
| `-enable-allobf` | Enable all obfuscation passes. |

### Bogus Control Flow

| **Flag**              | **Description**                                                                                  |
| --------------------- | ------------------------------------------------------------------------------------------------ |
| `-enable-bcfobf`      | Enable Bogus Control Flow.                                                                       |
| `-bcf_cond_compl`     | The complexity used as the branching condition.                                                  |
| `-bcf_prob`           | The probability [%] each basic blocks will be obfuscated by the `-bcf` pass.                     |
| `-bcf_loop`           | How many times the `-bcf` pass loop on a function.                                               |
| `-bcf_onlyjunkasm`    | Insert only fancy (?) instructions in dummy blocks.                                              |
| `-bcf_junkasm`        | Insert flowery (?) instructions in fake blocks to interfere with IDA's recognition of functions. |
| `-bcf_junkasm_memory` | The minimum number of instructions to spend in a fake block.                                     |
| `-bcf_junkasm_maxnum` | The maximum number of instructions to spend in a fake block.                                     |
| `-bcf_createfunc`     | Use a function to wrap an opaque predicate.                                                      |

### Control Flow Flattening

| **Flag**         | **Description**                 |
| ---------------- | ------------------------------- |
| `-enable-cffobf` | Enable Control Flow Flattening. |

### Basic Block Splitting

| **Flag**           | **Description**              |
| ------------------ | ---------------------------- |
| `-enable-splitobf` | Enable Basic Block Spliting. |

### String Encryption

| **Flag**         | **Description**                                                 |
| ---------------- | --------------------------------------------------------------- |
| `-enable-strcry` | Enable String Encryption.                                       |
| `-strcry_prob`   | The probability [%] that each byte in each string is encrypted. |

### Constant Encryption

| **Flag**           | **Description**                                                                                                                                                                           |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `-enable-constenc` | Enable Constant Encryption.                                                                                                                                                               |
| `-constenc_times`  | The number of times ConstantEncryption is obfuscated in each function.                                                                                                                    |
| `-constenc_prob`   | The probability that each instruction is obfuscated by ConstantEncryption.                                                                                                                |
| `-constenc_togv`   | Replace the constant number (ConstantInt) with a global variable, and replace the operation result of a binary operator (BinaryOperator) whose type is an integer with a global variable. |
| `-constenc_subxor` | Replace the XOR operation of ConstantEncryption to make it more complicated.                                                                                                              |

### Instruction Substitution

| **Flag**         | **Description**                  |
| ---------------- | -------------------------------- |
| `-enable-subobf` | Enable Instruction Substitution. |

### Register-Based Indirect Branching

| **Flag**                    | **Description**                                                                                                         |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `-enable-indibran`          | Enable Register-Based Indirect Branching.                                                                               |
| `-indibran-use-stack`       | The address of the jump table is loaded into the stack in the Entry Block, and each basic block is read from the stack. |
| `-indibran-enc-jump-target` | Encrypted jump tables and indexes.                                                                                      |

### Function Wrapper

| **Flag**          | **Description**                                                            |
| ----------------- | -------------------------------------------------------------------------- |
| `-enable-funcwra` | Enable Function Wrapper.                                                   |
| `-fw_prob`        | The probability [%] For Each CallSite To Be Obfuscated By FunctionWrapper. |
| `-fw_times`       | Choose how many time the FunctionWrapper pass loop on a CallSite.          |

### Function Call Obfuscation

| **Flag**          | **Description**                                                                                                                                      |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `-enable-fco`     | Enable FunctionCallObfuscate.                                                                                                                        |
| `-fcoconfig=PATH` | Override the path used to load `SymbolConfig.json`.                                                                                                  |
| `-fco_flag=VALUE` | Override the value of `RTLD_GLOBAL\|RTLD_NOW` on your platform. If you are targeting Darwin/Android then the correct value is automatically applied. |

### AntiClassDump

| **Flag**                | **Description**                                                            |
| ----------------------- | -------------------------------------------------------------------------- |
| `-enable-acdobf`        | Enable AntiClassDump Mechanisms.                                           |
| `-acd-use-initialize`   | See Hikari Wiki.                                                           |
| `-acd-rename-methodimp` | Rename the method function name displayed in IDA, not the method name (?). |

### AntiHooking

| **Flag**           | **Description**                                            |
| ------------------ | ---------------------------------------------------------- |
| `-enable-antihook` | Enable AntiHooking.                                        |
| `-ah_inline`       | Check if the current function is inline hooked.            |
| `-ah_objruntime`   | Check if the current function is hooked by runtime.        |
| `-ah_antirebind`   | Make generated files unable to rebind symbols by fishhook. |

### AntiDebugging

| **Flag**        | **Description**                                                      |
| --------------- | -------------------------------------------------------------------- |
| `-enable-adb`   | Enable AntiDebugging.                                                |
| `-adb_prob`     | The probability that anti-debugging will be added for each function. |
| `-adbextirpath` | Path to AntiDebugging PreCompiled IR files.                          |
