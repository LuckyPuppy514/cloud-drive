#!/bin/bash
. ${PWD}/config/rclone-mergerfs.config
fusermount -uz ${MOUNT_PATH}
fusermount -uz ${MERGERFS_PATH}