SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Get version info
. $SCRIPT_DIR/../../getHostInfo.sh
. $SCRIPT_DIR/../../colors.sh


echo -e "${YELLOW}
############
# libgtest #
############${NC}
"

# Tested against both 32 and 64-bit
if [[ $VER == "15.04" ]]
	then

	echo -e "${YELLOW}Downloading libgtest${NC}"

	cd ~/opt

	curl -OL https://googletest.googlecode.com/files/gtest-1.7.0.zip

	unzip gtest-1.7.0.zip

	cd gtest-1.7.0

	echo -e "${YELLOW}Configuring libgtest${NC}"

	cmake .

	echo -e "${YELLOW}Building libgtest${NC}"

	make -j4

else
	echo "${RED}PROBLEM! Didn't hit if statement!${NC}"
	exit 1
fi

