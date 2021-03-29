~~~shell
# 生成公钥和私钥串
ssh-keygen -t ed25519 -C "zanpocc@gmail.com"

# 后台执行agent
eval "$(ssh-agent -s)"

# 新增配置
vim ~/.ssh/config

# 添加如下内容
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
  
# 新增key
ssh-add -K ~/.ssh/id_ed25519

# 拷贝需要放入github的串
pbcopy < ~/.ssh/id_ed25519.pub
~~~





参考网站：https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh