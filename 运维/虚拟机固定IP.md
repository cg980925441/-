# 1、VMware Fussion

~~~shell
sudo vi /Library/Preferences/VMware\ Fusion/vmnet8/dhcpd.conf

# 在下面这行之后添加
####### VMNET DHCP Configuration. End of "DO NOT MODIFY SECTION" #######
host 虚拟机名称 {
        hardware ethernet Mac地址;
        fixed-address 需要固定的IP;
}
~~~

