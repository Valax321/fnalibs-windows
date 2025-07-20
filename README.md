# fnalibs-windows

A powershell script for creating a Windows-x64 build of FNA's native libraries, packaging up the DLLs and LIBs for use in NativeAOT projects.

## Motivation

FNA already has the [fnalibs-dailies](https://github.com/Valax321/fnalibs-dailies) repository, which is useful for getting started with FNA. It does not however ship the libraries' .lib files which are required when using DirectPInvoke with NativeAOT. The FNA docs recommend building these libraries yourself when shipping with NativeAOT, and this repository offers a quick way to do so.

## Requirements
* Visual Studio 2022
* GitHub CLI
* CMake (version included in Visual Studio works fine)

## Usage
Run `./build.ps1` and the DLLs and libs should be copied to the `artifacts` folder. Alternatively just download the latest GitHub actions build artifacts.
