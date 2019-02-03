#!/usr/bin/env bash
set -x

VBOX_ISO=/home/vagrant/VBoxGuestAdditions.iso
VBOX_MNTDIR=$(mktemp --tmpdir=/tmp -q -d -t vbox_mnt_XXXXXX)

# Download tools
if [ ! -f $VBOX_ISO ]; then
  VBOX_VERSION=$(curl https://download.virtualbox.org/virtualbox/LATEST.TXT)
  VBOX_URL=https://download.virtualbox.org/virtualbox/${VBOX_VERSION}/VBoxGuestAdditions_${VBOX_VERSION}.iso
  curl $VBOX_URL -o $VBOX_ISO
fi

# Install tools
mount -o loop $VBOX_ISO $VBOX_MNTDIR
yes|sh $VBOX_MNTDIR/VBoxLinuxAdditions.run

# Clean up
umount $VBOX_MNTDIR
rm -rf $VBOX_MNTDIR
rm -f $VBOX_ISO
