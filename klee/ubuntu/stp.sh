SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Get version info
. $SCRIPT_DIR/../../getHostInfo.sh
. $SCRIPT_DIR/../../colors.sh


echo -e "${YELLOW}
###############
# STP/MiniSAT #
###############${NC}
"

if [[ $VER == "15.04" && $ARCH == "64" ]]
	then

	echo -e "${YELLOW}Cloning MiniSat${NC}"
	cd ~/opt
	git clone https://github.com/stp/minisat.git

	echo -e "${YELLOW}Configuring MiniSat${NC}"
	cd minisat
	mkdir build
	cd build
	cmake -DCMAKE_INSTALL_PREFIX=/usr/ ../

	echo -e "${YELLOW}Building MiniSat${NC}"

	sudo make install

	cd ~/opt

	echo -e "${YELLOW}Cloning CryptoMiniSAT${NC}"

	git clone https://github.com/msoos/cryptominisat.git

	cd cryptominisat

	# Check out tag
	git tag 4.5.2

	mkdir build
	cd build

	echo -e "${YELLOW}Configuring CryptoMiniSAT${NC}"

	# Need to include pthread to work correctly with STP
	cmake -DCMAKE_CXX_FLAGS:STRING="-pthread" -DCMAKE_C_FLAGS:STRING="-pthread" ..

	echo -e "${YELLOW}Building CryptoMiniSAT${NC}"

	make -j4

	sudo make install

	# Link the library
	sudo ln -s /usr/local/lib/libcryptominisat4.so /usr/local/lib/cryptominisat4.so

	sudo ldconfig

	echo -e "${YELLOW}Cloning STP${NC}"

	cd ~/opt

	git clone https://github.com/stp/stp.git

	echo -e "${YELLOW}Checking out STP 2.1.0${NC}"

	git checkout tags/2.1.0

	mkdir stp/build

	cd stp/build

	echo -e "${YELLOW}Configuring STP${NC}"

	cmake -DBUILD_SHARED_LIBS:BOOL=OFF -DENABLE_PYTHON_INTERFACE:BOOL=OFF -DCMAKE_CXX_FLAGS:STRING="-pthread" -DCMAKE_C_FLAGS:STRING="-pthread" ..

	echo -e "${YELLOW}Building STP${NC}"

	make -j4

	echo -e "${YELLOW}Installing STP${NC}"

	sudo make install

	echo -e "${YELLOW}Setting ulimits${NC}"

	ulimit -s unlimited

	echo "ulimit -s unlimited" >> ~/.bashrc

else
	echo "${RED}PROBLEM! Didn't hit if statement!${NC}"
	exit 1
fi

