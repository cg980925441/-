# 通过Kubernetes实现一些特性

## 1、扩缩容

### 1、手动伸缩

我们先创建一个Deployment部署三台nginx，然后手动进行扩缩容操作。

> deployment、rc和rs的区别：rc是最初的实现，实现副本数量可控；rs是rc的升级，支持集合的label selector；deployment基于rs实现，是对其的又一次拓展。

新建nginx_deployment.yaml

~~~yaml
apiVersion: apps/v1
kind: Deployment  # Deployment
metadata:
  name: mynginx  # Deployment的名称，全局唯一
spec:
  replicas: 3   # Pod副本的期待数量
  selector:
    matchLabels:    # 注意这里写法和RC的不一样，因为支持多个selector
      app: mynginx  # 符合目标的pod拥有此标签,===1此处应当一致
  template:     # 根据此模板创建pod的副本
    metadata:
      labels:
        app: mynginx  # pod副本拥有的标签,===1此处应当一致
    spec:
      containers:        # pod中容器的定义部分
      - name: mynginx   # 容器名称
        image: nginx  # 容器对应的docker镜像
        ports:
          - containerPort: 80   # 容器应用监听的端口号
~~~



通过kubectl get pods查看,可以看到数量为3



在Kubernetes中，我们可以手动对deployment中副本的数量进行更改，通过命令

~~~shell
kubectl scale deployment deployment名称 --replicas=副本数量
~~~

例如，将mynginx的副本数量由3改为4，再观察pod的情况。

~~~shell
# 手动伸缩副本数量
kubectl scale deployment mynginx --replicas=4

# 查看pod的调度情况
kubectl describe pod mynginx
~~~



可以看到已经扩容部署了新实例。



### 2、弹性伸缩

弹性伸缩在Kubernetes中称为HPA（HorizontalPodAutoscaler），即Pod的水平伸缩，可实现基于CPU利用率来进行自动扩缩容，也可以基于自定义的规则进行扩容。

测试HPA的话，我们首先写一个相关的测试程序，简单的java web工程，暴露一个接口在请求来时做一些耗费CPU的操作。

 ~~~java
package com.zanpo.it.HPADemo;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "helloServlet", value = "/hpa")
public class HelloServlet extends HttpServlet {
    private String message;

    public void init() {
        message = "Hello World!";
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        long r = 0;
        for (long i = 0; i < 1000000000; i++) {
            r += i;
        }
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>" + message + "</h1>");
        out.println("<h1>" + r + "</h1>");
        out.println("</body></html>");
    }

    public void destroy() {
    }
}
 ~~~



然后我们将这个程序打成一个docker镜像，让我们镜像启动时暴露一个接口，我们多次调用该接口实现提升CPU的利用率，让Kubernetes进行HPA操作。

这里涉及几步：

#### 1、搭建一个本地dockerHub

用来存我们的镜像，用线上的dockerHub由于网络原因，上传和拉取下载速度太慢，不利于测试；

想使用线上dockerHub的话可以使用华为云提供的服务：https://console.huaweicloud.com/swr/。

我们首先克隆一个docker_base虚拟机，在上面安装一个本地的dockerhub，包含两个镜像，registry和前端镜像

~~~shell
# 拉取官方镜像
docker pull registry
# 运行，always设置容器自动重启，-v挂载容器中registry数据卷到本机的/opt/registry下
docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v /opt/registry:/var/lib/registry \
  registry
~~~



启动完成之后，在kubernetes的两台Node结点和master机器上配置我们自己的docker仓库地址：

~~~shell
vim /etc/docker/daemon.json
~~~



~~~json
{
    "registry-mirrors": [
        "https://a07sw6e0.mirror.aliyuncs.com"
    ],
    "insecure-registries": [
        "172.16.185.200:5000"
    ]
}
~~~

然后重启下docker

~~~shell
systemctl restart docker
~~~



#### 2、制作镜像

将我们应用程序打包成一个基于tomcat的镜像，上传到dockerHub上。

首先制作镜像

