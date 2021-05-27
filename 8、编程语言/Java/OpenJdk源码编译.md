# OpenJdk8u源码编译



## 1、源码下载

1、openjdk官网下载

> https://download.java.net/openjdk/jdk8



2、Github镜像下载

> https://github.com/unofficial-openjdk/openjdk



## 2、依赖软件

1、GCC

2、freetype

4、Xcode



## 3、修改文件

1、注释gcc相关检查

路径：common/autoconf/generated-configure.sh

字符串：GCC compiler is required. Try setting --with-tools-dir.

 

2、注释掉-fpch-deps

改为

~~~makefile
# Flags for generating make dependency flags.
DEPFLAGS = -MMD -MP -MF $(DEP_DIR)/$(@:%=%.d)
ifeq ($(USE_CLANG),)
  ifneq ($(CC_VER_MAJOR), 2)
    # DEPFLAGS += -fpch-deps
  endif
endif
~~~



3、语法检查不通过

openjdk/hotspot/src/share/vm/runtime/virtualspace.cpp	if (base() > 0) {

openjdk/hotspot/src/share/vm/opto/lcm.cpp	Universe::narrow_oop_base()

解决：将指针判断改为!=NULL



4、头文件未找到

1、#import <JavaNativeFoundation/JavaNativeFoundation.h>

2、\#import <CoreGraphics/CGBase.h>



解决：Xcode升级后，头文件的存放目录发生了改变

先找到头文件的目录，然后将make文件中的目录更新



待文件修改

~~~
hotspot/make/bsd/makefiles/saproc.make

jdk/make/lib/PlatformLibraries.gmk
jdk/make/lib/Awt2dLibraries.gmk


/System/Library/Frameworks/
改为
/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/
~~~



## 4、环境变量设置

新建文件env.bash

内容：

~~~bash
export LANG=C
export CC=clang
export COMPILER_WARNINGS_FATAL=false
export LFLAGS='-Xlinker -lstdc++'
export USE_CLANG=true
export LP64=1
export ARCH_DATA_MODEL=64
export ALLOW_DOWNLOADS=true
export HOTSPOT_BUILD_JOBS=4
export ALT_PARALLEL_COMPILE_JOBS=4
export SKIP_COMPARE_IMAGES=true
export USE_PRECOMPILED_HEADER=true
export INCREMENTAL_BUILD=true
export BUILD_LANGTOOLS=true
export BUILD_JAXP=true
export BUILD_JAXWS=true
export BUILD_CORBA=true
export BUILD_HOTSPOT=true
export BUILD_JDK=true
export SKIP_DEBUG_BUILD=true
export SKIP_FASTDEBUG_BUILD=false
export DEBUG_NAME=debug
export BUILD_DEPLOY=false
export BUILD_INSTALL=false

unset JAVA_HOME
unset CLASSPATH
unset ALT_ environment
~~~



注释：

~~~bash
# 设定语言选项，必须设置
export LANG=C
# Mac平台，C编译器不再是GCC，是clang
  export CC=clang
# 跳过clang的一些严格的语法检查，不然会将N多的警告作为Error
export COMPILER_WARNINGS_FATAL=false
# 链接时使用的参数
export LFLAGS='-Xlinker -lstdc++'
# 是否使用clang
export USE_CLANG=true
# 使用64位数据模型
export LP64=1
# 告诉编译平台是64位，不然会按32位来编译
export ARCH_DATA_MODEL=64
# 允许自动下载依赖
export ALLOW_DOWNLOADS=true
# 并行编译的线程数，编译时间长，为了不影响其他工作，我选择为2
export HOTSPOT_BUILD_JOBS=4
export ALT_PARALLEL_COMPILE_JOBS=4
# 是否跳过与先前版本的比较
export SKIP_COMPARE_IMAGES=true
# 是否使用预编译头文件，加快编译速度
export USE_PRECOMPILED_HEADER=true
# 是否使用增量编译
export INCREMENTAL_BUILD=true
# 编译内容
export BUILD_LANGTOOLS=true
export BUILD_JAXP=true
export BUILD_JAXWS=true
export BUILD_CORBA=true
export BUILD_HOTSPOT=true
export BUILD_JDK=true
# 编译版本
export SKIP_DEBUG_BUILD=true
export SKIP_FASTDEBUG_BUILD=false
export DEBUG_NAME=debug
# 避开javaws和浏览器Java插件之类的部分的build
export BUILD_DEPLOY=false
export BUILD_INSTALL=false

# 最后干掉这两个变量,不然会有诡异的事发生
unset JAVA_HOME
unset CLASSPATH
unset ALT_ environment
~~~





## 5、开始编译

首先执行source env.bash

接着cd到openjdk目录

执行bash configure

然后执行make 







