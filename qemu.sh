#!/bin/sh

UEFI_BIOS="/usr/share/edk2-ovmf/x64/OVMF_CODE.fd"
UEFI_BIN="zig-cache/bin/uefi.efi"

QEMU=qemu-system-x86_64
QEMU_OPTS="-enable-kvm -m 128 -bios $UEFI_BIOS"

TFTP=tftp=`dirname $UEFI_BIN`,bootfile=`basename $UEFI_BIN`
QEMU_NET="-device e1000,netdev=n0 -netdev user,id=n0,$TFTP"

if [ ! -f $UEFI_BIOS ]; then
    echo "Not found \"$UEFI_BIOS\""
    exit
fi
if [ ! -f ${UEFI_BIN} ]; then
    echo "Not found \"$UEFI_BIN\""
    exit
fi

${QEMU} ${QEMU_OPTS} ${QEMU_NET}
