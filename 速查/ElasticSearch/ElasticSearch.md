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



7、查看状态

~~~
GET /index名称/_stats
~~~



8、索引

~~~json
查看索引索引状态
GET http://localhost:9200/_cat/indices

打开索引
POST http://localhost:9200/索引名称/_open
~~~



# 2、分词器

| 分词器      | 中文支持 |        |                        |
| ----------- | -------- | ------ | ---------------------- |
| standard    | Y        | 默认   | 中文单字拆分           |
| simple      | N        | 内置   | 转小写，非字母字符拆分 |
| whitespace  | N        | 内置   | 通过空格分割           |
| language    | N        | 内置   | 特点语言               |
| ik_smart    | Y        | 第三方 | 根据字典智能拆分       |
| ik_max_word | Y        | 第三方 | 最大单词               |



1、指定分词器

~~~json
POST _analyze
{
	"analyzer":"standard"	
	"text":""
}
~~~



2、安装分词器

1、github下载ik分词器

2、解压到plugin文件夹，新建ik目录

# 2、java代码实现

1、entity

~~~java
@Document(indexName = "blog",type = "doc",createIndex = false,useServerConfiguration = true)
public class EsBlog {
    @Id
    Integer id;
    @Field(type = FieldType.Text,analyzer = "ik_max_word")
    String title;
    @Field(type = FieldType.Text,analyzer = "ik_max_word")
    String author;
    @Field(type = FieldType.Text,analyzer = "ik_max_word")
    String content;
    @Field(type = FieldType.Date,format = DateFormat.custom,pattern = "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis")
    Date createDate;
    @Field(type = FieldType.Date,format = DateFormat.custom,pattern = "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis")
    Date updateDate;
}
~~~



2、repository

~~~java
public interface EsBlogRepository extends ElasticsearchRepository<EsBlog,Integer> {
    List<EsBlog> findByTitleOrContent(String title, String content, Pageable pageable);
}
~~~



3、controller

~~~java
BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
boolQueryBuilder.should(QueryBuilders.matchPhraseQuery("title",params.getKeyword()));
boolQueryBuilder.should(QueryBuilders.matchPhraseQuery("content",params.getKeyword()));
Page<EsBlog> search = (Page<EsBlog>) esBlogRepository.search(boolQueryBuilder);
resultMap.put("list",search.getContent());
~~~

