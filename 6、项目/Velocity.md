## 1、HelloWorld

1、导入依赖：

~~~ xml
		<dependency>
            <groupId>apache-velocity</groupId>
            <artifactId>velocity</artifactId>
            <version>1.5</version>
        </dependency>
~~~



2、初始化，放入值：

~~~ java
		// 创建引擎，初始化
		VelocityEngine ve = new VelocityEngine();
        ve.setProperty(RuntimeConstants.RESOURCE_LOADER, "classpath");
        ve.setProperty("classpath.resource.loader.class", ClasspathResourceLoader.class.getName());
        ve.init();
		
		// 创建模板
        Template t = ve.getTemplate("Test.vm");

        // 创建上下文对象，依次放入普通值，日期值，集合
		VelocityContext ctx = new VelocityContext();
        ctx.put("Key","value");
        ctx.put("Key2",new Date().toString());
        List list = new ArrayList();
        list.add("1");
        list.add("2");
        list.add("3");
        ctx.put("list",list);

		// 写出文件
        StringWriter sw = new StringWriter();
        t.merge(ctx,sw);

        System.out.printf(sw.toString());
~~~



3、模板编写

~~~ vm
#set( $iAmVariable = "good!" )

Welcome $name to velocity.com

today is $date.
#foreach ($i in $list)
    $i
#end
$iAmVariable
~~~



1、变量定义：

~~~ vm
#set($name =“velocity”)
~~~



2、变量取值

~~~ vm
$name
~~~



3、集合遍历

~~~ vm
#foreach($i in $list)
	$i
#end
~~~



4、条件,运算符

```vm
#if(condition)
...
#elseif(condition)
…
#else
…
#end
```



5、宏

~~~ vm
#macro(macroName arg1 arg2 …)
...
#end
~~~



6、#parse 和 #include

~~~ vm
foo.vm 文件：
#set($name =“velocity”)

#parse(“foo.vm”)
输出结果为：velocity

#include(“foo.vm”)
输出结果为：#set($name =“velocity”)
~~~

