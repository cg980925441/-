# 1、模型

Openresty读取Redis中的规则，通过Lua设置进行反向代理





# 2、实现

通过Openresty的Redis模块根据server_name+上下文根读取到待反向代理的地址。



**note：前端资源直接通过server_name进行查询，且待反向代理的地址后面不跟斜杠**



~~~nginx
location / {
    # lua_code_cache off;
    # content_by_lua_file lua/hello.lua;

    set $target '';
    access_by_lua '
        -- 取URI
        local uri = ngx.var.request_uri;
    -- 取域名
        local server_name = ngx.var.server_name;

    -- 正则匹配上下文根
        local	regex	=	[[(^/.+?(?=/))|(^/.+(?<!/))]];
        local	context	=	ngx.re.match(uri,	regex,	"o");
        ngx.log(ngx.ERR, "uri = ", uri," context = ",context[0]);

        if not context then
        context = uri;
        end

        -- 拼接
        local url_name = server_name .. context[0];
        ngx.log(ngx.ERR, "path = ", url_name);

        -- 导入Redis库
        local redis = require "resty.redis"
        local red = redis:new()
        red:set_timeout(1000) --	1	sec
        -- 连接Redis
        local ok, err = red:connect("192.168.254.133", 6379)
        if not ok then
        ngx.say("failed	to	connect:	", err)
        return
        end
        local resp, err = red:get(url_name)
        if resp == ngx.null then
        -- 没拿到，不管了
        ngx.log(ngx.ERR, "url_name = ", url_name);
        ngx.var.target = server_name;
        else
        ngx.log(ngx.ERR, "redis = ", resp);
        local json = require("cjson");
        local t = json.decode(resp);
        ngx.var.target = t.hostname;
        end

        ngx.log(ngx.ERR, "target = ", ngx.var.target, " server_name = ",ngx.var.server_name);
        ';

        # 转发到对应机器上
        proxy_pass $target;
}
~~~

