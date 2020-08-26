## 1、安装homebrew

~~~shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
~~~



## 2、替换homebrew镜像源

1. 替换默认镜像源

```shell
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
```



1. 替换homebrew-core镜像源

```shell
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
```



1. 替换homebrew-cask镜像源（**可选操作**）

```shell
# 如果没安装homebrew cask,先安装。 brew cask主要用来下载一些图形界面程序，下载好后会自动安装。
$ brew install cask 
#  替换镜像源
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-cask"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
```



1. brew update更新，加上 -v 参数可以看到当前跑的进度：

```
$ brew update -v
```

1. 检测

```shell
$ brew doctor
```





## 3、如何卸载

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```