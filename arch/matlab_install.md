---
author: lunar
date: Fri 18 Sep 2020 07:32:20 PM CST
---

## Manjaro安装MATLAB2020a

### 软件来源

我用的MATLAB并非盗版，而是用的学校买的正版。

### 挂载镜像文件

从网站下载的MATLAB是一个iso镜像文件，需要先挂载才能安装。

我的挂载路径为`/mnt/iso`

挂载命令为：`sudo mount R2020a_linux.iso -o loop /mnt/iso`

### 正式安装

进入`/mnt/iso`, 输入`sudo ./install`进行安装。但是这时会提示你无法launch MATLABWindow Application之类的信息。

我查阅资料后发现**需要安装一个包libselinux**, 我在阿里云的镜像网站还下载失败了，改为清华的镜像网站才下载成功。

这时会正式进入安装界面，如果是学校网站下载的就直接学校邮箱登录，然后会要求验证邮箱什么的。

另外要记住安装的路径，因为他不会生成桌面图标，需要去该路径下找。

### 正式启动

找到下载路径的bin目录下，输入`./matlab`运行，推荐把图标pin在桌面上。

### 第一次更新

2020年11月29日，在一次更新内核之后，我的MATLAB突然变得难以使用。只好卸载重装，但是按照原来的方式已经无法成功安装了，同意报出了"can't launch MATLABWindow Application"的错误。且无法通过安装libselinux包进行解决。感觉这个和我的MATLAB不好用应该有直接的联系。

又查阅一番资料后发现在mathworks论坛有中文选手给出不运行install脚本，而是直接运行bin/glnxa64目录下的install_unix_legacy脚本，尝试之后果然可以成功安装。

虽然好像还是不是很好用，总是提示已通过改用OpenGL软件禁用了某些高级的图形渲染功能。
