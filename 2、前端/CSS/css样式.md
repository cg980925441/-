### 1、颜色

#### 1、颜色表示

- 常量：white，black等

- 十六进制，#00FF00

- RBG，例如rgb(192,192,192)

  

#### 2、渐变

##### 1、线性渐变

~~~ css
/* 可变参数，渐变颜色可以多个：1.渐变的方向 2.渐变开始颜色 3.渐变结束颜色 */
background: linear-gradient(to right,red, blue);
~~~

##### 2、径向渐变

~~~ css
/* 可变参数，渐变颜色可以多个： 1.渐变开始颜色 2.渐变结束颜色 */
background: repeating-radial-gradient(to right,red, blue);
~~~

##### 3、重复渐变

```css
/* 指定比例 */
background: repeating-radial-gradient(red, yellow 10%, green 15%);
```





### 2、字体

#### 1、粗体

```css
font-weight:bold;
```

#### 2、字体大小

~~~ css
/* 使用px指定大小 */
font-size:12px;
/* 使用em指定相对大小 */
font-size:2em;
~~~

#### 3、字体风格

~~~ css
/* 指定一个字体家族，找到存在的字体就使用 */
font-family:"Times New Roman",Georgia,Serif;
~~~

#### 4、字体颜色

~~~ css
color:white;
~~~



### 3、形状

#### 1、圆角

~~~ css
/* 背景角度 */
background-radius: 25;
/* 边框角度 */
border-radius: 25;
~~~



### 4、阴影

~~~ css
box-shadow: 10px 10px 5px #888888;
~~~



### 5、变形

缩放变形

~~~ css
transform: scale(1.1)
~~~

为了使得变形更加平滑，一般都会加入旋转的效果

