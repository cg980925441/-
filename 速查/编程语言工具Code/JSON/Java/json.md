Maven依赖：

~~~xml
<dependency>
  <groupId>com.alibaba</groupId>
  <artifactId>fastjson</artifactId>
  <version>1.2.9</version>
</dependency>
~~~





工具类：

~~~java
package com.zanpo.it.util;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;

import java.util.Map;

public class JsonHelpper {

    /**
     * Json字符串格式化
     * @param jsonString
     * @return
     */
    public static String jsonFormat(String jsonString){
        JSONObject object= JSONObject.parseObject(jsonString);
        jsonString = JSON.toJSONString(object, SerializerFeature.PrettyFormat, SerializerFeature.WriteMapNullValue, SerializerFeature.WriteDateUseDateFormat);
        return jsonString;
    }

    /**
     * Map集合转为Json字符串
     * @param map
     * @return
     */
    public static String mapToJson(Map<String,Object> map){
        return JSONObject.toJSON(map).toString();
    }

    /**
     * Json字符串转为Map集合
     * @param jsonString
     * @return
     */
    public static Map<String,Object> jsonToMap(String jsonString){
        JSONObject jsonObject = JSON.parseObject(jsonString);
        return jsonObject;
    }
    
}

~~~

