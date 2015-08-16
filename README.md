The purpose of this package is to install KLEE from nothing.

How to use:

Just run "install_klee.sh". It should take care of the rest.

Platforms:
 - Ubuntu 15.04 x64

I'm planning on adding more, but that's the only one I've tested so far.

What it installs:
        KLEE 3.4 (Experimental)
        LLVM 3.4 (Experimental)
        CryptoMiniSAT 4.5.2
        MiniSAT (latest... they're bad at tagging)
        KLEE-UCLIBC (lastest, also bad at taging)
        libgtest 1.7

Known Issues:
If a different version of LLVM is already installed, there will likely be issues installing KLEE.
