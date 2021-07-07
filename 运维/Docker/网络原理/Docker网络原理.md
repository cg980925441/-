Docker的网络实现依赖Linux的namespace机制，namespace机制提供Linux内核级别的环境隔离LXC（Linux Containers），可以实现进程的虚拟化功能。



- NET：网络
- PID：进程
- IPC：消息，进程间通信 ipc
- MNT：文件系统 mnt
- UTS：主机和域名（hostname和domainname） 



## 1、容器进程namespaces网络隔离

### 1、Gateway

> https://www.cnblogs.com/sammyliu/p/5760125.html



| 步骤 | **命令**                                                     | **说明**                                                     |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    | ip netns add myspace                                         | 创建名称为 ‘myspace’ 的 linux network namespace              |
| 2    | ip link add veth1 type veth peer name veth2                  | 创建一个 veth 设备，一头为 veth1，另一头为 veth2             |
| 3    | ip link set veth2 netns myspace                              | 将 veth2 加入 myspace 作为其一个 network interface           |
| 4    | ifconfig veth1 192.168.45.2 netmask 255.255.255.0 up         | 配置 veth1 的 IP 地址                                        |
| 5    | ip netns exec myspace ifconfig veth2 192.168.45.3 netmask 255.255.255.0 up | 配置 veth2 的 IP 地址，它和 veth1 需要在同一个网段上         |
| 6    | ip netns exec myspace route add default gw 192.168.45.2      | 将 myspace 的默认路由设为 veth1 的 IP 地址                   |
| 7    | echo 1 > /proc/sys/net/ipv4/ip_forward                       | 开启 linux kernel ip forwarding                              |
| 8    | iptables -t nat -A POSTROUTING -s 192.168.45.0/24 -o eth0 -j MASQUERADE | 配置 SNAT，将从 myspace 发出的网络包的 soruce IP address 替换为 eth0 的 IP 地址 |
| 9    | iptables -t filter -A FORWARD -i eth0 -o veth1 -j ACCEPTiptables -t filter -A FORWARD -o eth0 -i veth1 -j ACCEPT | 在默认 FORWARD 规则为 DROP 时显式地允许 veth1 和 eth0 之间的 forwarding |



原理：将host作为网关，新建namespace中的网卡通过veth设备对与host通信，然后通过host中的iptables从host的网卡发出访问外网。



### 2、Bridge

> https://www.cnblogs.com/sammyliu/p/5763513.html



| 步骤 | **命令**                                                     | **说明**                                                     |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    | ip netns add ns2                                             | 创建名称为 ‘ns2’ 的 linux network namespace                  |
| 2    | ip link add veth1 type veth peer name veth2                  | 创建一个 veth 设备，一头为 veth1，另一头为 veth2             |
| 3    | ip link set veth2 netns ns2                                  | 将 veth2 加入 ns2 作为其一个 network interface               |
| 4    | brctl addbr br1brctl addif br1 eth0ifconfig eth0 0.0.0.0ifconfig br1 192.168.1.87/24 upbrctl addif br1 veth1 | 创建 linux bridge ‘br1’删除 eth0 的 IP 地址，并将其地址设给 br1将 eth0 加入 br1将 veth1 加入 br1 |
| 5    | ip netns exec ns2 ifconfig veth2 192.168.1.88/24 up          | 配置 veth2 的 IP 地址，它和 host1 和 host2 在同一个网段上    |
| 6    | ip netns exec ns2 route add default gw 192.168.1.1           | 将 ns2 的默认路由设为 host1 和 host2 的网关地址              |
| 7    | iptables -t filter  -A FORWARD -m physdev --physdev-in eth0 --physdev-out veth1 -j ACCEPTiptables -t filter  -A FORWARD -m physdev --physdev-out eth0 --physdev-in veth1 -j ACCEPT | 设置 FORWARD 规则                                            |



原理：host主机上veth设备与网卡连接网桥，网桥和新建namespace中的veth处于同一个网段，同一个网关，新建namespace通过该网关访问外网。

