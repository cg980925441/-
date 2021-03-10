安装路径：/usr/local/

1.设置系统环境变量
配置文件： vim /etc/environment
加入内容：
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export JAVA_HOME=/usr/local/java/jdk1.8.0_221
export JRE_HOME=/usr/local/java/jdk1.8.0_221/jre
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib

2.配置用户环境变量

配置文件：/etc/profile

export JAVA_HOME=/usr/local/java/jdk1.8.0_221
export JRE_HOME=/usr/local/java/jdk1.8.0_221/jre
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH:$HOME/bin


3.使之生效

source /etc/profile

4.测试是否成功

java -version