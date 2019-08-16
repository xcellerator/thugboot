# ThugBoot
Generate the [ThugCrowd](https://thugcrowd.com) logo in x86 BIOS assembly.

`XOR Branch`: Stored the output text as XORed bytes within the assembly. This way, if you run `strings` on the build, you won't see what gets output (though it's not hard to work it out...).

## About
Not the prettiest x86 asm, but it works. Pieced together the asm from various places online. I plan to use this to learn more about BIOS assembly, but figure it's a decent starting point for someone else too.

![alt text](./thugboot.png "ThugBoot")

## Requirements
* Nasm (to build)
* QEMU (to run)

## Building
Run `./build.sh` to generate `bin/thugboot.bin`.

## Running
```
$ qemu-system-x86_64 -fda bin/thugboot.bin
```
