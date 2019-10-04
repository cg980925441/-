package com.zanpo.it.util;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DBHelpper {

    private static String driver = "";
    private static String url = "";
    private static String user = "";
    private static String password = "";

    static {
        try {
            Properties properties = new Properties();
            properties.load(DBHelpper.class.getClassLoader().getResourceAsStream("config.properties"));

            driver = properties.getProperty("driver");
            url = properties.getProperty("url");
            user = properties.getProperty("user");
            password = properties.getProperty("password");
            Class.forName(driver);

        } catch (ClassNotFoundException e) {
            throw new RuntimeException("无法加载驱动连接类");
        } catch (FileNotFoundException e) {
            throw new RuntimeException("没有在classpath下找到配置文件：config.properties");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    public static Connection getConnection(){
        try {
            return DriverManager.getConnection(url,user,password);
        } catch (SQLException e) {
            throw new RuntimeException("获取连接失败，请检查数据库连接或账号密码是否有误");
        }
    }
}
