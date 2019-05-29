[TOC]



### 1.指定Maven项目的jdk版本

#### 1.setting.xml

maven安装目录下config文件夹下的setting.xml文件中加入：

~~~ xml
<profile>    
    <id>jdk-1.8</id>    
    <activation>    
        <activeByDefault>true</activeByDefault>    
        <jdk>1.8</jdk>    
    </activation>    
    <properties>    
        <maven.compiler.source>1.8</maven.compiler.source>    
        <maven.compiler.target>1.8</maven.compiler.target>    
        <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>    
    </properties>    
</profile>
~~~



#### 2.项目pom文件

~~~ xml
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.1</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                </configuration>
            </plugin>
        </plugins>
    </build>

~~~



apache的maven编译器插件版本从3.0开始，默认编译器是javax.tools.JavaCompiler。2019-5-16，最新版本是3.8.1。



### 2.指定Maven仓库

下载的依赖的本地存储路径

~~~ xml
<localRepository>F:\tools\repository_local</localRepository>
~~~



### 3.指定镜像服务器

默认的maven仓库，可能由于网络环境的问题导致某些依赖无法下载，我们可以指定镜像服务器，当在maven主仓库中无法下载到时，从镜像服务器中下载。

#### 1、setting.xml

这里使用阿里云的maven镜像服务器。

~~~ xml
<mirror>
    <id>aliyun</id>
    <name>Nexus aliyun</name>
    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
    <mirrorOf>central</mirrorOf>
</mirror>
~~~

这里mirrorOf代表为那个仓库设置镜像，central是maven默认的远程仓库，我们可以指定覆盖默认的仓库，也可以使用*代表覆盖所有的仓库。



#### 2、远程仓库探究

在maven安装目录bin\maven-model-builder-{version}.jar文件中，pom-4.0.0.xml文件中就有maven的默认远程仓库的设置。这个文件是所有pom文件的父pom。

~~~ xml
<repositories>
    <repository>
      <id>central</id>
      <name>Central Repository</name>
      <url>https://repo.maven.apache.org/maven2</url>
      <layout>default</layout>
      <snapshots>
        <enabled>false</enabled>
      </snapshots>
    </repository>
  </repositories>

  <pluginRepositories>
    <pluginRepository>
      <id>central</id>
      <name>Central Repository</name>
      <url>https://repo.maven.apache.org/maven2</url>
      <layout>default</layout>
      <snapshots>
        <enabled>false</enabled>
      </snapshots>
      <releases>
        <updatePolicy>never</updatePolicy>
      </releases>
    </pluginRepository>
  </pluginRepositories>
~~~

从上我们可以看出，maven默认配置

<id>central</id>
<name>Central Repository</name>
<url>https://repo.maven.apache.org/maven2</url>

我们在自己的项目中添加一个仓库，覆盖它的id即可实现覆盖。



其中有两个大标签

- repositories：内部可以有多个repository，一个repository代表一个远程仓库。
- pluginRepositories：Maven的行为都由插件进行完成，这个代表maven的插件仓库，这个与repositories类似。



在每一个仓库中还有snapshots和releases标签，snapshots表示不稳定，正在开发中的版本；而releases表示稳定的版本。



#### 3、项目pom文件

有时maven设置中的镜像不管用，我们可以在项目的pom文件中设置远程仓库。

即在当前maven项目的pom文件中加入上面代码，修改远程仓库的url。



### 4.Maven pom文件定义常量

~~~ xml
<!--定义常量-->
<properties>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <java.version>1.8</java.version>
    <resource.delimiter>@</resource.delimiter>
    <maven.compiler.source>${java.version}</maven.compiler.source>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.target>${java.version}</maven.compiler.target>
</properties>

<!--引用常量-->
${java.version}

~~~



### 5、IDEA设置默认maven

在IDEA中如果在setting中指定maven路径，那么在下一次创建和导入项目时，maven设置会被还原。

解决方法：在IDEA欢迎界面，Configure->Project Defaults->setting->Maven设置maven路径。



### 6、dependency标签中的scope

主要管理依赖的部署。目前<scope>可以使用5个值： * compile，缺省值，适用于所有阶段，会随着项目一起发布。 

* compile，缺省值，**适用于所有阶段，会随着项目一起发布**。 

* provided，类似compile，期望JDK、容器或使用者会提供这个依赖。如servlet.jar。 
* runtime，**只在运行时使用**，如JDBC驱动，适用运行和测试阶段。 
* test，只在测试时使用，用于编译和运行测试代码。**不会随项目发布**。 
* system，类似provided，**需要显式提供包含依赖的jar**，Maven不会在Repository中查找它。 

