#!/bin/bash

DATA_DISK="$HOME/datasets/tf/tf-storage.img"
MOUNT_POINT="/mnt/tf"

# 1. Prepare the 2GB Data Disk
if [ ! -f "$DATA_DISK" ]; then
    echo "Creating 2GB Data Disk..."
    truncate -s 2G "$DATA_DISK"
    mkfs.ext4 "$DATA_DISK"
fi

# 2. Mount if not already mounted
if ! mountpoint -q "$MOUNT_POINT"; then
    sudo mkdir -p "$MOUNT_POINT"
    sudo mount -o loop "$DATA_DISK" "$MOUNT_POINT"
    sudo chown $USER:$USER "$MOUNT_POINT"
fi

