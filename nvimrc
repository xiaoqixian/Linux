filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'rust-lang/rust.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-surround'
Plugin 'gcmt/wildfire.vim'
Plugin 'preservim/nerdcommenter'
Plugin 'voldikss/vim-floaterm'
Plugin 'cespare/vim-toml'
"Plugin 'ervandew/supertab'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'majutsushi/tagbar'
Plugin 'ryanoasis/vim-devicons'
Plugin 'lervag/vimtex'
"Plugin 'hdima/python-syntax'

call vundle#end()

filetype plugin indent on


" fast saving
nmap <leader>w :w!<cr>
" fast source
nmap <leader>sf :source ~/.nvimrc<CR>
nmap <leader>nh :nohl<CR>

" :W sudo saves the file,useful for handling the permission-denied error
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

highlight PMenu ctermfg=225 ctermbg=60 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=225 guifg=darkgrey guibg=black
highlight Comment ctermfg=104 ctermbg=none
highlight Search ctermfg=116 ctermbg=211

"highlight TabLineFill ctermbg=225 ctermfg=NONE
hi TabLineFill guifg=none ctermfg=none guibg=none ctermbg=none gui=none cterm=none
hi TabLineSel guifg=none ctermfg=225 guibg=none ctermbg=none cterm=none
hi TabLine guifg=none ctermfg=255 guibg=none ctermbg=none cterm=none

" syntax highlighting
syntax enable

set guicursor=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

set number
set relativenumber 

let mapleader = ","

set autoread
set ruler

"ignore case when searching
set ignorecase

" Be smart when using tabs ;)
set smarttab
set hlsearch
set incsearch
set noerrorbells
set novisualbell

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set nobackup
set nowb
set noswapfile

""""""""""""""""""""""""""""""""""""""""""""""""
" => mapping
""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap <leader>y y:call system("xclip -selection c", @")<CR>

map <C-down> <C-W>j
map <C-up> <C-W>k
map <C-left> <C-W>h
map <C-right> <C-W>l

nnoremap <space> <C-w>w
inoremap jj <ESC>

nmap <leader>w :w!<cr>
nmap <leader>sf :source ~/.nvimrc<CR>
nmap <leader>nh :nohl<CR>
nmap P "0p
imap II <ESC>"+pa
imap <PageUp> <Home>
imap <PageDown> <End>

" remove next brace if next character is also a brace
function! RemoveNextDoubleChar(char)
	let l:line = getline(".")
	let l:next_char = l:line[col(".")] 

	if a:char == l:next_char
		execute "normal! l"
	else
		execute "normal! i" . a:char . ""
	end
endfunction
inoremap ) <ESC>:call RemoveNextDoubleChar(')')<CR>a
inoremap ] <ESC>:call RemoveNextDoubleChar(']')<CR>a
inoremap } <ESC>:call RemoveNextDoubleChar('}')<CR>a

function! SetCR()
    let l:line = getline(".")
    let l:cur_char = l:line[col(".")]
    
    if l:cur_char == "}"
        execute "normal \<CR>\<ESC>O"
    else
        execute "normal \<End>\<ESC>"
    endif
endfunction

"inoremap <CR> <ESC>:call SetCR()

" Useful mappings for managing tabs
nmap <silent> <tab> :tabnext<cr>
nmap <silent> <S-tab> :tabp<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr>
map <leader>t<leader> :tabnew<cr>
vnoremap <tab> <S-.>

""""""""""""""""""""""""""""""""""""""""""""""""""
" => Buffer New File
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

autocmd BufNewFile * normal G

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme = 'fruit_punch'
let g:airline_mode_map = {}
let g:airline_mode_map['ic'] = 'INSERT'

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

"-----NERTree Settings
map <C-X> :NERDTreeMirror<CR>
map <C-X> :NERDTreeToggle<CR>
"鼠标模式：目录单击，文件双击"
"let NERDTreeMouseMode=2
"语法高亮显示当前文件或目录"
let NERDTreeShowHidden=1
"两边的窗口跳转快捷键 ctrl+w+w"
nnoremap <space> <C-W>w
nnoremap <S-space> <C-W>h

"let g:ycm_auto_trigger = 1

""automatically close pmenu when leave insert moed
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif

""""""""""""""""""""""""""""
"       coc.nvim
""""""""""""""""""""""""""""
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=1000

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
"nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
"" Show commands.
"nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document.
"nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols.
"nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list.
"nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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

"syn keyword pythonStatement self
"hi link pythonClassVar Number

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

nnoremap <silent> K :call <sid>show_documentation()<cr>
function! s:show_documentation()
  if index(['vim', 'help'], &filetype) >= 0
    execute 'help ' . expand('<cword>')
  elseif &filetype ==# 'tex'
    VimtexDocPackage
  else
    call CocAction('doHover')
  endif
endfunction

let g:tex_flavor = 'latex'
