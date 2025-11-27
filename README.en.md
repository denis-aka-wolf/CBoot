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

## Makefile Targets

The project contains the following targets in Makefile:

- `all` - Build the project (default)
- `clean` - Clean generated files
- `install` - Install the executable file
- `uninstall` - Uninstall the executable file
- `debug` - Debug build with `-DDEBUG` option
- `release` - Release build with `-DNDEBUG` option
- `help` - Display help on targets and variables

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

## Makefile Variables

The project supports the following environment variables:

- `ARCH` - Architecture (x86_64, ia32, etc.). Default: x86_64
- `TOOLCHAIN_PREFIX` - Toolchain prefix (default: x86_64-linux-gnu-)
- `DESTDIR` - Root directory for installation (default: /)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.