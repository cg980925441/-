## 根据密码生成指定位数的密钥

### 1、Java语言实现

工具方法：

~~~java
// 合并byte数组
public static byte[] bytesMerge(byte[] a,byte[] b){
  int len = a.length + b.length;
  byte[] r = new byte[len];
  System.arraycopy(a,0,r,0,a.length);
  System.arraycopy(b,0,r,a.length,b.length);
  return r;
}

// 无符号打印byte数组
private static void byteUnsignPrint(byte[] digest) {
  System.out.print("[");
  for (int i = 0; i < digest.length; i++) {
    int n = Byte.toUnsignedInt(digest[i]);
    System.out.print(n);
    if(i != digest.length-1){
      System.out.print(",");
    }
  }
  System.out.print("]");
  System.out.println();
}
~~~



实现代码：

实现指定位数(8的倍数)的密钥生成

~~~java
private static byte[] kdf(String pwd,int keyLen){
        byte[] prev = {};
        byte[] result = new byte[keyLen];
        byte[] pwdByte = pwd.getBytes();
        byte[] data;
        int curPos = 0;

        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("md5");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        while(curPos < keyLen){
            // 上一次得到的md5值加上密码再次hash
            data = bytesMerge(prev,pwdByte);
            data = md5.digest(data);
            // 拷贝结果
            System.arraycopy(data,0,result,curPos,data.length);
            // 保存已经hash的值
            prev = Arrays.copyOf(data,data.length);
            // 修改指针
            curPos += md5.getDigestLength();
            // 重置
            md5.reset();
        }

        return result;
    }
~~~



### 2、Go语言实现

~~~go
func kdf(password string, keyLen int) []byte {
	var b, prev []byte
	// h是一个hash.Hash接口
	h := md5.New()
	for len(b) < keyLen {
		h.Write(prev)
		h.Write([]byte(password))
		b = h.Sum(b)
		prev = b[len(b)-h.Size():]
		h.Reset()
	}
	return b[:keyLen]
}
~~~



对比：

1、Go语言的切片可以很方便进行数组的操作

2、Go语言默认无符号打印

3、Go语言的md5库可以很方便的进行待hash数据的append操作

