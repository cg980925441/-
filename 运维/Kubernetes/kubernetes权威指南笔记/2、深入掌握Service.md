# 2、深入掌握Service

Service是Kubernetes中访问应用容器的入口，可以为一组相同功能容器提供一个统一的入口地址，提供负载均衡服务。

关键：服务访问入口、负载均衡、一组容器



## 1、基本用法

~~~yaml
apiVersion: v1
kind: ReplicationController  # 副本控制器RC
metadata:
  name: nginx  # RC的名称，全局唯一
spec:
  replicas: 2   # Pod副本的期待数量
  selector:
    app: nginx  # 符合目标的pod拥有此标签,===1此处应当一致
  template:     # 根据此模板创建pod的副本
    metadata:
      labels:
        app: nginx  # pod副本拥有的标签,===1此处应当一致
    spec:
      initContainers:
        - name: init-nginx-index
          image: busybox
          # 将百度主页下载到/work-dir/下
          command:
            - /bin/sh
            - -c
            - 'ls /; echo "this is $(hostname)" > /work-dir/index.html; ls /;'
          volumeMounts:
            - name: workdir
              mountPath: /work-dir
      containers:
      - name: nginx
        image: nginx
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        ports:
          - containerPort: 80
        volumeMounts:
            - name: workdir
              mountPath: /usr/share/nginx/html
      volumes:
        - name: workdir
          emptyDir: {}
---
apiVersion: v1
kind: Service  # 表明是 Kubernets Service
metadata:
  name: nginx  # Service的名称，全局唯一
spec:
  type: NodePort  # 使用Node结点IP+端口的方式暴露给外部调用
  selector:
    app: nginx  # 符合目标的pod拥有此标签,===1此处应当一致
  ports:
    - port: 80  # Service提供服务的端口号
      nodePort: 30001 # 暴露给外部的端口，范围在30000-32767
~~~



### 1、根据RC快速创建Service

~~~shell
kubectl expose rc [rc-name]
~~~



### 2、多端口Service

一个容器应用可以暴露多个端口服务，一个Service也能映射多个端口

1、一个Service映射容器多个端口也可以映射不同协议

~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP # 协议
      port: 80 # Servcice的虚拟端口号
      targetPort: 9376 # 后端Pod的端口号
    - protocol: TCP
      port: 80
      targetPort: 9376
~~~



2、一个Service映射同一端口的



### 3、负载策略

1、默认是轮训（每个IP都是独立的轮训）

2、设置基于IP的会话保持

~~~yaml
apiVersion: v1
kind: Service  # 表明是 Kubernets Service
metadata:
  name: nginx  # Service的名称，全局唯一
spec:
  type: NodePort  # 使用Node结点IP+端口的方式暴露给外部调用
  selector:
    app: nginx  # 符合目标的pod拥有此标签,===1此处应当一致
  ports:
    - port: 80  # Service提供服务的端口号
      nodePort: 30001 # 暴露给外部的端口，范围在30000-32767
  sessionAffinity: ClientIP # 启用sessionAffinity策略，同一IP会被转发到固定的某个Pod上
~~~