~~~dockerfile
FROM tomcat
WORKDIR "/usr/local/tomcat"
RUN mv ./webapps.dist/* ./webapps
COPY ./HPADemo.war /usr/local/tomcat/webapps
~~~

执行

~~~shell
# 根据dockerfile制作镜像
docker build -t hpa ./   
~~~



然后给我们的镜像打一个tag，上传到本地的hub上

~~~shell
# 给镜像打tag
docker tag hpa:latest 172.16.185.200:5000/hpa:latest
# 上传到本地hub
docker push 172.16.185.200:5000/hpa:latest
~~~



#### 3、创建deployment和service

根据yaml的格式，我们也可以使用"---"分段的形式在一个文件中创建deployment和service

~~~yaml
apiVersion: apps/v1
kind: Deployment  # Deployment
metadata:
  name: hpa  # Deployment的名称，全局唯一，这里用我们刚制作的镜像
spec:
  replicas: 1   # Pod副本的期待数量
  selector:
    matchLabels:    # 注意这里写法和RC的不一样，因为支持多个selector
      app: hpa  # 符合目标的pod拥有此标签,===1此处应当一致
  template:     # 根据此模板创建pod的副本
    metadata:
      labels:
        app: hpa  # pod副本拥有的标签,===1此处应当一致
    spec:
      containers:        # pod中容器的定义部分
      - name: hpa   # 容器名称
        image: 172.16.185.200:5000/hpa:latest  # 容器对应的docker镜像,这里加上我们的本地镜像地址
        ports:
          - containerPort: 8080   # 容器应用监听的端口号，tomcat默认的8080
        resources: 
          limits: # 最大的CPU和内存,这里是必须的，否则无法统计
            cpu: 200m
            memory: 100Mi
          requests:  # 需求的内存和CPU,这里是必须的，否则无法统计
            cpu: 100m
            memory: 50Mi

---
apiVersion: v1
kind: Service  # 表明是 Kubernets Service
metadata:
  name: hpa  # Service的名称，全局唯一
spec:
  type: NodePort  # 使用Node结点IP+端口的方式暴露给外部调用
  selector:
    app: hpa  # 符合目标的pod拥有此标签,===1此处应当一致
  ports:
    - port: 8080  # Service提供服务的端口号
      nodePort: 30002 # 暴露给外部的端口，范围在30000-32767
~~~



#### 4、安装metrics-server

我们首先得安装metrics-server服务，用于收集Node的CPU、内存等信息。

阿里云的google_container没有这个镜像，微软的azk8s也是403，但是dockerhub上有个bitnami/metrics-server的镜像，我们可以使用；因为不是官方的，担心安全的话，可以科学上网去谷歌仓库下载或者自己编译然后进行镜像制作。

metrics-server镜像下载好了，我们在kubernetes中启用。

进入metrics-server的github有对应的安装命令，我们将该yaml中deployment的镜像改一下即可

https://github.com/kubernetes-sigs/metrics-server

配置文件修改如下：

~~~yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    k8s-app: metrics-server
    rbac.authorization.k8s.io/aggregate-to-admin: "true"
    rbac.authorization.k8s.io/aggregate-to-edit: "true"
    rbac.authorization.k8s.io/aggregate-to-view: "true"
  name: system:aggregated-metrics-reader
rules:
- apiGroups:
  - metrics.k8s.io
  resources:
  - pods
  - nodes
  verbs:
  - get
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    k8s-app: metrics-server
  name: system:metrics-server
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - nodes
  - nodes/stats
  - namespaces
  - configmaps
  verbs:
  - get
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server-auth-reader
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: extension-apiserver-authentication-reader
subjects:
- kind: ServiceAccount
  name: metrics-server
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server:system:auth-delegator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: metrics-server
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    k8s-app: metrics-server
  name: system:metrics-server
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:metrics-server
subjects:
- kind: ServiceAccount
  name: metrics-server
  namespace: kube-system
---
apiVersion: v1
kind: Service
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
spec:
  ports:
  - name: https
    port: 443
    protocol: TCP
    targetPort: https
  selector:
    k8s-app: metrics-server
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
spec:
  selector:
    matchLabels:
      k8s-app: metrics-server
  strategy:
    rollingUpdate:
      maxUnavailable: 0
  template:
    metadata:
      labels:
        k8s-app: metrics-server
    spec:
      containers:
      - args:
        - --cert-dir=/tmp
        - --secure-port=4443
        - --kubelet-insecure-tls      # 不验证客户端证书
        - --kubelet-preferred-address-types=InternalIP  # 让metrics-server连接结点IP
        image: bitnami/metrics-server # 镜像地址改一下
        imagePullPolicy: IfNotPresent
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /livez
            port: https
            scheme: HTTPS
          periodSeconds: 10
        name: metrics-server
        ports:
        - containerPort: 4443
          name: https
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /readyz
            port: https
            scheme: HTTPS
          periodSeconds: 10
        securityContext:
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 1000
        volumeMounts:
        - mountPath: /tmp
          name: tmp-dir
      nodeSelector:
        kubernetes.io/os: linux
      priorityClassName: system-cluster-critical
      serviceAccountName: metrics-server
      volumes:
      - emptyDir: {}
        name: tmp-dir
---
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  labels:
    k8s-app: metrics-server
  name: v1beta1.metrics.k8s.io
spec:
  group: metrics.k8s.io
  groupPriorityMinimum: 100
  insecureSkipTLSVerify: true
  service:
    name: metrics-server
    namespace: kube-system
  version: v1beta1
  versionPriority: 100
~~~

执行:

~~~shell
# 应用metrics-server
kubectl apply	 -f components.yaml 
~~~



执行完成后，执行 

~~~shell
kubectl top nodes
~~~

就可以看到对应node结点的状态了。



#### 5、创建HPA对象

我们再来创建一个HPA对象，进行操作。

~~~yaml
apiVersion: autoscaling/v1      # 使用v1版本，仅支持基于CPU使用率的自动扩缩容，v2beta2可支持自定义指标
kind: HorizontalPodAutoscaler
metadata:
  name: hpa # HorizontalPodAutoscaler的名称，全局唯一
  namespace: default # 命名空间，不写都为默认
spec:
  # HPA的伸缩对象描述，可以是deployment、RC和RS
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hpa
  minReplicas: 1  # 最小pod数量
  maxReplicas: 10 # 最大pod数量
  targetCPUUtilizationPercentage: 50 # 期待每个pod的CPU使用率都为50%
~~~



然后我们通过压测工具或者shell脚本来循环调用一下，看下实例的变化情况。

可以看到我们多调用几次http://172.16.185.137:30002/HPADemo/hpa后，kubernetes已经在自动扩容了，我们停止调用，过一段时间后可以看到实例已经开始进行减少了。



## 2、应用升级

### 1、滚动升级

我们在开发进行迭代升级的时候，应用可能是集群部署，升级原因的时候想每停止一个旧的就创建一个新的，实现平滑的切换。

而不会由于升级导致服务的不可用，我们这时就可以使用kubernetes的特性实现。



### 2、中断升级

中断升级和滚动升级相对应，即升级过程中会导致服务的中断，导致服务不可用。

实现方案也很简单，我们首先将之前部署的deployment对象删除，此时kubernetes会将对应的实例销毁，我们再创建新的deployment对象即可。



## 3、负载均衡



## 4、服务发现

 

## 5、配置中心

