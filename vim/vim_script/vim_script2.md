### **Vim Script学习笔记第二章**

#### **执行一个表达式**
至今为止的命令都是由vim直接执行的，而":execute"命令允许通过命令执行一个vim命令。
例如：
```shell
:execute "tag " . tag_name
```
这个命令用于跳转到一个tag，命令中的"."用于连接两个字符串。

需要明确的一点是`execute`只能执行命令模式下的命令，正常模式下的命令或者说快捷键无法执行。

如果一定要执行normal模式下的命令，可以通过一个normal前缀进行标注。

例如：
```shell
:normal gg=G
```
并且执行的命令不能是表达式，只能是字面上的命令，或者更具体一点说就是键盘上按下哪些键一样。

如果要想执行表达式，需要normal与execute共同执行
```shell
:execute "normal " . normal_commands
```

同时文档上说明执行normal命令必须要是一个完整的命令，我的理解是如果由normal模式进入到了其它模式，则在命令的最后必须回到normal模式，否则vim光标会跑到文件的末尾并舍弃执行的命令。比如：
```shell
:execute "normal Inew text \<Esc>"
```
我之所以说normal命令就是按照键盘上相应的键按一遍，看这个例子就可以看出来。进入insert模式的"I"命令和要输入的"new text"已经完全融为一起了。当然反斜杠是要转义的，不会被按下。

如果你不想执行一个命令，但想知道执行后的结果会是怎样的，你可以用到`eval()`函数。
```shell
:let optname = "path"
:let optval = eval('&' . optname)
```

#### **函数**

终于到函数了。
**vim自带函数**

vim有一部分自带的函数，用于帮助写script
例子：

```shell
:let line = getline(".")
:let repl = substitute(line, '\a', "*", "g")
:call setline(".", repl)
```
getline():从当前buffer中选取一行，参数为行数。当输入参数为"."时表示当前光标所在行。

substitute():subsitute函数与`:substitute`命令（很少有人用全称，一般都是缩写s,":%s/...")做的事差不多。第一个参数是要进行替换的string，第二个参数要替换的模式(一般用正则表达式进行匹配)，第三个参数是要替换的内容，第四个则是flags。这里用的flag是g，表示全局改动，因为vim默认只对第一个匹配到的字符进行改动，所以要想改所有的，需要一个g的flag，此外还有的flag为：p(打印所有的改动)，c(改动之前进行询问)，i(忽略大小写)。

setline():讲某一行通过某个字符串代替。

文档还列出了更多的函数，我这里就不列举了。上文档41.6节很容易找到。这些函数可以说是包罗万象了，想要实现一定的功能，还是得上这里找相应的函数。

**定义函数**

函数定义的格式如下：
```shell
:function {name}({var1}, {var2}, ...)
: {body}
:endfunction
```
注意：这里的花括号只是为了说明是可以替换的，并不是说函数定义要有花括号。

另外，由于vim没有闭包的概念，所以不同范围内的变量需要前缀来声明。所以在使用函数参数时需要加上前缀"a:"来告诉函数这是使用的函数参数。

函数定义实例：
```shell

         :function Min(num1, num2)
         :  if a:num1 < a:num2
         :    let smaller = a:num1
         :  else
         :    let smaller = a:num2
         :  endif
         :  return smaller
         :endfunction
```

**函数的重定义**
如果要重定义一个已经存在的函数，则必须可以在通过`:functio!`来定义函数

定义好的函数可以如同内置函数一样被调用。

**call调用**

