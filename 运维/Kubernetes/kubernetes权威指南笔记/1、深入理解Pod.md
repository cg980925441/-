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

kubernetes1.2提供一种统一的应用配置管理方案：ConfigMap。注意是通过环境变量注入到容器，而且可以实现将node上的文件变为配置，配置然后挂载成容器中的文件。



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

通过将ConfigMap中的key作为文件名，value作为文件内容挂载到容器中。

1、指定挂载configmap中的某一些配置

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
        - ls /configfiles && cat /configfiles/apploglevel.txt && cat /configfiles/appdatadir.log;
      volumeMounts:
        - name: testvolumes	# 卷名称
          mountPath: /configfiles # 挂载到容器中的目录
  volumes:
    - name: testvolumes
      configMap:
        name: app-vars # 挂载的configmap名称
        items: # configmap中的那些项将被挂载
          - key: apploglevel # configmap中的key
            path: apploglevel.txt # 文件名
          - key: appdatadir # configmap中的key
            path: appdatadir.log # 文件名
  restartPolicy: Never # 执行完毕后退出，不重启，默认时Always
~~~



2、挂载configmap中的所有配置

此时无法指定文件名了，只能以key作为文件名。

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
        - ls /configfiles && cat /configfiles/apploglevel.txt && cat /configfiles/appdatadir.log;
      volumeMounts:
        - name: testvolumes	# 卷名称
          mountPath: /configfiles # 挂载到容器中的目录
  volumes:
    - name: testvolumes
      configMap:
        name: app-vars # 挂载的configmap名称
  restartPolicy: Never # 执行完毕后退出，不重启，默认时Always
~~~



#### 3、ConfigMap的限制

1、必须在Pod前创建

2、受namespace限制

3、静态Pod无法使用

4、文件挂载时，会覆盖容器内原本的文件



## 5、容器内获取Pod信息

主要是通过Downward API进行注入，两种方式：1、环境变量  2、文件挂载

#### 1、Pod信息

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-get-pod-info
  labels:
    a: a
    b: b
    c: c
  annotations:
    build: two
    builder: jhn-doe
spec:
  containers:
    - name: ubuntu-curl
      image: nanda/ubuntu-curl:v1
      command: 
        - sh
        - -c
      args:
        - env | grep POD_NAME && ls /configfiles && cat /configfiles/labels && cat /configfiles/annotations
      env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
      volumeMounts:
        - name: podinfo
          mountPath: /configfiles
          readOnly: false
  volumes:
    - name: podinfo
      downwardAPI:
        items:
          - path: "labels"
            fieldRef:
              fieldPath: metadata.labels
          - path: "annotations"
            fieldRef:
              fieldPath: metadata.annotations
  restartPolicy: Never # 执行完毕后退出，不重启，默认时Always
~~~



Downward API提供的变量有:

- metadata.name
- status.podIP
- metadata.namespace
- metadata.labels
- metadata.annotations



#### 2、容器资源信息

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-get-pod-resource-info
spec:
  containers:
    - name: ubuntu-curl
      image: nanda/ubuntu-curl:v1
      command: 
        - sh
        - -c
      args:
        - env | grep MY_
      resources:
        requests:
          memory: "32Mi"
          cpu: "125m"
        limits:
          memory: "64Mi"
          cpu: "250m"
      env:
        - name: MY_REQUEST_CPU
          valueFrom:
            resourceFieldRef:
              containerName: ubuntu-curl
              resource: requests.cpu
        - name: MY_LIMITS_CPU
          valueFrom:
            resourceFieldRef:
              containerName: ubuntu-curl
              resource: limits.cpu
        - name: MY_REQUEST_MEMORY
          valueFrom:
            resourceFieldRef:
              containerName: ubuntu-curl
              resource: requests.memory
        - name: MY_LIMITS_MEMORY
          valueFrom:
            resourceFieldRef:
              containerName: ubuntu-curl
              resource: limits.memory
  restartPolicy: Never # 执行完毕后退出，不重启，默认时Always
~~~

Downward API提供的变量有:

