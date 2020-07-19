### **Vim Script笔记第一章**
提示：本系列文章要求你对vim有一定的入门级了解。
> 个人一直对vim这个上古神器非常感兴趣，深入了解一下才知道有多么强大。并且在强大的同时占用的资源非常小，这样我就不要写一个简单的Python脚本都要去打开那个庞大的Pycharm，简直是命令行利器。

> 虽然网络上关于vim各种命令和快捷键的教程都很多，但是关于vim script的却很少。可能是因为大多数人都不用vim吧，就算用也只是在ssh远程登录时用一下。所以我就决定认真读一下vim script的英文文档，写一点笔记，就当练英语了，也可以为其他vim爱好者提供一些帮助。

> 英文文档可以通过vim在normal模式下输入`:help vim-script-intro`看到。我的这一系列文档将会在github和博客园进行连载，欢迎给star。https://www.github.com/xiaoqixian/Linux.git/vim/vim_script

#### **变量定义**

定义变量的一般形式为(因为vim script和shell还挺像的，所以这里用shell的代码格式')：
```shell
:let {variable} = {expression}
```
提示：这里使用冒号并没有什么太大的含义，相信你们在很多.vimrc的配置文件中都看到过这种写法。在官网文档中提出这就是为了明确这是在command mode下使用的命令，以区别与normal mode下使用的命令。

下文对于变量定义还有更详细的展开。

#### **while循环**

while循环的一般格式为：
```shell
:while {condition}
:   {statement}
:endwhile
```
`:break`和`:continue`同样存在，在for循环语句中也一样。

综合实例：
```shell
:let i = 1
:while i < 5
:   echo "count is" i
:   let i += 1
:endwhile
```
要想运行这段代码，在visual mode下yank这段代码，然后在normal模式下输入 :@"
注意不要忽略引号或冒号。

`echo`是一个输出的语句，这个有shell基础的应该都知道。

然后有一个`let i += 1`的语句，说明在变量作运算时也要使用`let`关键字。

#### **四种进制**

vim script中存在十进制、十六进制、八进制、二进制四种进制。十六进制通过前缀"0x"标识，八进制通过"0"标识，二进制是"0b"。和很多其它编程语言都一样。

#### **variables**
前面讲的`let`进行定义变量只是开了个小头。

**变量的命名规则**：这一点与很多编程语言一致，不细讲。相信你也不会命名一些奇奇怪怪的变量。
通过命令`:let`可以查看当前已经被定义的变量。

**变量范围**
vim script很让人迷惑的一点就是它通过`let`定义的变量都是全局变量，而且可以被其它vim script文件所引用。为了避免变量的冲突和不经意的修改。推荐对变量加上前缀进行范围限定：

    s:name 其它".vim"文件可以引用，但是不可以修改本文件的定义
    b:name buffer中的局部变量
    w:name 当前窗口的局部变量
    v:name vim提前定义的变量
    
**删除变量**
删除变量并释放内存：
```shell
:unlet s:count
```
所以如果你的变量定义时有个前缀，也要加上。
如果你不确定这个变量是否存在，不想要vim报错的话，可以加上一个"!"：
```shell
:unlet! s:count
```

如果变量在script结束时没有被释放，则在下一次script再运行时，变量的值依然为原来的值。例如：

         :if !exists("s:call_count")
         :  let s:call_count = 0
         :endif
         :let s:call_count = s:call_count + 1
         :echo "called" s:call_count "times"

`exists`函数用于检测变量是否存在，参数为变量名的字符串，不是变量本身。

#### **字符串**
字符串分为单引号和双引号。

在单引号中，所有的字符都被当做原本的意思，包括反斜杠，除了单引号自己。

在双引号中，则可以通过反斜杠来进行转义。

#### **表达式**

**数学表达式**
大差不差，甚至C语言中的三目表达式都借用了。

**表达式中的特殊变量**

    $NAME 环境变量
    &name 选项变量(通过:set all命令可以查看所有选项变量)
    @r    寄存器变量
    
#### **条件语句**
    
三种分别为：
```shell
:if {condition}
    {statements}
:endif

:if {condition}
    {statements}
:else
    {statements}
:endif

:if {condition}
    {statements}
:elseif {condition}
    {statements}
:endif
```

#### **逻辑表达式**

首先是一些常见的大于、等于、小于、大于等于、小于等于等表达式。

**字符串和数字的比较**
当用字符串和数字进行比较时，字符串会自动转换为数字0

**vim版本的数字**
当需要写跨vim版本的script时，需要判断vim的版本。vim的版本用数字表示，6.0版本就是600，6.1就是601

**字符串的匹配表达式**
vim script有两个逻辑表达式专门用于字符串匹配

    a =~ b  a可以匹配b
    a !~ b  a不可以匹配b

例如：
```shell
         :if str =~ " "
         :  echo "str contains a space"
         :endif
         :if str !~ '\.$'
         :  echo "str does not end in a full stop"
         :endif
```
注意第二个匹配字符串是用单引号表示的，这样做的好处是可以不用转义反斜杠而直接匹配。如果用双引号字符串就必须用两个反斜杠来表示一个反斜杠。

**字符串比较和匹配的大小写问题**
字符串的比较和匹配是默认忽略大小写的。如果不想这样，可以在表达式后面加上一个"#"，如"=~#"。如果想要确认忽略大小写，可以加一个"?"


