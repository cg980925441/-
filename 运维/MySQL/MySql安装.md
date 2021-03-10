[TOC]



#### MySQL安装

##### 1、压缩包模式

- 1、添加bin目录到环境变量

- 2、在安装目录下新建my.ini配置文件

  ~~~ ini
  [mysql]
  # 设置mysql客户端默认字符集
  default-character-set=utf8
   
  [mysqld]
  # 设置3306端口
  port = 3306
  # 设置mysql的安装目录
  basedir=安装目录
  # 设置 mysql数据库的数据的存放目录，MySQL 8+ 不需要以下配置，系统自己生成即可，否则有可能报错
  datadir=安装目录data
  # 允许最大连接数
  max_connections=20
  # 服务端使用的字符集默认为8比特编码的latin1字符集
  character-set-server=utf8
  # 创建新表时将使用的默认存储引擎
  default-storage-engine=INNODB
  ~~~

- 3、初始化数据库，得到数据库初始化密码

  ~~~ cmd
  mysqld --initialize --console
  ~~~

  dX(sAiW0lk%q

- 4、安装MySQL

  ~~~ cmd
  mysqld install
  ~~~

- 5、启动MySQL服务

  ~~~ cmd
  net start mysql
  ~~~

- 6、登录MySQL  **确保服务真的启动了**

  ~~~ cmd
  mysql -h localhost -u root -p
  然后输入密码
  ~~~

- 7、设置新密码，**分号加或者不加都试试**

  ~~~ cmd
  set password for 'root'@'localhost' = password('123456');
  ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
  ~~~

  然后执行

  ~~~ cmd
  flush privileges;  
  ~~~

- 8、Navicat连接MySQL 8出现2059错误

  原因：MySQL 8.x最新版本采用caching_sha2_password验证，Navicat不支持。

  解决：

  ~~~ cmd
  ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
  
  flush privileges; 
  ~~~

  
  
- 9、MySQL 8 需要在url后面指定

  ~~~ js
  ?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=GMT
  ~~~

  