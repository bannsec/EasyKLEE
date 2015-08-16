SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Get version info
. $SCRIPT_DIR/../../getHostInfo.sh
. $SCRIPT_DIR/../../colors.sh


echo -e "${YELLOW}
#######################
# Ubuntu Dependencies #
#######################${NC}
"

echo -e "${YELLOW}Updating Repo${NC}"

sudo apt-get update

echo -e "${YELLOW}Installing Dependencies${NC}"

if [[ $ARCH == "64" && $VER == "15.04" ]]
	then
	# Ubuntu 15.04 64
	sudo apt-get install -y build-essential curl git bison flex bc libcap-dev git cmake libboost-all-dev libncurses5-dev python-minimal python-pip unzip lib32z1-dev build-essential cmake valgrind libm4ri-dev libmysqlclient-dev libsqlite3-dev libm4ri-dev

elif [[ $ARCH == "32" && $VER == "15.04" ]]
	then
	# Ubuntu 15.04 32
	sudo apt-get install -y build-essential curl git bison flex bc libcap-dev git cmake libboost-all-dev libncurses5-dev python-minimal python-pip unzip build-essential cmake valgrind libm4ri-dev libmysqlclient-dev libsqlite3-dev libm4ri-dev

else
	echo "${RED}PROBLEM! Didn't hit if statement!${NC}"
	exit 1
fi

if [[ $ARCH -eq "64" ]]
	then
	echo -ne "${YELLOW}Updating bashrc ... ${NC}"
	echo "export C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu" >> ~/.bashrc
	echo "export CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu" >> ~/.bashrc
	echo -e "${GREEN}[DONE]${NC}"
fi