- requests.cpu
- limits.cpu
- requests.memory
- limits.memory
- limits.ephemeral-storage
- requests.ephemeral-storage



#### 3、作用

某些程序启动时，可能需要自身的某些信息（自身标示或者IP）然后注册到服务注册中心的地方，这时可以使用启动脚本将注入的POD信息写到配置文件中，然后启动程序。



## 6、Pod生命周期和重启策略

### 1、生命周期

| 状态               | 描述                                                         |
| ------------------ | ------------------------------------------------------------ |
| pending            | API Server已经创建该Pod，但是Pod中还有容器没有创建，包括镜像下载的过程 |
| Running            | Pod内所有容器都已经创建，容器处于运行、正在启动、正在重启状态 |
| Complete/Succeeded | Pod中所有容器都已经成功执行并且退出，且不会再重启            |
| Failed             | Pod中所有容器都已退出，但有容器的退出状态为失败（exitcode非0） |
| Unknown            | 网络不通，无法获取状态                                       |



### 2、重启策略

yaml文件中restartPolicy的取值：

- Always：容器失效时，kubelet自动重启该容器
- OnFailure：容器终止且退出code不为0时，由kubelet自动重启该容器
- Never：无论容器运行状态如何，kubelet都不会重启该容器



重启的时间：sync-frequency*2n，最长延迟5分钟，并且在成功重启后的10分钟后重置改时间。

总结：需要长时间运行的程序设置为Always，只需要执行一次的程序设置为Never或者OnFailure



## 7、Pod健康检查和服务可用性检查

Kubernetes提供三种方式进行Pod中容器的健康检查，健康检查不通过时会依据配置的重启策略进行重启。

1、在容器中执行命令

2、TCP连接测试

3、HTTP请求测试



TCP和HTTP方式即使失败，退出码也是0，所以配置为Never的情况下，失败会变成Complete



### 1、执行命令

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-liveness-cmd
spec:
  containers:
    - name: ubuntu-curl
      image: nanda/ubuntu-curl:v1
      command: 
        - sh
        - -c
      args:
        - echo ok > /tmp/health; sleep 10; rm -rf /tmp/health; sleep 600;
      livenessProbe: # 执行cat /tmp/health命令,如果后面文件不存在时cat命令返回code是0，可以通过执行命令后执行echo $?查看
        exec:
          command:
            - cat
            - /tmp/health
        initialDelaySeconds: 15 # 延迟15s后执行
        timeoutSeconds: 1 # 响应超时时间
  restartPolicy: Never 
~~~



这里会一直重启该Pod，这个Pod执行会一直失败.



### 2、TCP

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-liveness-tcp
spec:
  containers:
    - name: nginx
      image: nginx
      ports:
        - containerPort: 80
      livenessProbe: # 与本地的8080端口建立连接，没有开启这个端口，所以容器健康检查会失败，容器退出
        tcpSocket:
          port: 8080
        initialDelaySeconds: 30 # 延迟30s后执行
        timeoutSeconds: 1 # 响应超时时间
  restartPolicy: Never 
~~~





### 3、HTTP

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-liveness-http
spec:
  containers:
    - name: nginx
      image: nginx
      ports:
        - containerPort: 80
      livenessProbe: # 访问localhost:80/_status/healthz,nginx没有，所以会404，健康检查失败容器退出
        httpGet:
          path: /_status/healthz
          port: 80
        initialDelaySeconds: 30 # 延迟30s后执行
        timeoutSeconds: 1 # 响应超时时间
  restartPolicy: Never 
~~~





## 8、Pod调度

我们的Pod可能根据不同的情况需要被调度到不同的Node上，主要有以下几种情况：

1、web应用，不限定node

2、数据库类Pod部署到ssd的node上

3、某两个pod不能部署到同一个node上或者某 两个pod必须部署到同一个node上（共用网络和数据卷）

4、zk、es、mongo、kafka，必须部署到不同的node上，恢复后需要挂载原来的volume，复杂

5、日志采集、性能采集每个node上都需要有且部署一个

6、

