### 1.指定Maven项目的jdk版本

#### 1.Maven软件的配置文件指定

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



#### 2.Maven项目中的pom文件指定

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

默认的maven仓库，可能由于网络环境的问题导致某些依赖无法下载，我们可以指定镜像服务器，当在maven主仓库中无法下载到时，从镜像服务器中下载。这里使用阿里云的maven镜像服务器。

~~~ xml
    <mirror>
      <id>aliyun</id>
      <name>Nexus aliyun</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
~~~





## 4.Maven pom文件定义常量

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

