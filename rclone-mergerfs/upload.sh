#!/bin/bash
#####################################################################
#
# 作者: LuckyPuppy514
# 时间：2022-08-23
# 
# 本脚本功能如下：
# 1. rclone move 上传本地文件到云盘
# 优点：相较于直接写入 rclone 挂载路径，无需缓存，少一次硬盘读写
#
#####################################################################

# 报错立即退出
set -e
# 正在运行则退出
if [[ $(pidof -x "$(basename "$0")" -o %PPID) ]]; then
echo "$(basename "$0") already running, exiting..."; exit 1; fi

. ${PWD}/config/rclone-mergerfs.config

if  [ ! "$1" ] ;then
	AGE=${MIN_AGE};
else
	AGE=$1;
fi

# 检查排除文件
if [[ ! -f ${EXCLUDES} ]]; then
echo "excludes file not found, aborting..."; exit 1; fi
# 判断本地磁盘路径是否是云盘路径，是则退出
if /bin/findmnt ${LOCAL_PATH} -o FSTYPE -n | grep fuse; then
echo "FUSE file system found, exiting..."; exit 1; fi

if [[ ! -d ${LOG_PATH} ]]; then
mkdir -p ${LOG_PATH};
fi

# 通过 rclone 移动本地文件到云盘
# 大文件 transfers 设置小一些，否则同时上传多个大文件，耗时太久，阿里云 token 过期会上传失败
/usr/bin/rclone move ${LOCAL_PATH} ${CLOUD_PATH} \
--config ${CONFIG} \
--log-file ${LOG_PATH}/upload.log \
-v --exclude-from ${EXCLUDES} \
--tpslimit 12 \
--tpslimit-burst 12 \
--transfers 1 \
--checkers 12 \
--retries 1 \
--min-age ${AGE} \
--fast-list
