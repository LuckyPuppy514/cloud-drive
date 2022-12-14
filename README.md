- [ð äºçæè½½ ð](#-äºçæè½½-)
  - [ð³ ç®ä»](#-ç®ä»)
  - [ð¨âð» å®è£](#-å®è£)
    - [âï¸ 1. å®è£ aliyundrive-webdav / alist](#ï¸-1-å®è£-aliyundrive-webdav--alist)
    - [ðª 2. å®è£ rclone](#-2-å®è£-rclone)
    - [ð¤ 3. å®è£ mergerfs](#-3-å®è£-mergerfs)
    - [ð» 4. æåé¡¹ç®å¹¶éç½®](#-4-æåé¡¹ç®å¹¶éç½®)
      - [4.1. æå](#41-æå)
      - [4.2. éç½®](#42-éç½®)
    - [ð 5. æè½½åå¼æºèªå¯](#-5-æè½½åå¼æºèªå¯)
      - [5.1. æè½½](#51-æè½½)
      - [5.2. å¼æºèªå¯](#52-å¼æºèªå¯)
        - [5.2.1. systemctl](#521-systemctl)
        - [5.2.2. rc.local](#522-rclocal)
    - [ð¤ 6. æ·»å å®æ¶ä¸ä¼ ä»»å¡](#-6-æ·»å å®æ¶ä¸ä¼ ä»»å¡)
  - [ð ç¸å³ä»åº](#-ç¸å³ä»åº)
  - [ð å¦ä½è´¡ç®](#-å¦ä½è´¡ç®)
  - [ð ä½¿ç¨è®¸å¯](#-ä½¿ç¨è®¸å¯)

# ð äºçæè½½ ð

## ð³ ç®ä»

> æ¬é¡¹ç®æ¯ä¸ªäººä½¿ç¨çäºçæè½½æ¹æ¡ï¼æ¹ä¾¿éå [automatic-theater](https://github.com/LuckyPuppy514/automatic-theater)ï¼å®ç°ä¸ä¼ äºçä»¥åè§çäºçä¸­çåå®¹

æ¬é¡¹ç®çå¤§è´æè·¯

```mermaid
graph LR
    1[aliyundrive-webdav / alist] == æè½½äºçä¸º webdav ==> 2[rclone] == æè½½å°æ¬å° ==> 3[mergerfs] == åå¹¶æ¬å°ç£çåäºç ==> 4[Emby]
```

éç¨ mergerfs ç¸è¾äºåªä½¿ç¨ rclone çä¼ç¹

- å¢åç®å½æç¡¬çï¼æ éæ¯ä¸ªç³»ç»éä¸è®¾ç½®ï¼åªéä¿®æ¹ mergerfs éç½®å³å¯
- ä¸è½½åä¿çä¸æ®µæ¶é´ååå®æ¶ä¸ä¼ ï¼å¯æä¾æ¶é´ç» Emby å®åä»¥åç¨æ·è§ç
- å®æ¶ä¸ä¼ éç¨ rclone moveï¼æ éåå¥ç¼å­ç®å½ï¼å°ä¸æ¬¡ç¡¬çè¯»åæè
- éåæé¤æä»¶ï¼å¯ä»¥èªç±éæ©éè¦åæ­¥æä¸åæ­¥çç®å½ï¼æä»¶

## ð¨âð» å®è£

### âï¸ 1. å®è£ aliyundrive-webdav / alist

> åªä½¿ç¨é¿éäºçå»ºè®®ä½¿ç¨ aliyundrive-webdavï¼å¶ä»äºçæèå¤äºçï¼å¯ä½¿ç¨ alist

[alist å®æ¹ææ¡£](https://alist-doc.nn.ci/docs/intro)

[aliyundrive-webdav å®æ¹ææ¡£](https://github.com/messense/aliyundrive-webdav#%E5%AE%89%E8%A3%85)

å®æ¹ææ¡£é½è¾ä¸ºè¯¦ç»ï¼è¯·èªè¡æ¥éå¹¶å®è£ï¼è¿éæä¾æç docker-compose éç½®ä¾åè

```bash
version: "3"
services:
  aliyundrive:
    image: messense/aliyundrive-webdav
    container_name: aliyundrive
    ports:
      - 9090:8080
    environment:
      - REFRESH_TOKEN=${ALIYUNDRIVE_REFRESH_TOKEN}
      - WEBDAV_AUTH_USER=${ALIYUNDRIVE_WEBDAV_AUTH_USER}
      - WEBDAV_AUTH_PASSWORD=${ALIYUNDRIVE_WEBDAV_AUTH_PASSWORD}
    restart: unless-stopped

  alist:
    image: xhofe/alist:latest
    container_name: alist
    ports:
      - 5244:5244
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ${CONFIG_PATH}/alist:/opt/alist/data
    restart: unless-stopped
```

### ðª 2. å®è£ rclone

```bash
curl https://rclone.org/install.sh | sudo bash
```

[å®æ¹å®è£ææ¡£](https://rclone.org/install/)

### ð¤ 3. å®è£ mergerfs

æ¯æ apt çç³»ç»ï¼ubuntu / debian / ......

```bash
sudo apt update && sudo apt-get install mergerfs && sudo apt install fuse
```

å¶ä»ç³»ç»è¯·èªè¡æ¥æ¾å®è£æ¹å¼ï¼æåèï¼[å®æ¹å®è£ææ¡£](https://github.com/trapexit/mergerfs#build--update)

### ð» 4. æåé¡¹ç®å¹¶éç½®

#### 4.1. æå

```bash
git clone https://github.com/LuckyPuppy514/cloud-drive.git
```

#### 4.2. éç½®

è·å rclone å å¯åçå¯ç 

```bash
echo "ä½ ç webdav å¯ç " | rclone obscure -
```

ä¿®æ¹ /cloud-drive/rclone-mergerfs/config/rclone.config

```text
[äºçåç§°]
type = webdav
url = http://ip:ç«¯å£å·
vendor = other
user = webdav ç¨æ·å
pass = webdav å å¯åçå¯ç 
```

ææ³¨éä¿®æ¹ /cloud-drive/rclone-mergerfs/config/rclone-mergerfs.config åºç¡éç½®ï¼è¿é¶éç½®å¯æéä¿®æ¹

```text
# åºç¡éç½®
# äºçè·¯å¾
CLOUD_PATH=äºçåç§°:/
# æè½½è·¯å¾
MOUNT_PATH=/mnt/äºçåç§°
# ç¼å­è·¯å¾
CACHE_DIR=/mnt/local/.cache
# æ¬å°ç£çè·¯å¾
LOCAL_PATH=/mnt/local
# åå¹¶åè·¯å¾
MERGERFS_PATH=/mnt/mergerfs
# ç¨æ·IDåç»ID
PUID=1000
PGID=1000
# ä¿å­å¨æ¬å°ç£ççæ¶é´ï¼åå»ºæ¶é´å¤§äº MIN_AGE æä¼ä¸ä¼ ï¼
MIN_AGE=3d
...
```

### ð 5. æè½½åå¼æºèªå¯

#### 5.1. æè½½

ç»èæ¬æ·»å å¯æ§è¡æéï¼å¨ /cloud-drive/rclone-mergerfs ç®å½ä¸æ§è¡

```bash
sudo chmod +x *.sh
```

æè½½

```bash
sudo ./mount.sh
```

æ¥çæè½½æ¯å¦æå

```bash
ls -l ä½ æè½½çè·¯å¾
```

å¸è½½æè½½

```bash
sudo ./unmount.sh
```

#### 5.2. å¼æºèªå¯

> è¿éæä¾ systemctl ä»¥å rc.local çèªå¯å¨æ¹æ¡ï¼ä¸æ¯æçç³»ç»è¯·èªè¡å¯»æ¾å¼æºèªå¯æ¹æ¡ ð¥²

##### 5.2.1. systemctl

ä¿®æ¹ /cloud-drive/rclone-mergerfs/rclone-mergerfs.service ä¸­ç cloud-drive è·¯å¾

```bash
[Unit]
Description=RClone Mergerfs Service
Wants=network-online.target
After=network-online.target

[Service]
Type=forking
KillMode=process
RestartSec=5
Restart=on-failure
User=root
Group=root
WorkingDirectory=/docker/cloud-drive/rclone-mergerfs
ExecStart=/docker/cloud-drive/rclone-mergerfs/mount.sh
ExecStop=/docker/cloud-drive/rclone-mergerfs/unmount.sh

[Install]
WantedBy=multi-user.target
```

æ·»å å¼æºå¯å¨ï¼å¨ /cloud-drive/rclone-mergerfs/ ç®å½ä¸æ§è¡

```bash
sudo cp rclone-mergerfs.service /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable rclone-mergerfs.service
```

å¸¸ç¨å½ä»¤

```bash
# æ¥çè¿è¡ç¶æ
sudo systemctl status rclone-mergerfs.service

# æå¨å¯å¨
sudo systemctl start rclone-mergerfs.service

# æå¨åæ­¢
sudo systemctl stop rclone-mergerfs.service
```

##### 5.2.2. rc.local

```bash
sudo vi /etc/rc.local
```

æ·»å ä»¥ä¸åå®¹å¹¶ä¿å­

```bash
#!/bin/bash
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# ç­å¾ 10s ï¼å è½½ç½ç»ç­
sleep 10

# rclone æè½½
/docker/cloud-drive/rclone-mergerfs/mount.sh
```

> æ³¨æä¿®æ¹èæ¬è·¯å¾ /docker/cloud-drive/rclone-mergerfs/mount.sh

### ð¤ 6. æ·»å å®æ¶ä¸ä¼ ä»»å¡

åä¿®æ¹ä¸éè¦ä¸ä¼ çæä»¶æç®å½éç½®  

/cloud-drive/rclone-mergerfs/config/upload.excludes

```text
media/music/**
media/picture/**
media/video/download/**
.**
*.upload
*partial~
Thumbs.db
```

```bash
sudo crontab -e
```

æ·»å ä»¥ä¸åå®¹å¹¶ä¿å­

```text
# æ¯å¤© 0 ç¹ä¸ä¼ 
0 0 * * * /docker/cloud-drive/rclone-mergerfs/upload.sh
```

> æ³¨æä¿®æ¹èæ¬è·¯å¾ /docker/cloud-drive/rclone-mergerfs/upload.sh

## ð ç¸å³ä»åº

- [aliyundrive-webdav](https://github.com/messense/aliyundrive-webdav) â é¿éäºç WebDAV æå¡  
- [alist](https://github.com/alist-org/alist) â æ¯æå¤å­å¨çæä»¶åè¡¨ç¨åºï¼ä½¿ç¨ Gin å Solidjs  
- [rclone](https://github.com/rclone/rclone) â ç¨äºäºå­å¨ç rsync  

## ð å¦ä½è´¡ç®

éå¸¸æ¬¢è¿ä½ çå å¥ï¼[æä¸ä¸ª Issue](https://github.com/LuckyPuppy514/cloud-drive/issues/new) æèæäº¤ä¸ä¸ª Pull Request

## ð ä½¿ç¨è®¸å¯

[MIT](https://github.com/LuckyPuppy514/cloud-drive/blob/main/LICENSE) Â© LuckyPuppy514
