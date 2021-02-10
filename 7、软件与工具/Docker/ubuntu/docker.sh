#!/bin/bash

# 下载安装文件
curl -fsSL get.docker.com -o get-docker.sh

# 指定镜像
sudo sh get-docker.sh --mirror Aliyun

# 下载安装docker
sh get-docker.sh --AzureChinaCloud

# 修改数据源
echo {\"registry-mirrors\": [\"https://a07sw6e0.mirror.aliyuncs.com\"]}>>/etc/docker/daemon.json&&chmod 666 /etc/docker/daemon.json

# 重新加载配置文件
systemctl daemon-reload

# 重启服务
systemctl restart docker

