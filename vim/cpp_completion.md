
### **vim中存在的c++补全问题**

自从安装YCM插件以后，一直没有写过cpp代码，直到今天才发现YCM对cpp的补全一直有问题。

遂上网查找解决方案，都是说要找到一个路径下的.ycm_extra_conf.py文件，然后令

`let g:ycm_global_ycm_extra_conf= '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'`

这个.ycm_extra_conf.py文件的路径是不一定的，网上的很多教程都不是这个路径。导致我在他们说的路径找半天没找到，所以需要在YouCompleteMe文件夹路径下仔细寻找。

但是光是加入这个文件还不够，还要在该文件中添加下面这个函数。亲测有效。

```python
def Settings( **kwargs ):
    return {
        'flags': [
        '-isystem',
        '/usr/include/c++/5',
        '-isystem',
        '/usr/include',
        '-Wall',
        '-Wextra',
        '-Werror'],
    }

```
