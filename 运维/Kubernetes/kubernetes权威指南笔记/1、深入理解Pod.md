# 1、深入理解Pod

## 1、基本用法



### 1、对于容器的要求

>kubernetes对长时间运行的容器要求：必须一直在前台执行。如果是后台执行的程序，例如
>
>Nohup ./start.sh &
>
>则会在执行完成之后销毁Pod，但是可以借助一些方式让后台程序在前台执行，例如supervisor



### 2、一个Pod多个容器

​	如果两个容器耦合性较强，可以放在一个Pod里面，此时他们可以共享网络和文件。例如：

1、前端应用容器直接通过localhost访问后台应用容器服务；

2、一个应用写日志到本地，一个应用从本地读日志；



## 2、静态Pod

> https://kubernetes.io/zh/docs/tasks/configure-pod-container/static-pod/

​	

静态Pod是指由kubelet管理仅存在于特定Node上的Pod，不能1、通过API Server管理	2、与RC、Deployment关联	3、kubelet无法进行健康检查

创建静态Pod有配置文件和HTTP方式。



### 1、配置文件

设置kubelet的启动参数"--pod-manifest-path=/root/yaml/",对于该目录下的yaml或者json文件，kubelet服务会定期进行扫描和创建。

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: static-web
  labels:
    role: myrole
spec:
  containers:
    - name: web
      image: nginx
      ports:
        - name: web
          containerPort: 80
          protocol: TCP
~~~



#### 1、删除Pod

静态Pod无法通过kubectl delete删除，删除后状态会变成Pending，删除需要删除对应config目录下的json和yaml配置。



### 1、HTTP方式

指定kubelet的启动参数"--manifest-url"。



## 3、Pod容器共享卷Volume和网络

Note: 卷的名称只能是xx-xx的形式，不能使用小驼峰.

一个Pod内存在多个容器时，容器可以共享挂载卷，实现同一个目录，一个容器应用读取，一个容器应用写入。

例如：

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: share-volumes-pod
spec:
  containers:
    - name: tomcat
      image: tomcat
      volumeMounts:
        - name: log-volumes
          mountPath: /usr/local/tomcat/logs
      ports:
        - containerPort: 8080
    - name: ubuntu-curl
      image: nanda/ubuntu-curl:v1
      volumeMounts:
        - name: log-volumes
          mountPath: /logs
      command: 
        - sh
        - -c
      args:
        - while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:8080)" != '200' ]]; do echo Waiting for tomcat;sleep 5; done; tail -f /logs/catalina*.log;
  volumes:
    - name: log-volumes
      emptyDir: {}
~~~



这里有点要注意：容器启动是异步的，启动顺序是安装配置文件来，但是第二个启动时第一个不一定启动OK了，所有加入linux脚本命令等待第一个执行完毕。



## 4、Pod的配置管理



