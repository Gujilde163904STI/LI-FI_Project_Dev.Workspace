@echo off
REM Script to build the Raspberry Pi Manager package for Windows

REM Clean up previous builds
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist rpi_manager.egg-info rmdir /s /q rpi_manager.egg-info

REM Install build dependencies if needed
pip install --upgrade pip setuptools wheel build

REM Build the package
python -m build

echo Package built successfully!
echo To install the package, run:
echo pip install dist\rpi_manager-*.whl