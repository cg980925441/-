### 克隆修改然后提交		

- 1、使用git clone url,从Github仓库中克隆到本地

  

- 2、进行修改后，在仓库文件夹中使用git commit -a -m 提交所有修改和描述信息

  

- 3、使用git push 远程 分支进行提交



### 新建初始化加入提交

- 1、创建你的项目目录（在Github和本地都创建）

  

- 2、在项目目录执行git init将项目目录变成git仓库

  

- 3、将项目中的文件加入到git临时区域中使git能够跟踪其变化
  git add . 加入所有目录中检测到的新文件
  git add xxx 加入指定的文件

  
  
- 4、提交所有修改和描述信息
  git commit -a -m 

  

- 5、添加目的地
  git remote add origin 远程存储库的url

  
  
- 6、将本地文件提交到Github
  git push origin master



### 常用命令总结

安装Git之后,可以使用git命令,但是必须在存储库中使用,所有我们必须在存储库的目录下执行git

git clone url
可从GitHub存储库中克隆一个存储库到本地

git status
获得git此时的状态,那些文件进行了修改等

git commit
提交修改,需要参数
-a 提交所有修改
-m 提交时的描述信息,后面应该是双引号包围的字符串

git config --list
查看本地git工具的配置

git log -2 
查看日志记录

git remote -v
查看远程源

git remote remove origin
删除远程源

git push 远程 分支
将本地仓库提交到Github

git pull 远程 分支
从Github上拉取到本地

git branch 分支名
建立一个分支

git checkout 分支名
进入分支

git add . -a 添加所有内容并删除所有内容（移动文件）