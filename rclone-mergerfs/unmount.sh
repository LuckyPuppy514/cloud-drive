#!/bin/bash
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
cd ${SHELL_FOLDER}
. ${PWD}/config/rclone-mergerfs.config

fusermount -uz ${MOUNT_PATH}
fusermount -uz ${MERGERFS_PATH}