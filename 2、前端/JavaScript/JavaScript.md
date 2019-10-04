# 1、数组

## 1、创建

~~~ js
var arr = new Array();

//指定数组容量
var arr = new Array(3);

//指定数组初始元素
var arr = new Array("1","3","5");
~~~



## 2、遍历

~~~ js
var arr = new Array(1,2,3);

for(var i = 0;i < arr.length;i++){
    console.log(arr[i]);
}
~~~



# 2、字符串

## 1、长度

长度是属性而不是方法

~~~ js
var str = "hello world";
var length = str.length;
~~~



## 2、提取字符串

~~~js
//字符串提取
slice(start, end)
substring(start, end)
substr(start, length)

//单个字符提取
var s = "Hello";
s.charAt(0);
~~~



## 3、是否相等

~~~ js
var s = "Hello";
s === "Hello";

//字符串与整数类型的大小比较可自动转型

~~~



## 4、与基本数据类型转换

~~~ js
var s = "123456";
// 字符串转整数
var num = parseInt(s);
// 整数转字符串
s = num + "";
~~~

