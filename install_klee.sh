# KLEE Install Script
# Made for Ubuntu 15.04 x64
# Installing KLEE 3.4 with LLVM 3.4 (both experimental)

echo "
	KLEE 3.4 (Experimental)
	LLVM 3.4 (Experimental)
	CryptoMiniSAT 4.5.2
	MiniSAT (latest... they're bad at tagging)
	KLEE-UCLIBC (lastest, also bad at taging)
	libgtest 1.7
"
# Get info about host (sets OS, ARCH, and VER)
. getHostInfo.sh

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

contains() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

# List of what's been tested
TESTED=("ubuntu_15.04_64")

if ! contains $TESTED "${OS}_${VER}_${ARCH}"
  then
    echo -e "${RED}Your OS Version ($OS $VER $ARCH) is untested!"
    echo -e " Press Enter to continue anyway ${NC}"
    read 
else
  echo -e "${GREEN}Your OS Version ($OS $VER $ARCH) has been tested${NC}"
fi

pushd . >/dev/null

mkdir ~/opt

echo "
################
# Ubuntu Stuff #
################
"

echo "Installing Dependencies"
# Ubuntu deps
sudo apt-get install -y build-essential curl git bison flex bc libcap-dev git cmake libboost-all-dev libncurses5-dev python-minimal python-pip unzip lib32z1-dev build-essential cmake valgrind libm4ri-dev libmysqlclient-dev libsqlite3-dev libm4ri-dev

echo -n "Updating bashrc ... "
# Path stuff
echo "export C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu" >> ~/.bashrc
echo "export CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu" >> ~/.bashrc
echo "[DONE]"

echo "
########
# LLVM #
########
"

echo -n "Adding LLVM Repo ... "
# Add LLVM repo
sudo echo "deb http://llvm.org/apt/vivid/ llvm-toolchain-vivid main" >> /etc/apt/sources.list
sudo echo "deb-src http://llvm.org/apt/vivid/ llvm-toolchain-vivid main" >> /etc/apt/sources.list

# Get the LLVM repo key
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
echo "[DONE]"

echo -n "Installing LLVM Packages ... "
# Install packages
sudo apt-get update  
sudo apt-get install -y clang-3.4 llvm-3.4 llvm-3.4-dev llvm-3.4-tools  
echo "[DONE]"

echo -n "Linking llvm-config ... "
# Link config
sudo ln -sf /usr/bin/llvm-config-3.4 /usr/bin/llvm-config
echo "[DONE]"

echo "
###############
# STP/MiniSAT #
###############
"

echo "Cloning MiniSat"

cd ~/opt

git clone https://github.com/stp/minisat.git

echo "Configuring MiniSat"

cd minisat
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/ ../

echo "Building MiniSat"

sudo make install

cd ~/opt

echo "Cloning CryptoMiniSAT"

git clone https://github.com/msoos/cryptominisat.git

cd cryptominisat

# Check out tag
git tag 4.5.2

mkdir build
cd build

echo "Configuring CryptoMiniSAT"

# Need to include pthread to work correctly with STP
cmake -DCMAKE_CXX_FLAGS:STRING="-pthread" -DCMAKE_C_FLAGS:STRING="-pthread" ..

echo "Building CryptoMiniSAT"

make -j4

sudo make install

# Link the library
sudo ln -s /usr/local/lib/libcryptominisat4.so /usr/local/lib/cryptominisat4.so

sudo ldconfig

echo "Cloning STP"

cd ~/opt

git clone https://github.com/stp/stp.git

echo "Checking out STP 2.1.0"

git checkout tags/2.1.0

mkdir stp/build

cd stp/build

echo "Configuring STP"

cmake -DBUILD_SHARED_LIBS:BOOL=OFF -DENABLE_PYTHON_INTERFACE:BOOL=OFF -DCMAKE_CXX_FLAGS:STRING="-pthread" -DCMAKE_C_FLAGS:STRING="-pthread" ..

echo "Building STP"

make -j4

echo "Installing STP"

sudo make install

echo "Setting ulimits"

ulimit -s unlimited

echo "ulimit -s unlimited" >> ~/.bashrc

echo "
###############
# KLEE-UCLIBC #
###############
"

echo "Cloning klee-uclibc"

cd ~/opt

git clone https://github.com/klee/klee-uclibc.git  

cd klee-uclibc  

echo "Configuring klee-uclibc"

# TODO: Auto-determine correct build target here...
# This should work normally for i386 and x64
./configure --make-llvm-lib  

echo "Building klee-uclibc"

make -j4 

echo "
############
# libgtest #
############
"

echo "Downloading libgtest"

cd ~/opt

curl -OL https://googletest.googlecode.com/files/gtest-1.7.0.zip

unzip gtest-1.7.0.zip

cd gtest-1.7.0  

echo "Configuring libgtest"

cmake .

echo "Building libgtest"

make -j4

echo "
########
# KLEE #
########
"

echo "Downloading KLEE"

cd ~/opt

git clone https://github.com/klee/klee.git

cd klee

echo "Configuring KLEE"

varSTP=`echo ~/opt/stp`
varKLEEULIBC=`echo ~/opt/klee-uclibc`
LIBS="-lcryptominisat4" ./configure --with-stp=$varSTP --with-uclibc=$varKLEEULIBC --enable-posix-runtime

# Fix-up the Makefile
# This is a hack to get cryptominisat to compile in.. Not sure what else to do unless you build it into the config itself
sed 's/-lstp/-lstp -lcryptominisat4/' Makefile.config > Makefile2.config
mv Makefile2.config Makefile.config

echo "Fixing build script"

sed -i.bak -re 's/^(BCCompile.C.*)\$\(CFLAGS\)(.*)$/\1\$\(filter-out -fstack-protector-strong,\$\(CFLAGS\)\)\2/' Makefile.rules

echo "Building KLEE"

make -j4

echo "Testing KLEE"

make test

# Installing KLEE
sudo make install

popd >/dev/null
