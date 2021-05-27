## 1、安装

~~~shell
npm install xterm
~~~



## 2、页面

~~~vue
<template>
  <div id="terminal"></div>
</template>

<script>
import { Terminal } from "xterm";
import "xterm/css/xterm.css";
import "xterm/lib/xterm.js";
var term = new Terminal({
  cursorBlink: true, // 光标闪烁
  cursorStyle: "block", // 光标样式  null | 'block' | 'underline' | 'bar'
  scrollback: 800, //回滚
  tabStopWidth: 8, //制表宽度
  screenKeys: true,
});

export default {
  mounted() {
    term.open(document.getElementById("terminal"));
    //ondta方法是terminal获取输入数据的方法，因此要在这里给后台发送数据
    term.onData(function (data) {
      //键盘输入时的回调函数
      console.log(data);
    });
  },
};
</script>
~~~

