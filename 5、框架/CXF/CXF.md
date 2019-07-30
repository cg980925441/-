1、参数传递

JAX-RS规定参数封装（后台解析前端参数）通过以下两种方式完成：

- 参数bean有一个接收String的公共构造函数
- 参数bean有一个静态valueOf(String)方法

例如：前端传过来的日期类型参数，后台会以Date(String)的构造函数进行解析

Date.valueOf可以接收yyyy-MM-dd类型的字符串参数