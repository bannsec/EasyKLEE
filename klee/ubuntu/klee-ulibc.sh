SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Get version info
. $SCRIPT_DIR/../../getHostInfo.sh
. $SCRIPT_DIR/../../colors.sh


echo -e "${YELLOW}
###############
# KLEE-UCLIBC #
###############${NC}
"

# Tested against both 32-bit and 64-bit
if [[ $VER == "15.04" ]]
	then

	echo -e "${YELLOW}Cloning klee-uclibc${NC}"

	cd ~/opt

	git clone https://github.com/klee/klee-uclibc.git

	cd klee-uclibc

	echo -e "${YELLOW}Configuring klee-uclibc${NC}"

	# TODO: Auto-determine correct build target here...
	# This should work normally for i386 and x64
	./configure --make-llvm-lib

	echo -e "${YELLOW}Building klee-uclibc${NC}"

	make -j4

else
	echo "${RED}PROBLEM! Didn't hit if statement!${NC}"
	exit 1
fi

