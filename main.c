#include <efi.h>
#include <efilib.h>
#include "uefi_config.h"

EFI_STATUS 
EFIAPI

efi_main(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable)
{
    EFI_STATUS Status;
    
    // Инициализация UEFI библиотеки
    InitializeLib(ImageHandle, SystemTable);
    
    // Очистка экрана
    SystemTable->ConOut->ClearScreen(SystemTable->ConOut);
    
    // Установка цвета текста
    SystemTable->ConOut->SetAttribute(SystemTable->ConOut, TEXT_COLOR | BACKGROUND_COLOR);
    
    // Вывод приветственного сообщения
    Print(L"%s v%s\n", APP_NAME, APP_VERSION);
    Print(L"================================\n");
    Print(L"Привет из UEFI приложения!\n");
    Print(L"Это простое приложение, запущенное до загрузки ОС.\n");
    Print(L"Создано для демонстрации возможностей UEFI.\n");
    Print(L"================================\n");
    
    // Вывод приглашения для продолжения
    Print(L"\nНажмите любую клавишу для продолжения...\n");
    
    // Ожидание нажатия клавиши
    EFI_INPUT_KEY Key;
    SystemTable->ConIn->ReadKeyStroke(SystemTable->ConIn, &Key);
    
    // Завершение работы
    return EFI_SUCCESS;
}