## 16.04

终端输入vi /etc/network/interfaces命令编辑配置文件,增加如下内容： 　　　　

~~~config
auto 网卡名称
iface 网卡名称 inet static
address 固定的IP地址
netmask 255.255.255.0
gateway 192.168.1.1
iface 网卡名称 inet6 auto
~~~



例如:

~~~shell
ens33     Link encap:Ethernet  HWaddr 00:0c:29:fa:e2:b6  
          inet addr:192.168.228.130  Bcast:192.168.228.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fefa:e2b6/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:131 errors:0 dropped:0 overruns:0 frame:0
          TX packets:105 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:23796 (23.7 KB)  TX bytes:18712 (18.7 KB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:160 errors:0 dropped:0 overruns:0 frame:0
          TX packets:160 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:11840 (11.8 KB)  TX bytes:11840 (11.8 KB)

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



