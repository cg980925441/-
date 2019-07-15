[TOC]



# 1、SpringBoot入门

## 1.简介

SpringBoot是用于**简化Spring应用开发的一个框架**。

在原始的Spring开发过程中，我们需要编写大量的配置文件，导入相关的jar包，而这些都是模式化的操作，繁琐而没有意义。所以SpringBoot整合了我们在开发过程中所需要的所有相关配置和jar包，我们只需要选择，即可帮助我们自动生成配置。



## 2.SpringBoot的优点

- 快速创建项目。
- 嵌入式Servlet容器，程序打成jar包直接运行。

- starters自动依赖与版本控制
- 大量自动配置
- 无需配置XML文件
- 运行时应用监控
- 与云计算的天然集成



# 2、SpringBoot HelloWorld

## 1.不使用工具创建

### 1.创建一个maven工程

### 2.导入SpringBoot相关依赖

~~~ xml
<!--自动依赖与版本控制-->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.4.RELEASE</version>
</parent>

<!--springBoot依赖，版本由parent指定-->
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>

<!--指定jdk版本，这里只是一个类似于常量定义，某些地方可能用到了这个常量-->
<properties>
    <java.version>1.8</java.version>
</properties>

<!--springBoot编译插件，将SpringBoot应用打成jar包-->
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
~~~

### 3.编写一个主程序，启动SpringBoot应用

~~~ java
package com.zanpo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @SpringBootApplication 标注这是一个SpringBoot应用
 */
@SpringBootApplication
public class HelloWorldApplication {
    public static void main(String[] args) {

        //启动SpringBoot应用
        SpringApplication.run(HelloWorldApplication.class);
    }
}
~~~



### 4.编写一个Controller、Service

~~~ java
package com.zanpo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @Controller 标注这是一个Controller,将它交给Spring容器管理
 */
@Controller
public class TestController {

    @ResponseBody
    @RequestMapping("/Hello")
    public String Test(){
        return "HelloWorld";
    }
}

~~~

### 5.运行测试

浏览器访问：<http://localhost:8080/Hello>，这里不需要指定项目名。



### 6.项目部署

由于我们在maven项目的pom文件中导入了springBoot的编译插件，我们可以直接将应用打成一个jar包，直接运行。

> 执行maven->Lifecycle->package命令
>
> 通过java -jar jar包路径名 即可执行jar包



## 2.使用IDE创建

### 1.项目结构

> 1.static	放置web项目中的静态资源，类似于webContent
>
> 2.template	放置模板页面，由于springBoot使用嵌入式的tomcat服务器，所以不支持jsp，可以通过模板引擎实现jsp页面的支持
>
> 3.application.properties	springboot的全局配置文件，可以通过该配置文件修改springboot的一些默认配置，例如tomcat服务器的端口号就是 server.port进行修改



### 2.配置文件

SpringBoot支持两种格式的配置文件，properties和yml。





# 3、探究

## 1.POM文件

### 1.父项目

在SpringBoot的maven项目中，我们发现可以不用指定依赖的版本号，这是因为SpringBoot帮我们管理了所有依赖的版本。

~~~ xml
<!--SpringBoot中的parent-->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.4.RELEASE</version>
</parent>

<!--点开parent-->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-dependencies</artifactId>
    <version>2.1.4.RELEASE</version>
    <relativePath>../../spring-boot-dependencies</relativePath>
</parent>

<!--继续点开-->
<properties>
<activemq.version>5.15.9</activemq.version>
...
<xmlunit2.version>2.6.2</xmlunit2.version>
</properties>
~~~

我们可以看到springBoot帮我们管理了我们可能导入的所有依赖版本，**如果我们需要导入的jar包在SpringBoot中没有进行管理,就需要我们自己指定版本号**。



### 2.启动器

~~~ xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>

<!--点开后可以看到-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
    <version>2.1.4.RELEASE</version>
    <scope>compile</scope>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-json</artifactId>
    <version>2.1.4.RELEASE</version>
    <scope>compile</scope>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-tomcat</artifactId>
    <version>2.1.4.RELEASE</version>
    <scope>compile</scope>
</dependency>
<dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>6.0.16.Final</version>
    <scope>compile</scope>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-web</artifactId>
    <version>5.1.6.RELEASE</version>
    <scope>compile</scope>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.1.6.RELEASE</version>
    <scope>compile</scope>
</dependency>
~~~

**spring-boot-starter**-web

​	spring-boot-starter是一个场景启动器：帮我们导入了web模块正常运行所需要的组件。



Web开发模块自动帮我们导入了：

- spring-boot-starter
- spring-boot-starter-json
- spring-boot-starter-tomcat
- hibernate-validator
- spring-web
- spring-webmvc

我们开发的时候，只用导入相关场景的启动器即可，相关依赖会由SpringBoot为我们自动导入。



## 2.自动配置

### 1.包扫描

在主应用程序上添加了@SpringBootApplication注解

~~~ java
//该注解是一个组合注解
//自动配置由 @EnableAutoConfiguration 注解实现
@SpringBootConfiguration
@EnableAutoConfiguration

//点进去，还是一个组合注解
//@AutoConfigurationPackage 指定包扫描的配置
@AutoConfigurationPackage
@Import(AutoConfigurationImportSelector.class)

//点进去
//它是由Registrar类进行包扫描路径的指定
@Import(AutoConfigurationPackages.Registrar.class)

//点进去
//它由该方法进行设置包扫描的路径
@Override
public void registerBeanDefinitions(AnnotationMetadata metadata,
                                    BeanDefinitionRegistry registry) {
    register(registry, new PackageImport(metadata).getPackageName());
}

//它得到标注了SpringBootApplication注解的类的包名，并将该包名指定为包扫描的路径

~~~

结论：**自动配置的包扫描路径为标记了SpringBootApplication注解的类所在包**。



### 2. 组件的自动配置





# 4、配置文件

## 1.xml方式

SpringBoot中也可以使用xml配置文件的方式，即通过@ImportResource注解导入配置文件。但是SpringBoot官方不推荐这种方式。



## 2.配置类

相关注解：

@Configuration：指明该类是一个配置类，对应xml配置文件。

@Bean：对应xml配置文件的bean标签

~~~ java
@Configuration
public class Config {

    @Bean
    public HelloService helloService(){
        return new HelloService();
    }
}
~~~

方法名就是id

## 3.占位符

### 1.随机数

~~~ properties
person.name=zhaoliu${random.uuid}
person.age=${random.int}
~~~

### 2.默认值

~~~ properties
person.name=zhaoliu${person.hello:hello}
person.age=${random.int}
~~~

### 3.之前配置的值

~~~ properties
person.age=${random.int}
person.name=zhaoliu${person.age}
~~~



## 4.配置文件目录优先级

1.file:config/

2.file:

3.classpath:config/

4.classpath:

**优先级由高到低，高优先级的配置会覆盖低优先级的配置**



# 5、Profile

对于不同的环境使用不同的配置文件。

配置文件命名：application-环境名自己取.properties/yml



## 1.Properties文件

默认的配置文件是：application.properties/yml



在默认配置文件中加入

~~~ properties
spring.profiles.active=debug
~~~

即可让SpringBoot加载对应环境的配置文件。



## 2.yaml文件

```yaml
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
```



## 3.命令行

--spring.profiles.active=xxx





