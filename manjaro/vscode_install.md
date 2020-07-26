---
author: lunar
date: Sun 26 Jul 2020 04:17:34 PM CST
---

### **Manjaro安装VSCode**

很奇怪vscode这么重量级的编辑器竟然没在arch系的官方仓库中，只能通过手动安装。

1. 所以第一步就是从官网下载安装包，arch系是下载.tar.gz后缀的安装包，如果你是其它发行版，可以下载.deb或.rpm的安装包。

2. 下载后解压缩到/opt/目录

`sudo tar -zxvf code-stable-xxxxxx.tar.gz -C /opt/`

看准你下载的安装包的名字，尤其是后面的数字

3. 加上执行权限

`sudo chmod +x /opt/VSCode-linux-x64/code`

4. 加入系统环境

`ln -s /opt/VSCode-linux-x64/code /usr/local/bin/code`

5. 创建图标

`sudo vim /usr/share/applications/visualstudiocode.desktop`

拷贝如下内容进去：

```
[Desktop Entry]
Name=Visual Studio Code
Comment=Multi-platform code editor for Linux
Exec=/opt/VSCode-linux-x64/code
Icon=/usr/share/icons/code.png
Type=Application
StartupNotify=true
Categories=TextEditor;Development;Utility;
MimeType=text/plain;
```

再将图标文件复制到指定文件夹

`sudo cp /opt/VSCode-linux-x64/resources/app/resources/linux/code.png /usr/share/icons/`
