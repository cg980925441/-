## 16.04

终端输入

~~~shell
vi /etc/network/interfaces
~~~



命令编辑配置文件,增加如下内容： 　　　　

~~~interfaces
auto 网卡名称
iface 网卡名称 inet static
address 固定的IP地址
netmask 255.255.255.0
gateway 192.168.1.1
iface 网卡名称 inet6 auto
~~~



例如:

~~~interfaces
auto ens33
iface ens33 inet static
address 192.168.228.130
netmask 255.255.255.0
gateway 192.168.228.2
iface ens33 inet6 auto
~~~



对应改为：

~~~
auto ens33
iface ens33 inet static
address 192.168.228.130
netmask 255.255.255.0
gateway 192.168.228.1
iface ens33 inet6 auto
~~~



然后刷新

~~~shell
ifdown ens33
ifup ens33
~~~





## 18.04



