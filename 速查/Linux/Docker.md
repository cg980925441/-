## 1.安装：

curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh --mirror Aliyun



## 2.修改数据源

### 1、在/etc/docker/daemon.json （如果文件不存在请新建该文件） 中写入

~~~ json
{
  "registry-mirrors": [
    "https://a07sw6e0.mirror.aliyuncs.com"
  ]
}
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



