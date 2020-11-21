### fcitx5 在WPS中正常使用

自从上个月升级到fcitx5之后，在WPS中就无法正常使用了。因为平时使用WPS的时候也不多，所以一直没有处理。但是最近为了写期末论文，需要用到WPS writer，所以花了一个多小时查阅各种论坛终于弄好了。

先看下我的系统配置：

![image-20201121151149947](https://i.loli.net/2020/11/21/NyDbgIMEfFc3tJX.png)

#### 错误来源

好像是因为wps在较新的版本之后就不在读取用户的默认的配置文件~/.pam_environment，所以你在这个文件中再怎么改也没有用。

#### 解决办法

正确的做法是直接在启动脚本中添加export变量导出。

启动脚本位于/usr/bin目录下，打开相应程序对应的启动脚本。

在gOpt一行下添加

```shell
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx
```

然后保存退出。

这样就可以成功在WPS中使用fcitx5了。