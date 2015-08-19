#!/bin/bash

# build: Bootstrap a base Arch Linux system.

set -e -u -o pipefail

SCRIPT=$(readlink -f "$0")
SCRIPT_PWD=$(dirname $SCRIPT)

RESULTPATH=${SCRIPT_PWD}/../
ARCH="x86_64"
REPO_URL="http://mirrors.163.com/archlinux/"
DOWNLOAD_DIR="/tmp/bootstrap-packages"

ROOTFS=$(mktemp -d)
/usr/bin/mkdir -p "$ROOTFS"
# remove old archives
/usr/bin/rm -f ${RESULTPATH}/arch-mini-bootstrap.tar.xz ${RESULTPATH}/arch-mini-bootstrap.tar.xz.sha512sum

# bootstrap
${SCRIPT_PWD}/arch-bootstrap.sh -a "${ARCH}" -r "${REPO_URL}" -d "${DOWNLOAD_DIR}" "${ROOTFS}"
cd "${ROOTFS}"
# clean up resolv.conf 
/usr/bin/cp ${SCRIPT_PWD}/resolv.conf etc/resolv.conf
# use default mirrorlist for pacman
/usr/bin/cp ${SCRIPT_PWD}/mirrorlist etc/pacman.d/mirrorlist
# clean up package cache
/usr/bin/rm -rf var/cache/*

# create new archive
cd ${RESULTPATH}
/usr/bin/tar --create --xz --numeric-owner --xattrs --acls --directory=${ROOTFS} --file="arch-mini-bootstrap.tar.xz" .
/usr/bin/sha512sum "arch-mini-bootstrap.tar.xz" >| "arch-mini-bootstrap.tar.xz.sha512sum"

# report result
echo "DOWNLOAD_DIR: $DOWNLOAD_DIR"
echo "ROOTFS: $ROOTFS"
echo "RESULTPATH: $RESULTPATH"
