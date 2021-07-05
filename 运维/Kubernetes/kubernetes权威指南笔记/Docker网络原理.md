# Docker网络原理

Docker网络的实现主要依赖Linux内核2.6.29后提供的Network Namespace功能，可以实现每个namespace有单独的网络协议栈，互相隔离。



以一个例子实现新建的NetWork Namespace可以访问外部网络。



## 1、NAT方式

