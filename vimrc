
""""""""""""""""""""""""""""""""""""""""""""""""""""
"=>plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
""let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
"Plugin 'Lokaltog/vim-powerline'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'gcmt/wildfire.vim'
Plugin 'preservim/nerdcommenter'
Plugin 'kristijanhusak/vim-carbon-now-sh'
Plugin 'lervag/vimtex'
"Plugin 'zhiyuanlck/vim-float-terminal'
Plugin 'voldikss/vim-floaterm'
Plugin 'rust-lang/rust.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'majutsushi/tagbar'
Plugin 'jayli/vim-easycomplete'
"Plugin 'vim-python/python-syntax'
"Plugin 'prabirshrestha/asyncomplete.vim'
"Plugin 'neoclide/coc.nvim'"
"Plugin 'maralla/completor.vim'
"if has('nvim')
  "Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
  "Plugin 'Shougo/deoplete.nvim'
  "Plugin 'roxma/nvim-yarp'
  "Plugin 'roxma/vim-hug-neovim-rpc'
"endif

call vundle#end()
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""
"set colorscheme
"colorscheme dracula
"set background=dark
"hi Normal ctermbg=252 ctermbg=none
"设置背景透明

set relativenumber
set history=500

filetype plugin on
filetype indent on

"set to autoread when a file is changed from outside
set autoread
au FocusGained,BufEnter * checktime

let mapleader = ","

" fast saving
nmap <leader>w :w!<cr>
" fast source
nmap <leader>sf :source ~/.nvimrc<CR>
nmap <leader>nh :nohl<CR>

" :W sudo saves the file,useful for handling the permission-denied error
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

cnoremap <c-n> <down>
cnoremap <c-p> <up>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"VIM user interface
set so=7

"Avoid garbled characters in Chinese lanuage windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set wildmenu "automatic completion when you press Tab

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Show matching brackets
set showmatch

set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif


" Add a bit extra margin to the left
set foldcolumn=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"YouCompleteMe color set
"highlight PMenu ctermfg=#D8547B ctermbg=#3A506B
highlight PMenu ctermfg=225 ctermbg=60 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=225 guifg=darkgrey guibg=black
highlight Comment ctermfg=104 ctermbg=none
highlight Search ctermfg=116 ctermbg=211

highlight TabLineFill ctermbg=none ctermfg=none

" syntax highlighting
syntax enable

set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set encoding=utf-8
set fencs=utf8,gbk,gb2312,gb18030

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off
set nobackup
set nowb
set noswapfile

set guicursor=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
fun! Visual_paste()
    execute "y"
    call system("echo", @")
    "call system("xclip -selection c", @")
endfunction
vnoremap <leader>y y:call system("xclip -selection c", @")<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
inoremap <C-P> <END><CR>

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>


" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
nmap <silent> <tab> :tabnext<cr>
nmap <silent> <S-tab> :tabp<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr>
map <leader>t<leader> :tabnew<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM -1 to first non-blank character
map -1 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

set number

"inoremap ' ''<ESC>i
"inoremap " ""<ESC>i
"inoremap ( ()<ESC>i
"inoremap [ []<ESC>i
""inoremap { {<CR>}<ESC>O
"inoremap { {}<Esc>i

"映射全选
map <C-A> ggVG
map! <C-A> ggVG

function! SetCR()
    let l:line = getline(".")
    let l:cur_char = l:line[col(".")]
    
    if l:cur_char == "}"
        execute "normal \<CR>\<ESC>O"
    else
        execute "normal \<End>\<ESC>"
    endif
endfunction

""inoremap <CR> <ESC>:call SetCR()

" 按退格键时判断当前光标前一个字符，如果是左括号，则删除对应的右括号以及括号中间的内容
function! RemovePairs()
	let l:line = getline(".")
	let l:previous_char = l:line[col(".")-1] " 取得当前光标前一个字符,col()函数可以获得当前的列数

	if index(["(", "[", "{"], l:previous_char) != -1
		let l:original_pos = getpos(".")
		execute "normal %"
		let l:new_pos = getpos(".") 

        if l:original_pos == l:new_pos:
            execute "normal! a\<BS>"
            return
        end

		let l:line2 = getline(".")
		if len(l:line2) == col(".")
			" 如果右括号是当前行最后一个字符
			execute "normal! v%xa"
		else
			" 如果右括号不是当前行最后一个字符
			execute "normal! v%xi"
        end

    else
        execute "normal! a\<BS>"
	end
endfunction
" 用退格键删除一个左括号时同时删除对应的右括号
""inoremap <BS> <ESC>:call RemovePairs()<CR>a

" 输入一个字符时，如果下一个字符也是括号，则删除它，避免出现重复字符
function! RemoveNextDoubleChar(char)
	let l:line = getline(".")
	let l:next_char = l:line[col(".")] " 取得当前光标后一个字符

	if a:char == l:next_char
		execute "normal! l"
	else
		execute "normal! i" . a:char . ""
	end
endfunction
inoremap ) <ESC>:call RemoveNextDoubleChar(')')<CR>a
inoremap ] <ESC>:call RemoveNextDoubleChar(']')<CR>a
inoremap } <ESC>:call RemoveNextDoubleChar('}')<CR>a
inoremap jj <ESC>

":inoremap <CR> <END><CR>
"inoremap <CR> <END><CR>

" Key map
":nmap <S-Space> <PageDown>

"********************************************************
"						新文件标题
"********************************************************
"新建.c,.h,.sh,.py,.java,.md,自动插入文件头
autocmd BufNewFile *.[ch],*.cpp,*.sh,*.py,*.java,*.md,*.rs exec ":call SetTitle()"
func SetTitle()
	if expand("%:e") == 'sh'
		call setline(1,"\#!/bin/bash")
		call append(line("."), "")
    elseif expand("%:e") == 'py'
        call setline(1, "# !/usr/bin/python3")
        call setline(2, "# -*- coding: utf-8 -*-")
        call setline(3, "# > Author          : lunar")
        call setline(4, "# > Email           : lunar_ubuntu@qq.com")
        call setline(5, "# > Created Time    : ".strftime("%c")) 
        call setline(6, "# > Location        : Shanghai")
        call setline(7, "# > Copyright@ https://github.com/xiaoqixian")
        call setline(8, "")
    "在markdown文件中加入yaml头部
    elseif expand("%:e") == 'md'
        call setline(1, "---")
    call setline(2, "author: lunar")
    call setline(3, "date: ".strftime("%c"))
    call setline(4, "location: Shanghai")
    call setline(5, "---")
    call setline(6, "")
else
    call setline(1,"/**********************************************")
    call append(line("."),   "  > File Name		: ".expand("%"))
    call append(line(".")+1, "  > Author		    : lunar")
    call append(line(".")+2, "  > Email			: lunar_ubuntu@qq.com")
    call append(line(".")+3, "  > Created Time	: ".strftime("%c"))
    call append(line(".")+4, "  > Location        : Shanghai")
    call append(line(".")+5, "  > Copyright@ https://github.com/xiaoqixian")
    call append(line(".")+6, " **********************************************/")
    call append(line(".")+7, "")
endif
if expand("%:e") == 'cpp'
    call append(line(".")+9, "#include <iostream>")
    call append(line(".")+10, "using namespace std;")
    call append(line(".")+11, "")
endif
if expand("%:e") == 'h'
    "call append(line(".")+9, "#ifndef _".toupper(expand("%:r"))."_H")
    "call append(line(".")+10, "#define _".toupper(expand("%:r"))."_H")
    "call append(line(".")+11, "")
    call setline(9, "#ifndef _".toupper(expand("%:r"))."_H")
    call setline(10, "#define _".toupper(expand("%:r"))."_H")
    call setline(11, "")
    call setline(12, "")
    call setline(13, "")
    call setline(14, "#endif /* _".toupper(expand("%:r"))."_H*/")
endif
if expand("%:e") == 'hpp'
    call append(line(".")+9, "#ifndef ".toupper(expand("%:r"))."_HPP")
    call append(line(".")+10, "#define _".toupper(expand("%:r"))."_HPP")
    call append(line(".")+11, "")
endif
endfunc
"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G


"************************************************
"               YCM配置
"************************************************
"让vim的补全菜单行为与一般IDE一致
"set completeopt=longest,menu

""离开插入模式后自动关闭预览窗口
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

let g:ycm_min_num_of_chars_for_completion = 3
let g:ycm_complete_in_comments = 0
let g:ycm_complete_in_strings = 0
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_show_diagnostics_ui = 0

let g:ycm_global_ycm_extra_conf= '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'

let g:ycm_filetype_specific_completion_to_disable = {
        \ 'cpp': 1,
        \ 'c': 1
        \}

""""""""""NERDTree Configuration""""""""""
""autocmd vimenter * NERDTree
map <C-X> :NERDTreeMirror<CR>
map <C-X> :NERDTreeToggle<CR>
"鼠标模式：目录单击，文件双击"
let NERDTreeMouseMode=2
"语法高亮显示当前文件或目录"
let NERDTreeShowHidden=1
"两边的窗口跳转快捷键 ctrl+w+w"
nnoremap <space> <C-W>w
nnoremap <S-space> <C-W>h
"只剩NERDTree时自动关闭
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"********************************************************
"          c,c++,java,shell 按<F5>编译运行                  
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
elseif &filetype == 'py'
    exec "!python %"
endif
endfunc

"--- paste across terminals
let g:copy_file=$HOME . "/.vim_copybuffer"
function Write_copy_file()
"write what in the @" buffer into the file
let lines=split(@", "\n")
call writefile(lines,g:copy_file)
endfunction

function Read_copy_file()
"write what in the @" buffer into the file and paste it
let l:buf=readfile(g:copy_file)
let @"=join(l:buf,"\n")
normal ""p
endfunction
nmap <silent> ;y :call Write_copy_file()<Enter>
nmap <silent> ;p :call Read_copy_file()<Enter>

"----carbon-now-sh settings
let g:carbon_now_sh_browser = 'chromium'
vnoremap <F6> :CarbonNowSh<CR>
let g:carbon_now_sh_options = {'t': 'synthwave-84'}

"----vim latex settings
let g:tex_flavor = 'latex'
let g:vimtex_quickfix_mode = 0 "cancel error fix window pops up
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_method = 'general'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
"LaTeX配置
let g:vimtex_texcount_custom_arg=' -ch -total'
"映射VimtexCountWords！\lw 在命令模式下enter此命令可统计中英文字符的个数
au FileType tex map <buffer> <silent>  <leader>lw :VimtexCountWords!  <CR><CR>
let g:Tex_ViewRule_pdf = 'okular -reuse-instance -inverse-search "gvim -c \":RemoteOpen +\%l \%f\""'

"这里是LaTeX编译引擎的设置，这里默认LaTeX编译方式为-pdf(pdfLaTeX),
"vimtex提供了magic comments来为文件设置编译方式
"例如，我在tex文件开头输入 % !TEX program = xelatex   即指定-xelatex （xelatex）编译文件
let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-pdf',
    \ 'pdflatex'         : '-pdf',
    \ 'dvipdfex'         : '-pdfdvi',
    \ 'lualatex'         : '-lualatex',
    \ 'xelatex'          : '-xelatex',
    \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
    \ 'context (luatex)' : '-pdf -pdflatex=context',
    \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
    \}
"这里是设置latexmk工具的可选参数
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-shell-escape',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

" 阅读器相关的配置 包含正反向查找功能 仅供参考
"let g:vimtex_view_general_viewer = 'E:\LaTeX\SumatraPDF\SumatraPDF.exe' "这里放置你的sumatrapdf 安装路径
let g:vimtex_view_general_options_latexmk = '-reuse-instance'
let g:vimtex_view_general_options
\ = '-reuse-instance -forward-search @tex @line @pdf'
\ . ' -inverse-search "' . exepath(v:progpath)
\ . ' --servername ' . v:servername
\ . ' --remote-send \"^<C-\^>^<C-n^>'
\ . ':execute ''drop '' . fnameescape(''\%f'')^<CR^>'
\ . ':\%l^<CR^>:normal\! zzzv^<CR^>'
\ . ':call remote_foreground('''.v:servername.''')^<CR^>^<CR^>\""'

"编译过程中忽略警告信息
let g:vimtex_quickfix_open_on_warning=0


"----Float Terminal Settings
let g:floaterm_shell = "zsh"
"let g:floaterm_keymap_new = '<leader>n'
noremap <leader>n :FloatermNew --cmd="<root>"<CR>
let g:floaterm_keymap_prev = '<leader>fp'
let g:floaterm_keymap_next = '<leader>fn'
let g:floaterm_keymap_toggle = '<leader>ft'
let g:floaterm_keymap_kill = '<leader>fk'
let g:floaterm_keymap_hide = '<leader>fh'
tnoremap <silent> <leader>a :<C-\><C-n>

let g:airline_theme = 'fruit_punch'
let g:airline_mode_map = {}
let g:airline_mode_map['ic'] = 'INSERT'

""""""""""""""""""""""""""""""""""""""""""""
"         COC Configuration
""""""""""""""""""""""""""""""""""""""""""""
"Textedit might fail if hidden is not set.
"set hidden

""Always show the signcolumn, otherwise it would shift the text each time
"if has("patch-8.1.1564")
"set signcolumn=number
"else
"set signcolumn=yes
"endif

"set updatetime=300

""Use tab for trigger completion with charaters ahead and navigate.
"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? "\<C-n>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"function! s:check_back_space() abort
    "let col = col('.') - 1
    "return !col || getline('.')[col - 1] =~# '\s'
"endfunction

""""""""""""""""""""""""""""""""""""""""""""""""
"              Tagbar Configuration
""""""""""""""""""""""""""""""""""""""""""""""""
let tagbar_right=1
nnoremap <leader>v :TagbarToggle<CR>
let tagbar_width=32
"Don't show redundant help information
let g:tagbar_compact=1
"let g:tagbar_ctags_bin="/home/lunar/clones/ctags/ctags"
let g:tagbar_ctags_bin="/usr/bin/ctags"
"What kinds of code identifiers for ctags to generate labels
let g:tagbar_type_cpp = {
    \ 'kinds' : [
         \ 'c:classes:0:1',
         \ 'd:macros:0:1',
         \ 'e:enumerators:0:0', 
         \ 'f:functions:0:1',
         \ 'g:enumeration:0:1',
         \ 'l:local:0:1',
         \ 'm:members:0:1',
         \ 'n:namespaces:0:1',
         \ 'p:functions_prototypes:0:1',
         \ 's:structs:0:1',
         \ 't:typedefs:0:1',
         \ 'u:unions:0:1',
         \ 'v:global:0:1',
         \ 'x:external:0:1'
     \ ],
     \ 'sro'        : '::',
     \ 'kind2scope' : {
         \ 'g' : 'enum',
         \ 'n' : 'namespace',
         \ 'c' : 'class',
         \ 's' : 'struct',
         \ 'u' : 'union'
     \ },
     \ 'scope2kind' : {
         \ 'enum'      : 'g',
         \ 'namespace' : 'n',
         \ 'class'     : 'c',
         \ 'struct'    : 's',
         \ 'union'     : 'u'
     \ }
\ }

"""""""""""""""""""""""""""""""""
""  completor configuration 
""""""""""""""""''"""""""""""""""
"let g:completor_clang_binary = '/usr/bin/clang'
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <expr> <cr> pumvisible() ? "\<cr>" : "\<cr>"
"let g:completor_auto_trigger = 0 "use tab to trigger completion
"inoremap <expr> <Tab> pumvisible() ? "<C-N>" : "<C-R>=completor#do('complete')<CR>"
"

"""""""""""""""""""""""""""""""""""
"""" deoplete configuration
"""""""""""""""""""""""""""""""""""
""<TAB> to select candidates.
"function! s:check_back_space() abort "{{{
  "let col = col('.') - 1
  "return !col || getline('.')[col - 1]  =~ '\s'
"endfunction"}}}
"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? "\<C-n>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ deoplete#manual_complete()
let g:python_highlight_all = 1

""""""""""""""""""""""""
" add python syntax highlighting
"""""""""""""""""""""""
if v:version >= 508 || !exists('did_python_syn_inits')
    if v:version <= 508
        let did_python_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif
    syn keyword pythonClassVar self
    HiLink pythonClassVar Number
    delcommand HiLink
endif

syntax match OperatorChars "?\|+\|-\|\*\|;\|:\|,\|<\|>\|&\||\|!\|\~\|%\|=\|)\|(\|{\|}\|\.\|\[\|\]\|/\(/\|*\)\@!"
hi OperatorChars guifg=#56faa3 ctermfg=225 gui=None
