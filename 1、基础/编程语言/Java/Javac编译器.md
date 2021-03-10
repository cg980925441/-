1、解析源文件得到一个JCTree对象

源文件JavaCompiler.java，方法：parseFiles



具体方法：parse得到一个JCTree对象





```java
JCCompilationUnit extends JCTree
```



首先通过词法分析得到一个Parser对象

然后通过调用Parser对象的方法得到一个JCTree语法对象





JCTree结构分析

defs：源代码中的类或者方法

sym：文件路径、类路径、源文件流



## 词法解析

JavaTokenizer对象中保存着一个源文件的字符流对象，调用readToken方法拿到源文件中的一个Token。

自动状态机的代码就在readToken方法中了。



### 1、自动状态机

1、首先判断第一个字符是什么，然后改变字符流指向下一个字符。



Lexer

-Tokens

--comment

---style

-pos标示开始位置

--endPos标识结束位置

-stream

--ch

--bp当执行scanChar时bp++，bp表示当前的断点代码

--sp当前标识的长度

--scanChar()

--scanComment()



Parse

-Lexer

-accept()如果下一个字符匹配给定的字符就跳过，否则报告一个错误



### 特殊字符处理

1、空格、制表符、回车、换行、分页都直接跳过



## token

关键字：一词一码

括号，加号，减号，分号：一词一码

标识符：一词多码



回车换行分页分为一类，处理方式：跳过

关键字和标识符使用一类方法统一处理，是否是关键字判断依据：1、包含小于等于\u0080的字符 2、

关键字和标识符分为四类：1、关键字 	2、命名	 3、数字字面值 	4、字符字面值

点单独处理



