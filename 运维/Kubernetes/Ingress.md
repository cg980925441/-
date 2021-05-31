# Ingress

## 1、安装启动Ingress



> https://kubernetes.github.io/ingress-nginx/deploy/



里面有个谷歌的镜像无法下载，可以使用dockerhub中的镜像。

~~~shell
docker pull acicn/ingress-nginx-controller:v0.46.0
~~~





## 2、创建Ingress



> https://kubernetes.io/docs/concepts/services-networking/ingress/



~~~yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: mynginx
            port:
              number: 80
~~~



## 3、启动一个nginx

nginx有一个pod和一个service，service的类型是clusterIP。

我们通过NodeIP访问nginx-ingress-controller然后路由到指定的nginx，即可访问指定的nginx了。



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
---
apiVersion: v1
kind: Service  # 表明是 Kubernets Service
metadata:
  name: mynginx  # Service的名称，全局唯一
spec:
  type: ClusterIP  # 使用Node结点IP+端口的方式暴露给外部调用
  selector:
    app: mynginx  # 符合目标的pod拥有此标签,===1此处应当一致
  ports:
    - port: 80  # Service提供服务的端口号
~~~

