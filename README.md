# libvips-vs2017

Visual Studio 2017 solution and projects for building [libvips](https://github.com/jcupitt/libvips)

## Getting Started

This repository contains the VS2017 projects and will download libvips official repository as a submodule, please use recurse submodules when cloning.

### Prerequisites

Visual Studio 2017 Community has been used for compiling.
[vcpkg](https://github.com/Microsoft/vcpkg) is being used for dependency management.
Please follow the instructions on vcpkg's repository in order to install needed libraries.

### Building libvips

In order to build correctly one should especify the correct path of the vcpkg installed directory, and also the output paths.
For doing so we should modify the **libvipsPropertySheet.props** file as follows:

* **vcpkgInstalledPath** macro contains the relative path to the vcpkg installed directory, please modify to point to your installation.
* **LibrariesOutputPath** macro contains the path where link libraries (.lib files) will be installed.
* **DLLOutputPath** macro contains the path where dynamic libraries (.dll files) will be installed.
* **HeadersOutputPath** macro contains the path where header files (.h files) will be installed.

## License

This project is licensed as-is. 
Use it at your own risk, and if you have suggestions or fixes, please comment and/or contribute :)

## Thanks
* @jcupitt and @lovell for their work and help in libvips
