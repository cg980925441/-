# 1、前言

## 1、java操作excel

Java有两个项目支持对Microsoft Office格式文件的操作：jxl和Apache POI，其中Apache POI框架最为常用。



## 2、Office文件格式

早期Office格式为二进制形式（doc，xls，ppt），而在Office 2007版本之后，使用基于XML的压缩格式作为默认文件格式（docx，xlsx，pptx）。即我们可以使用压缩软件打开这种格式文件，该格式文件基于OpenXML标准。



# 2、Apache POI

Apache POI提供了对Office早期二进制格式的读写和对基于XML的格式的读写。



## 1、两类maven依赖

~~~ xml
<!-- 二进制格式依赖 -->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>4.0.0</version>
</dependency>


<!-- XML格式依赖 -->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>4.0.0</version>
</dependency>

~~~

## 2、三种Excel读写的方式

- XSSFWorkbook：支持.xlsx文件的读写。
- HSSFWorkbook：支持.xls文件的读写。
- SXSFWorkbook：3.8版本后基于XSSF的低内存占用版本（使用滑动窗口实现）。

这三种方式都实现了Workbook类，具有相同接口，只是底层实现不同。



## 3、使用

### 1、读取

~~~ java
// 打开指定位置的Excel文件
FileInputStream file = new FileInputStream(new File(fileLocation));
Workbook workbook = new XSSFWorkbook(file);
// 打开Excel中的第一个Sheet
Sheet sheet = workbook.getSheetAt(0);

// 读取Sheet中的数据
Map<Integer, List<String>> data = new HashMap<>();
int i = 0;
for (Row row : sheet) { // 行
    data.put(i, new ArrayList<String>());
    for (Cell cell : row) { // 单元格
        
    }
    i++;
}
~~~

### 2、写入

~~~ java
Workbook workbook = new XSSFWorkbook(); // 创建工作簿

Sheet sheet = workbook.createSheet("Persons"); // 创建Sheet
sheet.setColumnWidth(1, 4000);

Row header = sheet.createRow(0); // 创建表头行

CellStyle headerStyle = workbook.createCellStyle(); // 表头单元格样式
headerStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
XSSFFont font = ((XSSFWorkbook) workbook).createFont(); // 字体样式
font.setFontName("Arial");
font.setFontHeightInPoints((short) 16);
font.setBold(true);
headerStyle.setFont(font);

Cell headerCell = header.createCell(0); // 创建表头单元格
headerCell.setCellValue("Name");
headerCell.setCellStyle(headerStyle);

headerCell = header.createCell(1); // 创建表头单元格
headerCell.setCellValue("Age");
headerCell.setCellStyle(headerStyle);

CellStyle style = workbook.createCellStyle(); // 普通单元格样式
style.setWrapText(true);

Row row = sheet.createRow(2); // 写入单元格
Cell cell = row.createCell(0);
cell.setCellValue("John Smith");
cell.setCellStyle(style);

cell = row.createCell(1); // 写入单元格
cell.setCellValue(20);
cell.setCellStyle(style);

// 最后写出到文件
FileOutputStream outputStream = Files.newOutputStream("/path/to/excel");
workbook.write(outputStream);
workbook.close();
~~~



## 4、总结

Sheet：

Row：

Cell：