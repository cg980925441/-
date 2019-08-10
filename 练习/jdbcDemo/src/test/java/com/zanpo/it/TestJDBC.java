package com.zanpo.it;

import org.junit.Test;

import java.lang.reflect.Field;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TestJDBC {

    /**
     * 需求：通过给定的数据库表和VO对象，通过JDBC将数据库中的数据都查询出来放入VO对象的集合中
     */
    @Test
    public void testLinkDB() throws ClassNotFoundException, SQLException, IllegalAccessException, InstantiationException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/mywork?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=GMT";
        String user = "root";
        String password = "123456";

    }
}
