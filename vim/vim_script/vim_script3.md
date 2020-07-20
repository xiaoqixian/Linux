### **Vim Script学习笔记第三章**

#### **列表与字典**

列表与字典的概念熟悉Python的小伙伴应该不会陌生。在vim script中同样有这两个概念，并且使用同样非常自由。在列表中同样可以添加任意类型的变量，进行任意的改动。

这一部分与Python的很多都非常相似，不细讲了。像什么`for in`循环，`for in range`循环都是Python里面有的。相信会使用Linux并且还来学习vim script的小伙伴对于Python这么热门的语言都很熟悉了。

#### **异常**

try catch语句可用于捕获异常，格式为：
```shell
:try
:   "do something
:catch error
:   "do something
:finally
:   "do something
:endtry
```

#### **样式总汇**

**空格**
不同与shell，空格在vim script中是会被忽略的。同样通过反斜杠转义空格。

**注释**
vim script通过一个双引号可以进行单行注释。
有时候，一些命令会采用行内除了注释以为的所有字符进行匹配，包括空格。比如：
```shell
:map ,ab o#include
:unmap ,ab               "comment
```
这里想在`:unmap`后面一些的地方进行注释，但是`unmap`会将双引号之前的所有字符包括空格作为变量名进行unmap，所以显然会引发错误。这时可以通过"|"符号告诉命令应该在哪里停止。如：
```shell
:unmap ,ab|              "comment
```
这样就只会匹配到",ab"

> 接下来就是写vim插件的内容了，可能会耽误几天。
