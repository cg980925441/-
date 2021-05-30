# Kubernets DashBoard

GitHub：https://github.com/kubernetes/dashboard



## 1、下载

从github下载yaml，然后进行修改

~~~shell
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
~~~



1、镜像地址改为阿里云的

1、registry.aliyuncs.com/google_containers

2、registry.cn-hangzhou.aliyuncs.com/ccgg



2、访问方式改为NodePort

~~~yaml
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard ## 注意名称
  namespace: kubernetes-dashboard
spec:
  type: NodePort ## 添加修改
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 30001 ## 添加修改
  selector:
    k8s-app: kubernetes-dashboard
~~~





## 2、启动pod

~~~shell
# 启动
kubectl create -f recommended.yaml
# 查看pod是否启动成功
kubectl get pods -n kubernetes-dashboard
~~~





## 3、创建访问用户

Github地址：https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md



~~~yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
~~~



## 4、得到token

~~~shell
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
~~~



## 5、访问

选择Token，输入上面得到的token即可进行访问了。
