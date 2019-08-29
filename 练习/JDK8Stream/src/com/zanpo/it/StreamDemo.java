package com.zanpo.it;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;
import java.util.stream.Stream;

public class StreamDemo {

    public static void main(String[] args) {
        // 要求过滤出，名字长度为2，姓李的
        List<String> list = new ArrayList<String>();
        list.add("张三");
        list.add("张三分");
        list.add("张狗蛋");
        list.add("李四");
        list.add("李斯");
        list.add("赵六方");

    }
}
