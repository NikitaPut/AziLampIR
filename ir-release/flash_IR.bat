@echo off
title AziLamp - IR firmware (no Wi-Fi)
echo ============================================
echo   AziLamp - IR remote firmware, Wi-Fi off
echo ============================================
echo.

if "%~1"=="" (
    echo Usage: flash_IR.bat COM3
    echo.
    echo Available ports:
    mode | findstr "COM"
    pause
    exit /b 1
)

set PORT=%~1
set BIN=%~dp0AziLamp_IR.bin

python --version >nul 2>&1
if errorlevel 1 (
    echo Python is not installed: https://www.python.org/downloads/
    echo Tick "Add Python to PATH" during install.
    pause
    exit /b 1
)

python -m esptool version >nul 2>&1
if errorlevel 1 (
    echo esptool not found, installing...
    pip install esptool
)

if not exist "%BIN%" (
    echo Firmware file not found: %BIN%
    pause
    exit /b 1
)

echo Port: %PORT%
echo Flashing...
python -m esptool --port %PORT% --baud 115200 --chip esp8266 write_flash --flash_mode qio --flash_freq 40m --flash_size detect 0x00000 "%BIN%"
if errorlevel 1 (
    echo.
    echo Flashing FAILED. Try manual BOOT: hold FLASH, press RST, release FLASH, run again.
    pause
    exit /b 1
)

echo.
echo Done. Unplug the lamp and plug it back in.
pause
