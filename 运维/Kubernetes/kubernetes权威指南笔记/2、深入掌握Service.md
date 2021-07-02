# 2、深入掌握Service

Service是Kubernetes中访问应用容器的入口，可以为一组相同功能容器提供一个统一的入口地址，提供负载均衡服务。

关键：服务访问入口、负载均衡、一组容器



## 1、基本用法

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
---
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



### 1、根据RC快速创建Service

~~~shell
kubectl expose rc [rc-name]
~~~

