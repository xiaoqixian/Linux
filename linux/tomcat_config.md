---
author: lunar
date: Tue 11 Aug 2020 10:36:47 AM CST
---

### **Linux配置tomcat**

> 前面所需要的jdk的配置就免了。

在Windows配置异常简单的tomcat，在Linux上经常还费了我一番力气。

首先从官网下载压缩包。

在/usr/local下创建tomcat目录，然后解压到这个目录。

接着就是非常重要的**改用户**，之前我不知道这个导致处处受限，在IDEA中都不能顺利导入。

由于tomcat不是放在home目录下，所以拥有者是root，为了方便，我们将其拥有者改为本地用户。

`sudo chown -R user /usr/local/tomcat`

user改为你的当前用户名。

这样tomcat文件夹以及下面的所有文件的拥有者都变成了你。

bin目录下存放了所有运行用的脚本文件，我们需要为其添加运行权限

`sudo chmod +x bin/*.sh`

这样总算可以正常使用了。
