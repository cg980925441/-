# 1、使用kuberadm工具快速安装

> https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/



~~~shell

# 修改主机名，避免nodes命令结点只有一个
# 1、临时修改
hostname master

# 2、永久修改
vim /etc/hostname

# 也可以在k8s配置文件中指定，简单起见，先设置主机名为master和node1、node2

# 此外还需要在hosts文件中修改下主机名
127.0.0.1 master
~~~



## 1、添加kubernetes下载源 

~~~shell
# 添加内容：deb 镜像源 kubernetes-xenial main
# 这里用清华大学的镜像源
echo "deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/ kubernetes-xenial main">>/etc/apt/sources.list.d/kubernetes.list
~~~



> 可选镜像源：
>
> 清华大学
>
> https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/
>
> 
>
> 分享：https://zhuanlan.zhihu.com/p/113554606



## 2、添加**kubernetes**的**key**

随便选一个

~~~shell
# 谷歌官方的
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# 阿里云镜像
curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
# 华为云镜像
curl -s https://repo.huaweicloud.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
~~~



## 3、安装**kubernetes**

~~~shell
# 由于添加了新源，先更新索引
sudo apt update
# 安装adm、let和ctl，貌似也不太稳定，可能会失败，多安装几次
sudo apt install -y kubeadm=1.20.0-00 kubelet=1.20.0-00 kubectl=1.20.0-00
~~~



安装好了后，关闭该虚拟机，该虚拟机作为Kubernetes_Base。



## 4、安装Kubernetes Master

首先基于Kubernetes_Base完整克隆一个虚拟机，内核数设置为2，然后安装：



### 1、命令行安装（推荐）

~~~shell
kubeadm init --apiserver-advertise-address=10.211.55.30 \
--apiserver-bind-port=6443 \
--image-repository=registry.aliyuncs.com/google_containers \
--kubernetes-version=v1.20.0 \
--pod-network-cidr=10.20.0.0/16 \
--service-cidr=10.30.0.0/16 \
~~~





### 2、配置文件安装

~~~shell
# 得到初始化配置文件
kubeadm config print init-defaults > init.default.yaml

# 改名备用
mv init.default.yaml init-config.yaml

# 安装时需要拉取google images，修改配置文件中的imageRepository = registry.aliyuncs.com/google_containers,也可以执行init前自己pull
# 修改advertiseAddress为自己的IP:踩坑一次
vim init-config.yaml

# 安装master,虚拟机核心数得大于1
# 关闭swap
sudo swapoff -a
kubeadm init --config=init-config.yaml --pod-network-cidr=10.100.0.0/16
~~~



master的配置文件：

~~~yaml
apiVersion: kubeadm.k8s.io/v1beta2
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: 可指定token
  ttl: 24h0m0s 过期时间，默认24小时
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 改成自己的
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: ubuntu
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta2
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns:
  type: CoreDNS
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.aliyuncs.com/google_containers # 镜像仓库
kind: ClusterConfiguration
kubernetesVersion: v1.20.0 # 版本
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}
~~~

具体设置详情见：https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-init/



> 问题1: running with swap on is not supported. Please disable swap
>
> 解决：1、sudo swapoff -a	2、vim /etc/fstab注释掉swap
>
> 
>
> 问题2：Initial timeout of 40s passed，依据提示，执行docker ps -a | grep kube | grep -v pause查看是那个容器没有启动，然后docker logs CONTAINERID看看容器启动日志定位
>
> 解决：遇到过一次，发现是etcd的容器启动失败了，在绑定一个1.2.3.4的IP，发现是init配置文件中没有配置本地IP导致的问题，修改后重新安装
>
> ```shell
> # 重新安装流程
> # 重置集群,master和node都能使用该命令进行重制
> sudo kubeadm reset
> sudo rm -rf .kube/
> sudo rm -rf /etc/kubernetes/
> sudo rm -rf /var/lib/kubelet/
> sudo rm -rf /var/lib/etcd
> # 重新安装
> kubeadm init --config=init-config.yaml
> ```



