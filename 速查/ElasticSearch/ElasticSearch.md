# 1、常用操作

**Tips：官方推荐一个index一个type，所以可以省略type。**



1、查询所有

~~~
GET _all
~~~



2、创建索引

~~~
PUT 索引名称
~~~

​	

3、删除索引

~~~
DELETE 索引名称
~~~



4、新增数据

~~~
PUT index/_doc/id

Body:
数据的json串
~~~

第二个参数是type，官方推荐一个index一个type，所以可以使用_doc代替；第三个参数是数据的id；Body里面存放具体的数据内容。



5、搜索数据

~~~
GET index/_doc/id
~~~

根据ID查询对应的数据



6、内容搜索

postman：

~~~
GET index/_doc/_search?q=key:value
~~~

查询所有数据中，key=value的数据



kibana：

~~~json
POST /blog/_search
{
  "query": {
    "bool":{
      "should": [
        {
          "match": {
            "name": "zhangsan"
          }
        }
      ]
    }
  }
}
~~~

Should：类似于Mysql中的or

Must：类似于Mysql中的and



7、查看统计

~~~
GET /index名称/_stats
~~~



# 2、java代码实现



