1、在宿主机/usr/local/docker/mysql目录建立以下三个目录存放mysql的配置文件，日志和数据

- conf
- data
- logs

拷贝容器中的/usr/mysql中的文件到conf目录下





```shell
docker run -p 3306:3306 \
--name mysql \
-v /usr/local/docker/mysql/conf:/etc/mysql \
-v /usr/local/docker/mysql/data:/var/lib/mysql \
-v /usr/local/docker/mysql/mysql-files:/var/lib/mysql-files \
-v /usr/local/docker/mysql/logs:/var/log/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
-d mysql:5.7.22		
```



~~~ shell
docker run -p 3326:3306 \
--name mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
mysql
~~~

