ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

# Stolen from http://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script

# Would be nice to be able to handle BSDs and such...

if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    OS=Debian  # XXX or Ubuntu??
    VER=$(cat /etc/debian_version)
elif [ -f /etc/redhat-release ]; then
    # TODO add code for Red Hat and CentOS here
    OS=RedHat
    VER=Unknown
else
    OS=Unknown
    VER=Unknown
    #OS=$(uname -s)
    #VER=$(uname -r)
fi

# Adding some sanitization
OS=`echo $OS | tr [A-Z] [a-z]`
ARCH=`echo $ARCH | tr [A-Z] [a-z]`
VER=`echo $VER | tr [A-Z] [a-z]`
