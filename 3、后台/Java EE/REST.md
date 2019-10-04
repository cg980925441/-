[TOC]



### 1、REST

REST是一种架构风格，Java在J2EE引入了对REST的支持，即javax.ws.rs包下，定义了一套REST接口规范，包含接口和类。

这是一套接口，只用于指定规范，具体的实现由第三方提供。



#### 1、J2EE标准

##### 1、增删改查

@POST，@GET，@PUT，@DELETE四个注解代表了对资源的CRUD操作。



##### 2、定位资源

- @Path（"\user"）：标识要请求的资源类或类方法的uri路径。

- @Produces（MediaType.APPLICATION_JSON）：标识返回值类型。

- @PathParam("userName")：标识参数绑定。

- *@CookieParam*("JSESSIONID")：将cookie中的值取出绑定到参数。

- @HeaderParam("Accept")：将HTTP Header中的值取出绑定到参数。

- *@MatrixParam*("userName") String userName：

  对于url传承形式为：*localhost:8080/root/user/getUser**;userName=boglond;age=26***

  时，用于区分参数使用的注解。

~~~ java
@Path("/user")
public class UserResource {
 @GET
 @Path("/getUser")
 @Produces(MediaType.APPLICATION_JSON)
 public User getUser(@CookieParam("JSESSIONID") String jsessionId，
                     @HeaderParam("Accept") String accept
                     @PathParam("userName") String userName) {
 ...
 }
}
~~~

从上面例子，如果我们访问项目，如果是+user就能访问到这个类，再加上用户名且是GET请求就可访问到这个方法，返回值会以Json格式传出，第三方应用实现了它，我们只需要指定它是如何使用即可。因为这是J2ee的标准，只要有第三方应用实现了，我们就可以这样使用。



##### 3、表单传递对象

如果前端使用表单的形式传来一组数据，我们可以使用下面注解将这些数据封装为一个对象

-  *@Consumes*(MediaType.APPLICATION_FORM_URLENCODED)：标识该方法接收表单传入的对象参数。
- *@BeanParam*：将请求中的数据绑定到Java Bean对象中。
- @javax.xml.bind.annotation.XmlRootElement：标识该类与请求中的字段一一对应，可以进行映射。
- *@FormParam*("userName")：标识该字段与请求中的字段映射关系。



Bean：

~~~ java
@javax.xml.bind.annotation.XmlRootElement
public class UserBean{
 @FormParam("userName")
 private String userName;
 @FormParam("age")
 private int age;
 ...
}
~~~

Controller:

~~~ java
@Path("/user")
public class UserRecource {
 @javax.ws.rs.POST
 @Path("/insertUserBean")
 @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
 public String insertUserBean(@BeanParam UserBean userBean){
 ...
 }
}
~~~





##### 5、返回值类型

Produces的取值有以下几种类型：

~~~ properties
text/html ： HTML格式
text/plain ：纯文本格式
text/xml ：  XML格式(它会忽略xml头所指定编码格式而默认采用us-ascii编码)
image/gif ：gif图片格式
image/jpeg ：jpg图片格式
image/png：png图片格式
application/xhtml+xml ：XHTML格式
application/xml     ： XML格式(它会根据xml头指定的编码格式来编码)
application/atom+xml  ：Atom XML聚合格式
application/json    ： JSON数据格式
application/pdf       ：pdf格式
application/msword  ： Word文档格式
application/octet-stream ： 二进制流数据（如常见的文件下载）
application/x-www-form-urlencoded ： &lt;form encType=””&gt;中默认的encType，form表单数据被编码为key/value格式发送到服务器（表单默认的提交数据的格式）
multipart/form-data ： 需要在表单中进行文件上传时，就需要使用该格式。
~~~



