### 1、分页

Oracle的分页使用**rownum**伪列的方式实现，MySQL通过关键字**LIMIT**实现。

#### 1、Rownum

oracle中每次查询后，每条记录都对应一个rownum字段，该字段相当于每一条记录在结果集中的序号。

我们可以通过指定该序号即可实现分页功能，对rownum字段的操作有如下限制：

- 对于rownum字段只能使用逻辑运算符：< <= 无法使用> >= 。	
- =在rownum中，大于1的数都会返回false。
- rownum的索引从1开始。
- 不能以任何表的名称作为前缀。

使用方法：

~~~ plsql
select * from (
    select t.*,rownum rn
    from emp t where rn < 上限
) where rn > 下限
~~~



#### 2、LIMIT

limit是MySQL中特有的关键字，可以很方便的实现分页功能。

**LIMIT [开始索引],[偏移]**

使用该关键字需要注意的点如下：

- 开始索引从0开始。
- 偏移可以指定为-1，表示从开始索引到结束索引。
- 可以只写一个参数，表示从开始到索引



~~~ mysql
select * from emp LIMIT 0,5	--查询前5条
select * from emp LIMIT 5,-1 --查询第5到最后一条
select * from emo LIMIT 5	--查询前5条
~~~





### 2、主键

在Oracle中，主键可以使用Sequence指定；而在MySQL中可以指定主键为自增，sql中使用default指定。



优点：MySQL的主键机制比Oracle的更加简单，只需要在创建表的时候指定主键为自增，在插入记录的时候指定主键字段的值为default即可；而Oracle需要创建一个sequence，通过sequence的nextval方法指定主键值。

缺点：如果遇到需要插入两张有关联的表，且插入第二张表时需要指定第一张表的主键值时，MySQL就需要再进行一次查询；而Oracle可以通过定义变量，存储sequence获取到的值，在插入第二张表时取出变量的值即可。



#### Oracle定义变量

~~~ plsql
declare
   变量名 类型 := 20;--直接赋值
   var2 integer;

 begin
 	select 字段 into var2 from 表名;--使用select into 进行赋值
 end;
~~~

