SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Get version info
. $SCRIPT_DIR/../../getHostInfo.sh
. $SCRIPT_DIR/../../colors.sh


echo -e "${YELLOW}
########
# KLEE #
########${NC}
"

# Tested against 32 and 64-bit
if [[ $VER == "15.04" ]]
	then

	echo -e "${YELLOW}Downloading KLEE${NC}"

	cd ~/opt

	git clone https://github.com/klee/klee.git

	cd klee

	echo -e "${YELLOW}Configuring KLEE${NC}"

	varSTP=`echo ~/opt/stp`
	varKLEEULIBC=`echo ~/opt/klee-uclibc`
	LIBS="-lcryptominisat4" ./configure --with-stp=$varSTP --with-uclibc=$varKLEEULIBC --enable-posix-runtime

	# Fix-up the Makefile
	# This is a hack to get cryptominisat to compile in.. Not sure what else to do unless you build it into the config itself
	sed 's/-lstp/-lstp -lcryptominisat4/' Makefile.config > Makefile2.config
	mv Makefile2.config Makefile.config

	echo -e "${YELLOW}Fixing build script${NC}"

	sed -i.bak -re 's/^(BCCompile.C.*)\$\(CFLAGS\)(.*)$/\1\$\(filter-out -fstack-protector-strong,\$\(CFLAGS\)\)\2/' Makefile.rules

	echo -e "${YELLOW}Building KLEE${NC}"

	make -j4

	echo -e "${YELLOW}Testing KLEE${NC}"

	make test

	# Installing KLEE
	sudo make install


else
	echo "${RED}PROBLEM! Didn't hit if statement!${NC}"
	exit 1
fi

