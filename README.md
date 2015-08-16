#Overview
The purpose of EasyKLEE is to making installing KLEE easy. The goal is to be able to simply run the installer on a base install of an operating system and have KLEE be installed. The genesis of this project was from personal experiences with the sometimes difficult installation of this tool.

#Usage
Just run "install_klee.sh". It should take care of the rest.

#Supportted Platforms
The following platforms are supported/tested, but other similar versions would likely work with minimal to no modification.

* Ubuntu 15.04 x64/i386

# What It Installs
Besides simply installing KLEE, it needs to install dependencies. Here's what you get.

* KLEE 3.4 (Experimental)
* LLVM 3.4 (Experimental)
* CryptoMiniSAT 4.5.2
* MiniSAT (latest... they're bad at tagging)
* KLEE-UCLIBC (lastest, also bad at taging)
* libgtest 1.7

#Known Issues
If a different version of LLVM is already installed, there will likely be issues installing KLEE.
