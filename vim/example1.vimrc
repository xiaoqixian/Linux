"配置ycm,taglist,Synstics,The-Nerd-Tree完成之后
"vim下可以使用的快捷键有
"<F2> 目录树,nerd-tree为最后一个窗口，不关闭vim
"<F3> taglist,taglist为最后一个窗口，则关闭vim
"
"**********************************************************
"						一般性配置
"**********************************************************
"关闭vim一致性原则
set nocompatible
"显示行号
set nu
"设置在编辑过程中右下角显示光标的行列信息
set ruler
"设置历史记录条数
set history=1000
"设置c/c++方式自动对齐
set autoindent
set cindent
"开启语法高亮功能
syntax on
"设置自动对齐空格数
set shiftwidth=4
"设置搜索时忽略大小写
set ignorecase
"选中高亮
set hls
"搜索高亮
set hlsearch
"实时匹配搜索结果
set incsearch
"设置tabstop宽度
set ts=4
"指定配色方案为256色
set t_Co=256
"设置在vim中可以使用鼠标
set mouse=a
"设置当文件被改动时自动载入
set autoread
"检测文件类型
filetype on
"针对不同文件采用不同的缩进方式
"filetype indent on
"允许插件
filetype plugin on
"启用智能补全
"filetype plugin indent on

"highlight Function cterm=bold,underline ctermbg=red ctermfg=green
"highlight TabLine term=underline cterm=bold ctermfg=9 ctermbg=4
"highlight TabLineSel term=bold cterm=bold ctermbg=Red ctermfg=yellow
"highlight Pmenu ctermbg=darkred
"highlight PmenuSel ctermbg=red ctermfg=yellow
colorscheme desert
"let g:winManagerWindowLayout='FileExplorer|TagList|BufExplorer'
"let g:winManagerWidth=35

"*****************************************************************
"							vundle配置
"*****************************************************************
"设置包括vundle和初始化相关的runtime path
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"让vundle管理插件版本，必须
Plugin 'VundleVim/Vundle.vim'

" 以下范例用来支持不同格式的插件安装.
" 请将安装插件的命令放在vundle#begin和vundle#end之间.
" Github上的插件
" 格式为 Plugin '用户名/插件仓库名'
Plugin 'tpope/vim-fugitive'
" 来自 http://vim-scripts.org/vim/scripts.html 的插件
" Plugin '插件名称' 实际上是 Plugin 'vim-scripts/插件仓库名' 只是此处的用户名可以省略
Plugin 'L9'
" 由Git支持但不再github上的插件仓库 Plugin 'git clone 后面的地址'
"Plugin 'git://git.wincent.com/command-t.git'
" 本地的Git仓库(例如自己的插件) Plugin 'file:///+本地插件仓库绝对路径'
"Plugin 'file:///home/gmarik/path/to/plugin'
" 插件在仓库的子目录中.
" 正确指定路径用以设置runtimepath. 以下范例插件在sparkup/vim目录下
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" 安装L9，如果已经安装过这个插件，可利用以下格式避免命名冲突
"Plugin 'ascenator/L9', {'name': 'newL9'}

"我添加的插件
Plugin 'Valloric/YouCompleteMe'
Plugin 'taglist.vim'
Plugin 'The-NERD-tree'
Plugin 'Syntastic'
Plugin 'Lokaltog/vim-powerline'

" 你的所有插件需要在下面这行之前
call vundle#end()            " 必须
filetype plugin indent on    " 必须 加载vim自带和插件相应的语法和文件类型相关脚本
" 忽视插件改变缩进,可以使用以下替代:
"filetype plugin on
"
" 常用的命令
" :PluginList       - 列出所有已配置的插件
" :PluginInstall     - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
" :PluginSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
" :PluginClean      - 清除未使用插件,需要确认; 追加 `!` 自动批准移除未使用插件
" 查阅 :h vundle 获取更多细节和wiki以及FAQ


"*****************************************************************
"							YCM配置
"*****************************************************************
" YouCompleteMe
set completeopt=longest,menu	"让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
autocmd InsertLeave * if pumvisible() == 0|pclose|endif	"离开插入模式后自动关闭预览窗口
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"	"回车即选中当前项
"上下左右键的行为 会显示其他信息
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"youcompleteme  默认tab  s-tab 和自动补全冲突
"let g:ycm_key_list_select_completion=['<c-n>']
let g:ycm_key_list_select_completion = ['<Down>']
"let g:ycm_key_list_previous_completion=['<c-p>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_confirm_extra_conf=0 "关闭加载.ycm_extra_conf.py提示

let g:ycm_collect_identifiers_from_tags_files=1	" 开启 YCM 基于标签引擎
let g:ycm_min_num_of_chars_for_completion=2	" 从第2个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0	" 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1	" 语法关键字补全
"nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>	"force recomile with syntastic
"nnoremap <leader>lo :lopen<CR>	"open locationlist
"nnoremap <leader>lc :lclose<CR>	"close locationlist
inoremap <leader><leader> <C-x><C-o>
"在注释输入中也能补全
let g:ycm_complete_in_comments = 1
"在字符串输入中也能补全
let g:ycm_complete_in_strings = 1
"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 1

nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR> " 跳转到定义处


let g:syntastic_ignore_files=[".*\.py$"]
let g:ycm_show_diagnostics_ui = 0                           " 禁用语法检查
"leader映射为逗号","
"let mapleader = ","
"g:ycm_global_ycm_extra_conf 定义了全局配置文件，当YCM搜索不到配置文件时
"YCM将导入全局配置文件
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

"********************************************************
"                      Syntastic 配置                   
"********************************************************
"打开文件时自动进行检查
let g:syntastic_check_on_open = 1
let g:syntastic_cpp_include_dirs = ['/usr/include/']
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_check_header = 1
"让syntastic支持c++11
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
"set error or warning signs
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
"whether to show balloons
let g:syntastic_enable_balloons = 1

"*****************************************************************
"							taglist配置
"*****************************************************************
"不显示 "press F1 to disply help"
"let Tlist_Compact_Format = 1
"窗口在右侧显示
"let Tlist_Use_Right_Window = 1
"只显示当前文件的tags
let Tlist_Show_One_File = 1
"当同时显示多个文件的tag时，使taglist只显示当前文件tag，其它文件的tag都被折"
"叠起来
"let Tlist_File_Fold_Auto_Close = 1
"使taglist以tag名字进行排序
let Tlist_Sort_Type = "name"
"高亮显示
let Tlist_Auto_Highlight_tag = 1
"随文件自动更新
let Tlist_Auto_Updata = 1
"自动打开taglist窗口
"let Tlist_Auto_Open = 1
"设置宽度
let Tlist_WinWidth = 30
"设置高度
"let Tlist_WinHeight = 100
"taglist窗口是最后一个窗口，则退出vim
let Tlist_Exit_OnlyWindow = 1
"单击跳转
let Tlist_Use_SingClick = 1
"设置ctags命令的位置
"let Tlist_Ctags_Cmd = "/usr/bin/ctags"
"打开关闭taglist窗口快捷键
nnoremap <silent><F3> :TlistToggle<CR>
"在使用:TlistToggle打开taglist窗口时，光标在taglist窗口
let Tlist_GainFocus_On_ToggleOpen = 1


"********************************************************
"                      NERD_Tree 配置                   
"********************************************************
"显示增强
let NERDChristmasTree=1
"自动调整焦点
let NERDTreeAutoCenter=1
"鼠标模式:目录单击,文件双击
let NERDTreeMouseMode=2
"打开文件后自动关闭
"let NERDTreeQuitOnOpen=0
"显示文件
let NERDTreeShowFiles=1
"显示隐藏文件
let NERDTreeShowHidden=1
"高亮显示当前文件或目录
let NERDTreeHightCursorline=1
"显示行号
"let NERDTreeShowLineNumbers=1
"窗口位置
let NERDTreeWinPos='left'
"窗口宽度
let NERDTreeWinSize=31
"不显示'Bookmarks' label 'Press ? for help'
"let NERDTreeMinimalUI=1
"快捷键
nnoremap <silent> <F2> :NERDTreeToggle<CR>
"当打开vim且没有文件时自动打开NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
"只剩 NERDTree时自动关闭
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif



"********************************************************
"						c,c++ 按<F5>编译运行                  
"********************************************************
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!gcc % -o %<"
		exec "! ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "! ./%<"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!java %<"
	elseif &filetype == 'sh'
		:!./%<
	endif
endfunc

"********************************************************
"						c,c++ 按<F8>调试                  
"********************************************************
map <F8> :call Rungdb()<CR>
func! Rungdb()
	exec "w"
	exec "!gcc % -g -o %<"
	exec "!gdb ./%<"
endfunc

"********************************************************
"						键盘命令                  
"********************************************************
"映射全选+复制 ctrl+a
map <C-A> ggVGY
map! <C-A> <Esc>ggVGY


"********************************************************
"						新文件标题                  
"********************************************************
"新建.c,.h,.sh,自动插入文件头
autocmd BufNewFile *.[ch],*.cpp,*.sh exec ":call SetTitle()"
func SetTitle()
	if &filetype == 'sh'
		call setline(1,"\#!/bin/bash")
		call append(line("."), "")
	else
		call setline(1,"/**********************************************")
		call append(line("."),   "  > File Name		: ".expand("%"))
		call append(line(".")+1, "  > Author			: dasg")
		call append(line(".")+2, "  > Mail			: xxx@xxx.com")
		call append(line(".")+3, "  > Created Time	: ".strftime("%c"))
		call append(line(".")+4, " ****************************************/")
		call append(line(".")+5, "")
	endif
	if expand("%:e") == 'cpp'
		call append(line(".")+6, "#include <iostream>")
		call append(line(".")+7, "using namespace std;")	
		call append(line(".")+8, "")
	endif
	if &filetype == 'c'
		call append(line(".")+6, "#include <stdio.h>")
		call append(line(".")+7, "")
	endif
	if expand("%:e") == 'h'
		call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
		call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
		call append(line(".")+8, "")
	endif
endfunc
"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G
		
"支持中文GB2312编码
let &termencoding=&encoding
set fileencodings=utf-8,gbk,ucs-bom,cp936
