#!/bin/bash
# KLEE Install Script
# Made for Ubuntu 15.04
# Installing KLEE 3.4 with LLVM 3.4 (both experimental)

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

. $SCRIPT_DIR/colors.sh

echo -e "
${YELLOW}This package will install the following:

	KLEE 3.4 (Experimental)
	LLVM 3.4 (Experimental)
	CryptoMiniSAT 4.5.2
	MiniSAT (latest... they're bad at tagging)
	KLEE-UCLIBC (lastest, also bad at taging)
	libgtest 1.7${NC}
"

# Get info about host (sets OS, ARCH, and VER)
. $SCRIPT_DIR/getHostInfo.sh

array_contains () { 
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
}

# List of what's been tested
TESTED=(ubuntu_15.04_64 ubuntu_15.04_32)

if ! array_contains TESTED "${OS}_${VER}_${ARCH}"
  then
    echo -e "${RED}Your OS Version ($OS $VER $ARCH) is untested!"
    echo -e "Press Enter to continue anyway ${NC}"
    read 
else
  echo -e "${GREEN}Your OS Version ($OS $VER $ARCH) has been tested"
  echo -e "Press Enter to continue${NC}"
  read
fi

pushd . >/dev/null

mkdir ~/opt 2>/dev/null

$SCRIPT_DIR/klee/$OS/dependencies.sh

$SCRIPT_DIR/klee/$OS/llvm.sh

$SCRIPT_DIR/klee/$OS/stp.sh

$SCRIPT_DIR/klee/$OS/klee-ulibc.sh

$SCRIPT_DIR/klee/$OS/libgtest.sh

$SCRIPT_DIR/klee/$OS/klee.sh

popd >/dev/null
