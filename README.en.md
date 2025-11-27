# UEFI Bootloader Project

*Documentation in English*  
[Документация на русском языке](README.md)

This project is a simple UEFI bootloader written in C. It is designed to work in UEFI environment and can be used as a base for creating custom UEFI applications.

## Building the Project

To build the project, run:

```bash
make
```

This command will create the executable file `BOOTX64.EFI`.

## Installation

To install the executable file to a UEFI device, you can use the `install` target in Makefile:

```bash
make install
```

By default, the file will be installed to `/boot/efi/EFI/BOOT/`.

To install the file to another device, use the `DESTDIR` environment variable:

```bash
make install DESTDIR=/path/to/device
```

Examples:
```bash
make install DESTDIR=/mnt/usb
make install DESTDIR=/dev/sda2
make install DESTDIR=/media/user/EFI
```

## Cleaning

To remove generated files, use:

```bash
make clean
```

## Requirements

- GCC (GNU Compiler Collection)
- UEFI SDK (for compilation)
- GNU-EFI (for compilation)
- Make

## GNU-EFI Installation

Before compiling the project, you need to install GNU-EFI. Installation instructions:

```bash
mkdir gnu-efi
git clone https://git.code.sf.net/p/gnu-efi/code gnu-efi
cd ./gnu-efi/
make
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.