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

kubernetes1.2提供一种统一的应用配置管理方案：ConfigMap，用法：1、生成环境变量。2、启动参数或程序使用环境变量。3、



### 1、创建ConfigMap

#### 1、YAML配置文件创建

~~~yaml
apiVersion: v1
kind: ConfigMap  # ConfigMap
metadata:
  name: app-vars  # ConfigMap的名称，全局唯一
data:
  apploglevel: info
  appdatadir: /var/data
~~~



可以将配置文件的内容作为data中的value



#### 2、通过命令行创建

~~~shell
# 从目录中进行创建，文件名作为key，文件内容作为value
kubectl create configmap ConfigMap名称 --from-file=目录
~~~



### 2、在Pod中使用ConfigMap

#### 1、通过环境变量进行使用

1、通过环境变量

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-use-configmap
spec:
  containers:
    - name: ubuntu-curl
      image: nanda/ubuntu-curl:v1
      command: 
        - sh
        - -c
      args:
        - env | grep APP;
      env: 
        - name: APPLOGLEVEL
          valueFrom:
            configMapKeyRef:
              name: app-vars # ConfiMap的名称
              key: apploglevel # ConfigMap中Key的名称
  restartPolicy: Never # 执行完毕后退出，不重启，默认时Always
~~~



2、1.6之后的新字段envFrom将ConfigMap中所有定义的key=value自动生成环境变量

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-use-configmap
spec:
  containers:
    - name: ubuntu-curl
      image: nanda/ubuntu-curl:v1
      command: 
        - sh
        - -c
      args:
        - env;
      envFrom: 
        - configMapRef:
            name: app-vars # ConfiMap的名称
  restartPolicy: Never # 执行完毕后退出，不重启，默认时Always
~~~



#### 2、通过volumeMount使用ConfigMap



