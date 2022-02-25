#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL Suptv
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Suptv/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
PACKAGE='enigma2-plugin-extensions-suptv'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Suptv'
PYTHON_VERSION=$(python -c"import sys; print(sys.version_info.major)")

####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ]; then
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
elif [ -f /etc/apt/apt.conf ]; then
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    DPKINSTALL='dpkg -i --force-overwrite'
fi

if [ "$PYTHON_VERSION" -eq 3 ]; then
    echo ":You have Python3 image ..."
    VERSION='3.1'
else
    echo ":You have Python2 image ..."
    if [ $OSTYPE = "Opensource" ]; then
        VERSION='2.1'
    elif [ $OSTYPE = "DreamOS" ]; then
        VERSION='3.8'
    fi
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* >/dev/null 2>&1

if [ "$($OPKGLIST $PACKAGE | awk '{ print $3 }')" = $VERSION ]; then
    echo " You are use the laste Version: $VERSION"
    exit 1
elif [ -z "$($OPKGLIST $PACKAGE | awk '{ print $3 }')" ]; then
    echo
    clear
else
    $OPKGREMOV $PACKAGE
fi
$OPKG >/dev/null 2>&1
###################
#  Install Plugin #

if [ $OSTYPE = "Opensource" ]; then
    echo "Insallling Suptv plugin Please Wait ......"
    if [ "$PYTHON_VERSION" -eq 3 ]; then
        wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
    else
        wget $MY_URL/${PACKAGE}_${VERSION}_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${PACKAGE}_${VERSION}_all.ipk
    fi
elif [ $OSTYPE = "DreamOS" ]; then
    wget $MY_URL/${PACKAGE}_${VERSION}_all.deb -qP $TMPDIR
    $DPKINSTALL $TMPDIR/${PACKAGE}_${VERSION}.deb
    $OPKGINSTAL -f -y

fi
##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* >/dev/null 2>&1

sleep 2
clear
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       Suptv      : $VERSION                             *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : Suptv                           *"
echo "**  Support    : https://script-enigma2.club/suptv/                   *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

exit 0
