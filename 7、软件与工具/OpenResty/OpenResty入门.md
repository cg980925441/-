# 1、简介

OpenResty = Nginx + Lua Jit。

简单，性能与Nginx C Module接近。





# 2、安装

> http://openresty.org/

类Unix：编译安装

windows：下载安装



# 3、HelloWorld

1、Nginx配置文件里面写lua代码

~~~nginx
location /hello {
    default_type text/html;
	content_by_lua_block {
		ngx.say("<p>hello, world</p>")
	}
}
~~~



2、Nginx配置文件里面引用Lua文件

~~~nginx
location /hello {
    default_type text/html;
    content_by_lua_file mylua/hello.lua
}
~~~



3、Nginx配置文件中嵌入Lua

~~~nginx
location /hello {
    set $target '';
    access_by_lua '
        # TODO:从Redis中取出对应上下文根和域名对应的机器
        local url = "http://www.baidu.com/";
    	ngx.var.target = url;
    ';

    # 转发到对应机器上
    proxy_pass $target;
}
~~~





tip：lua_code_cache指令关闭缓存，默认是开启，调试时可以开启，每次nginx都会读取配置文件。

tip2：default_type text/html;指定返回值类型。





# 4、根据参数生成随机数

~~~lua
-- 取uri中的参数
local args = ngx.req.get_uri_args()
-- 取salt参数
local salt = args.salt
-- 不存在返回400
if not salt then 
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

-- 调用Ngx的时间和md5函数生成随机数(32位)
local random = ngx.md5(salt .. ngx.time())
ngx.say(random)
~~~