当显示即成功了:

~~~
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join xxx.xxx.xxx.xxx:6443 --token prtagk.ipmglnx9pjv2lvzj \
    --discovery-token-ca-cert-hash sha256:64e0885f8b3e0b5f406cba24a50e4403470fd8ab5c33044632051464d672c7a7 
~~~



## 5、保存配置

~~~shell
# 执行成功初始化后提示的命令，配置就保存到了当前用户目录下的.kube/config文件里
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 保存上面提示加入集群的连接信息
~~~



## 6、安装Kubernetes Node

基于Kubernetes_Base镜像克隆一个虚拟机

新建配置join-config.yaml:

~~~yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: JoinConfiguration
discovery:
  bootstrapToken:
    apiServerEndpoint: master结点IP:端口
    token: master结点token
    unsafeSkipCAVerification: true
  tlsBootstrapToken: master结点token
~~~

Node结点加入Master

~~~shell
kubeadm join --config=join-config.yaml
~~~



也可以直接使用master结点安装成功后提供的连接串进行连接。

~~~shell
kubeadm join 172.16.185.135:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:157552f7309244372f07a7e8430dbf2ca845b90a5250fe158d4d54da41fae11e
~~~



Join具体设置详情见：https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-join/



打印以下内容即为成功

~~~log
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
~~~



> 问题1:执行kubectl get nodes返回The connection to the server localhost:8080 was refused - did you specify the right host or port?
>
> 解决：你没有执行5、保存配置
>
> 问题2:Token忘了，进入master执行下面命令进行查看
>
> ~~~shell
> kubeadm token list
> ~~~



## 7、安装网络插件

执行kubectl get nodes显示notready，因为没有安装CNI网络插件

安装(Master):

~~~shell
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
~~~

node变成ready了,安装完成，复制几个Node就OK了。



> 插件位置：/etc/cni/net.d/





## 8、测试调度和访问

1、新建一个tomcat_rc：

~~~yaml
apiVersion: v1
kind: ReplicationController  # 副本控制器RC
metadata:
  name: mytomcat  # RC的名称，全局唯一
spec:
  replicas: 2   # Pod副本的期待数量
  selector:
    app: mytomcat  # 符合目标的pod拥有此标签,===1此处应当一致
  template:     # 根据此模板创建pod的副本
    metadata:
      labels:
        app: mytomcat  # pod副本拥有的标签,===1此处应当一致
    spec:
      containers:        # pod中容器的定义部分
      - name: mytomcat   # 容器名称
        image: tomcat  # 容器对应的docker镜像
        ports:
          - containerPort: 8080   # 容器应用监听的端口号
~~~



2、新建一个tomcat_service：

~~~yaml
apiVersion: v1
kind: Service  # 表明是 Kubernets Service
metadata:
  name: mytomcat  # Service的名称，全局唯一
spec:
  type: NodePort  # 使用Node结点IP+端口的方式暴露给外部调用
  selector:
    app: mytomcat  # 符合目标的pod拥有此标签,===1此处应当一致
  ports:
    - port: 8080  # Service提供服务的端口号
      nodePort: 30001 # 暴露给外部的端口，范围在30000-32767
~~~



3、使用kubectl创建

~~~shell
# 创建RC
kubectl create -f mytomcat_rc.yaml
# 创建Service
kubectl create -f mytomcat_service.yaml
~~~



通过kubectl describe pods和kubectl get svc查看是否创建成功，创建成功后可以查看pod分配到那台node结点上。

由于我们服务暴露的方式是NodePort，我们可以通过任意node或master的IP地址+30001端口进行访问。



4、查看RC和service

~~~shell
kubectl get rc
kubectl get svc
~~~



4、删除RC和service

~~~shell
kubectl delete rc mytomcat
kubectl delete service mytomcat
~~~
