# PeachOS

A bootable multitasking kernel built in no-lib C, featuring memory management, ELF program execution, and a basic command-line interface. Also includes a keyboard driver and FAT16 read support. 

## Prerequisites

Install the following:
- An i686-elf-gcc [cross-compiler](https://wiki.osdev.org/GCC_Cross-Compiler)
- [NASM](https://www.nasm.us/)
- QEMU (qemu-system-i386)

## Build & Run

```bash
export PREFIX="/path/to/cross/compiler"
export TARGET="i686-elf"
export PATH="$PREFIX/bin:$PATH"

make all

qemu-system-x86_64 -hda ./bin/os.bin -display curses
```

## Learning Goals

This project taught me:
- x86 protected mode and memory segmentation
- Page table management and virtual memory
- ELF format and program loading
- Interrupt handling and device drivers
- Low-level systems programming

I plan to add multi-arch functionality with RISC-V support

## License

MIT
