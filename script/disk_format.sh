#!/bin/bash
MOUNT_BASE_DIR="/mnt"
DISKS=$(lsblk -o NAME,MOUNTPOINT -n | grep -v '^loop' | awk '{if ($2 == "") print $1}')

for DISK in $DISKS; do
    if [[ ! $DISK =~ ^[a-z]+[0-9]+$ ]]; then
        echo -e "n\np\n1\n\n\nw" | fdisk "/dev/${DISK}"
        PARTITION="/dev/${DISK}1"
        mkfs.ext4 "$PARTITION"

        MOUNT_POINT="${MOUNT_BASE_DIR}/${DISK}1"
        if [ ! -d "$MOUNT_POINT" ]; then
            mkdir -p "$MOUNT_POINT"
        fi

        mount "$PARTITION" "$MOUNT_POINT"

        FSTAB_ENTRY="${PARTITION} ${MOUNT_POINT} ext4 defaults,nofail 0 2"
        if ! grep -q "$FSTAB_ENTRY" /etc/fstab; then
            echo "$FSTAB_ENTRY" | tee -a /etc/fstab > /dev/null
        fi
    fi
done