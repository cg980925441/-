# Blog前端总结

## 1、导航栏实现

使用ul和li组件实现导航栏，并指定ul右浮



## 2、带图标的链接

外层使用a标签，内部嵌套img（或者i标签）加上span标签

~~~html
<a>
	<i></i>
  <span></span>
<a/>
~~~



## 3、自动拉伸的背景图片

1、img标签

img标签指定样式

~~~css
width: 100%;
height: 100%;
object-fit: cover;/*存在兼容问题*/
~~~

2、div

~~~css
background-size: cover;
~~~





## 4、awesome图标使用

1、导入css文件

~~~html
<link rel="stylesheet" href="https://cdn.staticfile.org/font-awesome/4.7.0/css/font-awesome.css">
~~~

2、在i标签中引用样式

~~~html
<i class="fa fa-envelope-open fa-lg"></i>
~~~



图标查找

> http://www.fontawesome.com.cn/faicons/



## 5、窗口改变、组件伸缩

1、blibli实现：

设置div的min-width=988px，js中根据窗口大小动态设置div的宽度;

针对PC和手机做不同的适配、字体大小使用px作为单位；

响应式布局针对1080p和720p适配



2、[Hexo](https://hexo.io/) 的 [Matery](https://github.com/blinkfox/hexo-theme-matery) 主题实现

使用响应式布局



## 6、img标签的一些问题

1、img标签是inline-block标签，因此后面可以跟文本元素，空格也会在后面占据大小，导致出现问题。

2、img标签的父级元素会比img标签的大小要大，这是因为img标签是inline-block，按照基线进行对齐。解决方法是设置其垂直方向上的对齐方式为top或者middle。

# 自定义css全局样式

## 1、导航栏

1、右浮

指定ul的样式为right，即可使用ul+li的组合实现右浮导航栏

2、固定导航栏

指定div样式navbar-fixed，且子div样式为nav即可实现65px大小的固定导航条



## 2、居中

指定container样式，即可实现组件的85%，最大1125px的居中对齐





## 3、透明

给元素知道transparency样式，即可实现透明效果；会清除背景图片和阴影





# 前端知识点

block、inline、inline-block

盒模型：padding、margin

层模型：position



## 1、流体布局

宽度使用百分比，高度使用固定大小

calc和box-sizing



## 2、响应式布局

@Media

自动感应屏幕宽度



