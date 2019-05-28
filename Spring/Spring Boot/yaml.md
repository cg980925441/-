# 1.概叙

YAML：一种标记语言，类似于xml；

**以数据为中心**，比xml，json更适合作配置文件。





# 2.语法

## 1.基本语法

### 1. 键值对表示

key:**空格**v

~~~ yaml
server:
  port: 8081
~~~



### 2.层级关系

使用空格表示层级关系，首行缩进空格相同的为同一级。

~~~ yaml
server:
  port: 8081
  path: /hello
~~~



### 3.大小写敏感



## 2.值的写法

​	字面量：数字，字符串，布尔

​			k: v	字面量直接写，字符串不用引号。

​			""：不会转义字符串

​			''：会转义字符串



对象：属性和值（键值对）

​		k: v	

​				直接通过键值对方式表示

普通写法：

~~~ yaml
student:
  name: zhangsan
  age: 18
~~~

行内写法：

~~~ yaml
student: {name: zhangsan,age: 18}
~~~



数组：List和Set

用-表示数组中的一个元素

普通写法：

~~~ yaml
pets: 
  - dog
  - pig
  - cat
~~~

行内写法：

~~~ yaml
pet: [cat,dog,pig]
~~~





# 3.文档块

~~~ yaml
server:
  port: 8081
spring:
  profiles:
    active: dbg
---
server:
  port: 8082
spring:
  profiles: dev
---
server:
     port: 8083
spring:
  profiles: dbg
~~~



