# Makefile для сборки UEFI приложения

CC = gcc
CFLAGS = -Wall -Wextra -O2 -fPIC -ffreestanding -fno-stack-protector -fno-builtin -std=c11
LDFLAGS = -nostdlib -static -shared -Wl,-e,_start -Wl,-Ttext=0x10000

# Путь к UEFI SDK (если установлен)
EFI_INC = /usr/include/efi
EFI_LIB = /usr/lib/efi

# Имя выходного файла для загрузчика UEFI
TARGET = BOOTX64.EFI

# Исходные файлы
SOURCES = main.c
OBJECTS = $(SOURCES:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -I$(EFI_INC) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

install: $(TARGET)
	cp $(TARGET) /boot/efi/EFI/BOOT/

.PHONY: all clean install