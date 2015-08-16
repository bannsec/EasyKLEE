SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Get version info
. $SCRIPT_DIR/../../getHostInfo.sh
. $SCRIPT_DIR/../../colors.sh


echo -e "${YELLOW}
########
# LLVM #
########${NC}
"

echo -e "${YELLOW}Adding LLVM Repo ...${NC}"

if [[ $VER == "15.04" ]]
	then
	# Add repo
	sudo echo "deb http://llvm.org/apt/vivid/ llvm-toolchain-vivid main" >> /etc/apt/sources.list
	sudo echo "deb-src http://llvm.org/apt/vivid/ llvm-toolchain-vivid main" >> /etc/apt/sources.list

else
	echo "${RED}PROBLEM! Didn't hit if statement!${NC}"
	exit 1
fi

# Get the LLVM repo key
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -

echo -e "${YELLOW}Installing LLVM Packages ... ${NC}"

# Install packages
sudo apt-get update
sudo apt-get install -y clang-3.4 llvm-3.4 llvm-3.4-dev llvm-3.4-tools

echo -ne "${YELLOW}Linking llvm-config ... ${NC}"
# Link config
sudo ln -sf /usr/bin/llvm-config-3.4 /usr/bin/llvm-config
echo -e "${GREEN}[DONE]${NC}"


