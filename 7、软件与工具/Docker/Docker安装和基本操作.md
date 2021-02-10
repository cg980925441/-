## 1.安装：

~~~shell
# 下载安装文件
curl -fsSL get.docker.com -o get-docker.sh

# 指定镜像
sudo sh get-docker.sh --mirror Aliyun

# 下载安装docker
sh get-docker.sh --AzureChinaCloud
~~~





## 2.修改数据源

### 1、在/etc/docker/daemon.json （如果文件不存在请新建该文件） 中写入

~~~ shell
echo {\"registry-mirrors\": [\"https://a07sw6e0.mirror.aliyuncs.com\"]}>>/etc/docker/daemon.json&&chmod 666 /etc/docker/daemon.json
~~~



### 2、重启服务

~~~ shell
systemctl daemon-reload
systemctl restart docker
~~~



### 3、查看是否成功

~~~ shell
docker info
~~~



## 3、拉取镜像

~~~
docker pull tomcat:tag版本
~~~



## 4、运行Tomcat

~~~
docker run 8080:8080 tomcat
~~~



## 5、Dockerfile定制镜像

基本格式：

~~~shell
FROM 镜像名
WORKDIR "工作路径"
RUN shell命令
~~~

构建镜像命令：

~~~shell
docker build -t 镜像名 Dockerfile目录
~~~

其他命令：

~~~shell
COPY 上下文环境路径 宿主机路径
# ADD命令会自动下载url文件，解压缩tar包；但是行为未知，官方不推荐使用
ADD tar包/url 宿主机路径
~~~





## 6、安装Docker-Compose

~~~shell
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
~~~

