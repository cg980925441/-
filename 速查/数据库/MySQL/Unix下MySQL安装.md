1、下载MYSQL，解压



2、环境变量配置

export MYSQL=解压路径



3、MYSQL配置文件

在mysql解压目录下，新建my.cnf文件

~~~cnf
[mysqld]
basedir=mysql解压路径
datadir=mysql解压路径\data
#开启连接查询日志
general_log=on
general_log_file=/Volumes/Mac附加卷/develop/mysql-5.7.29-macos10.14-x86_64/log/run.log
~~~

tip：目录不存在必须首先创建目录



4、初始化MYSQL

执行mysql --initialize

得到mysql密码



5、运行mysql

执行mysqld



最后使用navicat登陆后，修改密码即可