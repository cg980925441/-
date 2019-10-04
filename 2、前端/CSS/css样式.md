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

#### 1、圆

~~~ css
border-radius: 50%;/*圆*/
border-radius: 150px 150px 0 0;/*半圆*/
border-radius: 150px 0 0 0;/*四分之一圆*/
~~~

画圆的时候注意两点：

- 只有宽高为正方形时才能画出正圆；
- 画部分圆时，需要注意缩小宽高；



#### 2、三角

~~~css
border-top: 50px solid transparent;
border-bottom: 50px solid aqua;
border-left: 50px solid transparent;
border-right: 50px solid transparent;
width: 0px;
height: 0px;
margin: 50px auto;
~~~

画三角的时候注意：

- 设置border属性，设置四面边框且宽高为0；
- 通过设置对面边框边框为0，且两边为透明transparent色；

额，直接把不需要的三面边框设置为透明色就行了。



#### 3、菱形

~~~ css
transform: rotate(45deg);
~~~

通过45度旋转正方形即可得到菱形，注意**角度的单位deg**



#### 4、平行四边形

~~~css
transform: skew(-10deg);
~~~

通过倾斜正方形即可得到平行四边形。倾斜还可以旋转y轴。



#### 5、五角星



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

