### **CentOS安装MySQL**

> 参考:https://developer.aliyun.com/article/47237

今天将一个web迁移到服务器时，发现还没有安装MySQL数据库。服务器是CentOS系统，搜索了安装MySQL的方法都没有用。最后还是在阿里云教程里面找到了解决办法。

#### 环境

* CentOS 7.1 (x86_64)
* MySQL 5.6

#### **依赖**

MySQL依赖libaio，所以需要先安装libaio

`yum install libaio`

#### **检查是否已经安装MySQL**

`yum list installed | grep mysql`

如果运行有结果，则全部卸载。我的当初因为前面走了几次弯路，所以有几个版本的MySQL，我都一一卸载了。

`yum -y remove mysql-libs.x86_64`

具体后面包的名字还得看上一个命令的输出结果。

#### **下载MySQL Yum Repository**

`wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm`

#### **添加MySQL Yum Repository**

`yum localinstall mysql-community-release-el7-5.noarch.rpm `

沿途所有的选项都选`y`

#### **检查是否安装成功**

`yum repolist enabled | grep "mysql.*-community.*"`

可以看到多个结果

```
mysql-connectors-community/x86_64 MySQL Connectors Community 1
mysql-tools-community/x86_64 MySQL Tools Community 1
mysql56-community/x86_64 MySQL 5.6 Community Server 13 
```

#### **选择要启用的MySQL版本**

查看可用的MySQL版本，执行

`yum repolist all | grep mysql`

因为听说MySQL5.6是最新的稳定版本，所以这里选5.6。

通过类似下面的命令来选择启动或禁止你希望的版本：

`yum-config-manager --diable mysql56-community`

`yum-config-manager --enable mysql56-community-dmr`

最后通过

`yum repolist enabled | grep mysql`

来查看当前启动的MySQL版本

#### **通过Yum来安装MySQL**

`yum install mysql-community-server`

所有选项依旧选`y`

最后会提示已安装哪个版本，要看一下，然后执行

`rpm -qi mysql-community-server.x86_64 0:5.6.24-3.el7`

后面的这些详细的版本详细需要根据你的已安装的版本信息决定。

#### **启动和关闭MySQL**

`systemctl start mysqld`

`systemctl status mysqld`

`systemctl stop mysqld`

测试是否安装成功

`mysql`

第一次是不需要密码的（和我在manjaro上面安装太不一样了，同样是Linux，差别也太大了）。

#### **防火墙设置**

如果你有远程登录MySQL数据库的需求，需要开放默认端口号3306

这里我只是运行一个web程序，所以没有测试。

执行

```
firewall-cmd --permanent --zone=public --add-port=3306/tcp
firewall-cmd --permanent --zone=public --add-port=3306/udp 
```

重载使生效

`firewall-cmd --reload`

#### **修改root密码**

由于初始时MySQL没有设置root密码，所以MySQL需要进行一次安全设置。

`mysql_secure_installation`

提示是否设置root密码，选y

输入两次密码

是否删除匿名用户，选y

是否禁止远程以root身份登录？选y

是否删除测试数据库？选y

是否重载特权表？选y

#### **添加用户**

一般以root身份是不安全的，所以需要添加两个用户。

添加一个普通用户

```sql
CREATE USER 'sa'@'%' IDENTIFIED BY 'some_pass';
```

给用户添加增删改查的权限

```sql
GRANT SELECT,INSERT,UPDATE,DELETE ON *.* TO 'sa'@'%';
```

添加管理员与添加普通用户操作一样

给管理员添加所有权限

```sql
GRANT ALL ON *.* TO 'admin'@'%';
```



