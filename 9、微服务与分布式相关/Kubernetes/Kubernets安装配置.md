# 1、使用kuberadm工具快速安装

## 1.1、安装kuberadm和相关工具

首先配置yum源，官方源地址由于墙的原因无法进行访问，可以使用aliyun的yum源。yum源的配置文件路径为：

/etc/yum.repos.d/kubernetes.repo

文件的内容改为:

~~~
[kubernetes]
name=Kubernetez
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=0
~~~



然后通过yum install命令安装kubeadm和相关工具

~~~shell
yum install -y kubelet kubectl --disableexcludes=kubernetes
~~~



并将docker和kubernetes的服务设置为开机启动

~~~shell
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet
~~~



## 1.2、kubeadm config

通过kubeadm config命令取得默认的初始化参数文件：

~~~shell
kubeadm config print init-defaults > init.default.yaml
~~~



将内容保存为init-config.yaml备用

~~~shell
mv init.default.yaml init-config.yaml
~~~



## 1.3、下载Kubernetes相关镜像

首先需要修改docker的镜像为aliyun，提高镜像拉取速度。docker的镜像配置文件为：

/etc/docker/daemon.json

将内容修改为:

~~~json
{
  "registry-mirrors": [
    "https://mirrors.aliyun.com/"
  ]
}
~~~



使用config images pull子命令下载所需镜像

~~~shell
kubeadm config images pull --config=init-config.yaml
~~~

这里指定config参数，为我们之前保存的配置文件。



发现拉取不了，无法访问k8s.gcr.io的网址。



我们可以使用azk8s拉取国内镜像中的k8s，然后修改tag。首先下载azk8s的脚本

~~~shell
#从github下载脚本
curl -Lo /usr/local/bin/azk8spull https://github.com/xuxinkun/littleTools/releases/download/v1.0.0/azk8spull
#赋予可执行权限
chmod +x /usr/local/bin/azk8spull
~~~

然后通过kubeadm config命令查看需要的镜像

~~~shell
kubeadm config images list
~~~

然后通过azk8spull将对应的镜像拉取下来

~~~shell
azk8spull k8s.gcr.io/kube-apiserver:v1.17.1
azk8spull k8s.gcr.io/kube-controller-manager:v1.17.1
azk8spull k8s.gcr.io/kube-scheduler:v1.17.1
azk8spull k8s.gcr.io/kube-proxy:v1.17.1
azk8spull k8s.gcr.io/pause:3.1
azk8spull k8s.gcr.io/etcd:3.4.3-0
azk8spull k8s.gcr.io/coredns:1.6.5
~~~



## 1.4、运行kubeadm init命令安装Master

执行

~~~shell
kubeadm init --config=init-config.yaml
~~~



发现报了一个错误，CPU数量至少要求两个，额，改为双核两G再运行，还是报错，和镜像拉取的一个问题，无法访问

k8s.gcr.io这个网址，在github上找到了解决方案。在初始化时指定镜像仓库地址。

执行：

~~~shell
kubeadm init --image-repository registry.aliyuncs.com/google_containers
~~~

成功后我们得到以下一些信息：

~~~log
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.16.185.130:6443 --token prtagk.ipmglnx9pjv2lvzj \
    --discovery-token-ca-cert-hash sha256:64e0885f8b3e0b5f406cba24a50e4403470fd8ab5c33044632051464d672c7a7 
~~~

这里提示我们想开始使用我们的集群，需要执行以下几行指令：

~~~shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
~~~

主要操作是创建一个一个目录，将配置文件拷贝到该目录下。

执行完成后，我们就已经创建了一个Master节点，但是还是缺少Node节点，而且缺乏对容器网络的配置。

在最后几行信息中，还有我们加入节点的指令和所需要的点token的信息。











