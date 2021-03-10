# networksetup



Usage: 	

​	Display list of services. An asterisk (*) denotes that a network service is disabled.





Usage: networksetup -getcomputername

​	Display the computer name.





Usage: networksetup -getinfo <networkservice>

​	Display IPv4 address, IPv6 address, subnet mask,router address, ethernet address for <networkservice>.





Usage: networksetup -setwebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>

​	Set Web proxy for <networkservice> with <domain> and <port number>. Turns proxy on. Optionally, specify <on> or <off> for <authenticated> to enable and disable authenticated proxy support. Specify <username> and <password> if you turn authenticated proxy support on.



Usage: networksetup -setwebproxystate <networkservice> <on off>

​	Set Web proxy to either <on> or <off>.



Usage: networksetup -setsecurewebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>

​	Set Secure Web proxy for <networkservice> with <domain> and <port number>. Turns proxy on. Optionally, specify <on> or <off> for <authenticated> to enable and disable authenticated proxy support. Specify <username> and <password> if you turn authenticated proxy support on.



Usage: networksetup -setsecurewebproxystate <networkservice> <on off>

​	Set SecureWeb proxy to either <on> or <off>.



Usage: networksetup -setsocksfirewallproxy <networkservice> <domain> <port number> <authenticated> <username> <password>

​	Set SOCKS Firewall proxy for <networkservice> with <domain> and <port number>. Turns proxy on. Optionally, specify <on> or <off> for <authenticated> to enable and disable authenticated proxy support. Specify <username> and <password> if you turn authenticated proxy support on.

~~~shell
sudo networksetup -setsocksfirewallproxy Ethernet 127.0.0.1 1080
~~~



Usage: networksetup -setsocksfirewallproxystate <networkservice> <on off>

​	Set SOCKS Firewall proxy to either <on> or <off>.

