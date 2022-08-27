#!/bin/bash
#####################################################################
#
# 作者: LuckyPuppy514
# 时间：2022-08-23
# 
# 本脚本功能如下：
# 1. rclone 挂载云盘到本地路径
# 2. mergerfs 合并本地磁盘和云盘
# 
# mergerfs 优点：
# 1. 内容合并，本地磁盘和云盘内容均可在同一个路径中访问
# 2. 把本地磁盘放前面，可以优先读写本地磁盘，速度与本地磁盘相同
# 3. 配合 rclone-upload.sh ，定时上传云盘，无需缓存，
#    相较于 rclone 直接写入，少一次硬盘读写操作
#   （rclone写入时会先复制到缓存路径，然后后台上传）
#
#####################################################################

# 报错立即退出
set -e
# 正在运行则退出
if [[ $(pidof -x "$(basename "$0")" -o %PPID) ]]; then
echo "$(basename "$0") already running, exiting..."; exit 1; fi

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
cd ${SHELL_FOLDER}
. ${PWD}/config/rclone-mergerfs.config

if [[ ! -d ${LOG_PATH} ]]; then
	mkdir -p ${LOG_PATH};
fi
if [[ ! -d ${MOUNT_PATH} ]]; then
	mkdir -p ${MOUNT_PATH};
fi
if [[ ! -d ${MERGERFS_PATH} ]]; then
	mkdir -p ${MERGERFS_PATH};
fi

# rclone
/usr/bin/rclone mount ${CLOUD_PATH} ${MOUNT_PATH} \
--config=${CONFIG} \
--log-level ${LOG_LEVEL} \
--log-file ${LOG_PATH}/rclone.log \
--buffer-size ${BUFFER_SIZE} \
--attr-timeout ${ATTR_TIMEOUT} \
--dir-cache-time ${DIR_CACHE_TIME} \
--poll-interval ${POLL_INTERVAL} \
--cache-dir ${CACHE_DIR} \
--vfs-cache-mode ${VFS_CACHE_MODE} \
--vfs-read-ahead ${VFS_READ_AHEAD} \
--vfs-cache-max-age ${VFS_CACHE_MAX_AGE} \
--vfs-cache-max-size ${VFS_CACHE_MAX_SIZE} \
--vfs-read-chunk-size ${VFS_READ_CHUNK_SIZE} \
--vfs-read-chunk-size-limit ${VFS_READ_CHUNK_SIZE_LIMIT} \
--transfers ${TRANSFERS} \
--checkers ${CHECKERS} \
--uid ${PUID} \
--gid ${PGID} \
--dir-perms=${DIR_PERMS} \
--file-perms=${FILE_PERMS} \
--umask=${UMASK} \
--tpslimit ${TPSLIMIT} \
--tpslimit-burst ${TPSLIMIT_BURST} \
--multi-thread-cutoff ${MULTI_THREAD_CUTOFF} \
--multi-thread-streams ${MULTI_THREAD_STREAMS} \
--allow-non-empty \
--allow-other \
--daemon


# mergerfs
/usr/bin/mergerfs ${LOCAL_PATH}:${MOUNT_PATH} ${MERGERFS_PATH} \
-o nonempty,rw,use_ino,allow_other,func.getattr=newest,category.action=all,category.create=ff,cache.files=auto-full,dropcacheonclose=true

