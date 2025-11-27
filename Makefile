# Makefile для сборки UEFI приложения
# Автор: Denis-aka-Wolf

# Определение архитектуры
ARCH ?= x86_64

# Компиляторы
CC = gcc
LD = ld
OBJCOPY = objcopy

# Путь к локальному GNU-EFI (если скомпилирован в ./gnu-efi)
LOCAL_EFI = ./gnu-efi/

# Проверка наличия GNU-EFI
ifeq ($(wildcard $(LOCAL_EFI)),)
$(error GNU-EFI не найден в $(LOCAL_EFI). Пожалуйста, установите его.)
endif

# Путь к библиотекам и заголовкам для выбранной архитектуры
EFI_LIB_DIR = $(LOCAL_EFI)/$(ARCH)/lib
EFI_INC_DIR = $(LOCAL_EFI)/inc
EFI_GNUEFI_DIR = $(LOCAL_EFI)/$(ARCH)/gnuefi
EFI_LDS_FILE = $(LOCAL_EFI)/gnuefi/elf_$(ARCH)_efi.lds
EFI_CRT0_FILE = $(LOCAL_EFI)/$(ARCH)/gnuefi/crt0-efi-$(ARCH).o

# Проверка наличия необходимых файлов
ifeq ($(wildcard $(EFI_LIB_DIR)),)
$(error Библиотеки GNU-EFI для архитектуры $(ARCH) не найдены в $(EFI_LIB_DIR))
endif

ifeq ($(wildcard $(EFI_INC_DIR)),)
$(error Заголовочные файлы GNU-EFI не найдены в $(EFI_INC_DIR))
endif

ifeq ($(wildcard $(EFI_LDS_FILE)),)
$(error Файл линковщика для архитектуры $(ARCH) не найден в $(EFI_LDS_FILE))
endif

ifeq ($(wildcard $(EFI_CRT0_FILE)),)
$(error CRT0 файл для архитектуры $(ARCH) не найден в $(EFI_CRT0_FILE))
endif

# Исходные файлы
SOURCES = main.c
OBJECTS = $(SOURCES:.c=.o)
# Имя выходного файла для загрузчика UEFI
TARGET = BOOTX64.EFI
SO_TARGET = $(TARGET:.efi=.so)

# Флаги компиляции
CFLAGS = -I$(EFI_INC_DIR) \
	-fpic -ffreestanding -fno-stack-protector -fno-stack-check \
	-fshort-wchar -mno-red-zone -maccumulate-outgoing-args


# Флаги линковки
LDFLAGS = -shared -Bsymbolic \
	-L$(EFI_LIB_DIR) -L$(EFI_GNUEFI_DIR) \
	-T $(EFI_LDS_FILE) \
	$(EFI_CRT0_FILE) \
	$(OBJECTS) \
	-lgnuefi -lefi

# Флаги objcopy для создания EFI файла
OBJFLAGS = -j .text -j .sdata -j .rodata -j .dynamic \
	-j .dynsym -j .rela -j .rel.* -j .rela.* -j .reloc \
	--target efi-app-$(ARCH) --subsystem=10

# Цели
.PHONY: all clean install uninstall debug release help

all: $(TARGET)

# Создание каталога build, если он не существует
build:
	mkdir -p build

# Сборка целевого файла EFI
$(TARGET): build $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $^

# Компиляция исходных файлов в объектные файлы
build/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Создание .so файла
%.so: %.o
	$(CC) $(CFLAGS) -shared -o $@ $<

# Создание .efi файла из .so
%.efi: %.so
	$(OBJCOPY) $(OBJFLAGS) $< $@

# Очистка
clean:
	rm -f *.o *.so *.efi $(TARGET)

# Установка
install:
	if [ -z "$(DESTDIR)" ]; then \
		DESTDIR="/"; \
	fi; \
	mkdir -p "$$DESTDIR/EFI/BOOT"; \
	cp $(TARGET) "$$DESTDIR/EFI/BOOT/"

# Удаление
uninstall:
	if [ -z "$(DESTDIR)" ]; then \
		DESTDIR="/"; \
	fi; \
	rm -f "$$DESTDIR/EFI/BOOT/$(TARGET)"

# Debug сборка
debug: CFLAGS += -DDEBUG
debug: all

# Release сборка
release: CFLAGS += -DNDEBUG
release: all

# Помощь
help:
	@echo "Цели:"
	@echo "  all       - Сборка проекта (по умолчанию)"
	@echo "  clean     - Очистка"
	@echo "  install   - Установка"
	@echo "  uninstall - Удаление"
	@echo "  debug     - Debug сборка"
	@echo "  release   - Release сборка"
	@echo "  help      - Показать эту помощь"
	@echo ""
	@echo "Переменные:"
	@echo "  ARCH          - Архитектура (x86_64, ia32 и т.д.)"
	@echo "  DESTDIR       - Корневой каталог для установки"

# Зависимости (генерируются автоматически)
-include $(OBJECTS:.o=.d)

# Генерация зависимостей
%.d: %.c
	$(CC) $(CFLAGS) -MM -MT $@ -MF $@ $<