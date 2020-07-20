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
当函数没有return或没有return任何东西时，函数实际return一个0

**函数的重定义**
如果要重定义一个已经存在的函数，则必须可以在通过`:functio!`来定义函数

定义好的函数可以如同内置函数一样被调用。

**call调用**
`call`命令同样可以用于调用函数，与直接调用不同的是call命令可以更加精确。比如call命令可以range调用。

什么意思呢？如果你在定义函数时使用了range关键字：
```shell

         :function Count_words() range
         :  let lnum = a:firstline
         :  let n = 0
         :  while lnum <= a:lastline
         :    let n = n + len(split(getline(lnum)))
         :    let lnum = lnum + 1
         :  endwhile
         :  echo "found " . n . " words"
         :endfunction
```
且在调用时传入了行数范围：`:10,30call Count_words()`，则vim会将行数10传入到firstline参数中，将30传入到lastline参数中，供函数使用。

如果你在定义函数时没有使用`range`关键字，并且在调用时使用行数范围，则该函数会在行数范围的每一行内执行一次。

**可选参数**
vim script设置可选参数的格式为：
```shell
:function Show(start, ...)
```
"..."是函数的一部分，不表示省略。上面的函数中，函数有一个必选参数start，和最多不超过20个的可选参数。可选参数通过数字来引用，比如`a:1`就表示第一个输入的可选参数，以此类推。
**`a:0`表示可选参数的数量**。

通过命令`:function`可以查看所有已经定义的函数名。如果要查看某个函数的具体定义，可以通过`function 函数名`命令进行查看。

**删除函数**
删除函数定义的命令：`:delfunction Show`

**函数引用**
vim script允许将函数如同变量一样被传递。格式为：
```shell
:let variable = function('function name')
```
通过`function()`函数就可以达到这一目的。
```shell

         :let result = 0         " or 1
         :function! Right()
         :  return 'Right!'
         :endfunc
         :function! Wrong()
         :  return 'Wrong!'
         :endfunc
         :
         :if result == 1
         :  let Afunc = function('Right')
         :else
         :  let Afunc = function('Wrong')
         :endif
         :echo call(Afunc, [])
         Wrong!
```
**注意：引用函数的变量名必须以大写字母开头，否则名字将于内置函数名可能混淆。**

调用引用函数的方法就是通过`call()`函数，注意这里是函数，而不是命令，与前面的相区分。call函数的第一个参数就引用变量，第二个参数一个带有参数的列表。

> 函数终于写完了...

