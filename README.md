# UEFI Bootloader Project

*Документация на русском языке*  
[Documentation in English](README.en.md)

Этот проект представляет собой простой загрузчик UEFI, написанный на C. Он предназначен для работы в среде UEFI и может быть использован как база для создания собственных UEFI-приложений.

## Сборка проекта

Для сборки проекта необходимо выполнить команду:

```bash
make
```

Эта команда создаст исполняемый файл `BOOTX64.EFI`.

## Установка

Для установки исполняемого файла на UEFI-носитель можно использовать цель `install` в Makefile:

```bash
make install
```

По умолчанию файл будет установлен в `/boot/efi/EFI/BOOT/`.

Чтобы установить файл на другой носитель, используйте переменную окружения `DESTDIR`:

```bash
make install DESTDIR=/путь/к/носителю
```

Примеры:
```bash
make install DESTDIR=/mnt/usb
make install DESTDIR=/dev/sda2
make install DESTDIR=/media/user/EFI
```

## Очистка

Для удаления сгенерированных файлов можно использовать команду:

```bash
make clean
```

## Требования

- GCC (GNU Compiler Collection)
- UEFI SDK (для компиляции)
- GNU-EFI (для компиляции)
- Make

## Установка GNU-EFI

Перед компиляцией проекта необходимо установить пакет GNU-EFI. Инструкции по установке:

```bash
mkdir gnu-efi
git clone https://git.code.sf.net/p/gnu-efi/code gnu-efi
cd ./gnu-efi/
make
```

## Лицензия

Этот проект лицензирован под MIT License - см. файл [LICENSE](LICENSE) для получения подробной информации.