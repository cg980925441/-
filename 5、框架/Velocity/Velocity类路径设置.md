Velocity设置类路径：

~~~java
ve.setProperty(RuntimeConstants.RESOURCE_LOADER,"classpath");
ve.setProperty("classpath.resource.loader.class", ClasspathResourceLoader.class.getName());
~~~

