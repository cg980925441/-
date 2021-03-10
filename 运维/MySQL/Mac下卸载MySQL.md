~~~ cmd
sudo rm /usr/local/mysql\
sudo rm -rf /usr/local/mysql*\
sudo rm -rf /Library/StartupItems/MySQLCOM\
sudo rm -rf /Library/PreferencePanes/My*\
rm -rf ~/Library/PreferencePanes/My*\
sudo rm -rf /Library/Receipts/mysql*\
sudo rm -rf /Library/Receipts/MySQL*\
sudo rm -rf /var/db/receipts/com.mysql.*

~~~

检查/usr/local/Cellar目录是否有mysql文件，有的话删除。
检查/usr/local/var 里的mysql文件，有的话删除。
检查/tmp 里的mysql.sock、mysql.sock.lock、 my.cnf文件，有的话删除。
err文件以及pid文件都是在/usr/local/var/mysql中，有的话删除。
brew安装的安装包存储在/usr/local/Library/Cache/Homebrew，有的话删除。
一定要记得执行brew cleanup。



