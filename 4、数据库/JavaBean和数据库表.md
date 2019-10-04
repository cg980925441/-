### 1、从数据库表生成JavaBean

使用JDBC实现，CCSR。

- 加载数据库驱动
- 获得连接
- 得到数据库MetaData
- 从数据库MetaData得到表
- 从表得到字段信息

~~~ java
    DatabaseMetaData metaData = conn.getMetaData();
	//得到数据库表集合
    ResultSet resultSet = metaData.getTables(null, "%", table, new String[] { "TABLE" });
    while (resultSet.next()) {
        String tableName=resultSet.getString("TABLE_NAME");
        if(tableName.equals(table)){
            //得到表的列集合
            ResultSet rs = metaData.getColumns(null, null,tableName.toUpperCase(), "%");

            while(rs.next()){
                Map map = new HashMap();
                //从列中取列名
                String colName = rs.getString("COLUMN_NAME");
                map.put("colName", colName);
				//从列中区标记（注释）
                String remarks = rs.getString("REMARKS");
                if(remarks == null || remarks.equals("")){
                    remarks = colName;
                }
                map.put("remark",remarks);
				//从列中区数据类型
                String dbType = rs.getString("TYPE_NAME");
                map.put("dbType",dbType);
				//根据数据库类型得到Java类型
                map.put("valueType", changeDbType(dbType));
                result.add(map);
            }
        }
    }
~~~

