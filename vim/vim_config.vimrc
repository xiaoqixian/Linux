"meta settings
filetype plugin indent on
set number
set relativenumber
set backspace=indent,eol,start

"highlight/color settings
highlight PMenu ctermfg=225 ctermbg=60 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=225 guifg=darkgrey guibg=black
highlight Comment ctermfg=104 ctermbg=none
highlight Search ctermfg=116 ctermbg=211

hi TabLineFill ctermfg=none ctermbg=none gui=none cterm=none
hi TabLineSel ctermfg=225 ctermbg=none
hi TabLine ctermfg=255 ctermbg=none cterm=none

syntax enable

let $LANG="en"

set noerrorbells
set novisualbell

set lbr
set tw=500 "set max text width

set mouse=a "enable scrolling with mouse wheel"

"auto refresh when a file has been 
"detected to have been changed outside
set autoread

"show the line and column number of the cursor position.
set ruler

"pair settings
set mps+=<:> "pairs match hightlights

"search settings
set hlsearch
set incsearch
set ignorecase

"indent settings
set smartindent
set wrap "wrap lines

"tab settings
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

"auto set header for some filetypes
autocmd BufNewFile *.sh,*.cpp,*.c,*.rs,*.java,*.py call SetHeader()

function! SetHeader()
    let extension = expand("%:e")
    if extension == "py" || extension == "sh"
        let comment_symbol = "#"
    endif
    call setline(1, comment_symbol." Date: ".strftime("%c"))
    call append(line("."), comment_symbol." Mail: lunar_ubuntu@qq.com")
    call append(line(".")+1, comment_symbol." Author: https://github.com/xiaoqixian")
    call append(line(".")+2, "")
    norm! G
endfunction

"mapping
let mapleader = ","

"normal mapping
nmap <leader>w :w!<CR>
nmap <leader>sf :source ~/.vimrc<CR>

"remapping actions for cursor moving between windows
nmap K <C-w>k
nmap J <C-w>j
nmap L <C-w>l
nmap H <C-w>h
nmap <Space> <C-w>w

"remove highligh
nmap <leader>nh :nohl<CR>

"tab window mapping
noremap <silent> <tab> :tabnext<CR>
noremap <silent> <S-tab> :tabp<CR>
map <leader>tc :tabclose<CR>
map <leader>t<leader> :tabnew<CR>
"make tab to shift width in visual mode
vnoremap <tab> <S-.>

"special mapping, replace [ to { and ] to } in the current line
nmap <leader>zz :.s/\[/{/g<CR>:.s/\]/}/g<CR>:nohl<CR>

"open .vimrc in split window
nnoremap <leader>sv :sp ~/.vimrc<CR>
nnoremap <leader>vv :vs ~/.vimrc<CR>

"insert mapping
inoremap jj <ESC>

"complete mapping
"optional for lite version that without any plugins
"function! s:CheckBackSpace()
	"let col = col('.') - 1
	"return !col || getline('.')[col - 1] =~# '\s'
"endfunction

"inoremap <silent><expr> <TAB> <SID>CheckBackSpace() ? "\<TAB>" : "\<C-n>"

"plugins management
call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'valloric/youcompleteme'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'jiangmiao/auto-pairs'
Plug 'voldikss/vim-floaterm'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'cespare/vim-toml'
"Plug 'sirver/ultisnips'
Plug 'gko/vim-coloresque'

call plug#end()

"vim airline theme
let g:airline_theme = 'fruit_punch'

"ycm
let g:ycm_enable_semantic_highlighting = 1
let g:ycm_enable_inlay_hints = 1
let g:ycm_global_ycm_extra_conf = "~/.ycm_extra_conf.py"
let g:ycm_complete_in_strings = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_list_stop_completion = ['<C-y>']
let g:ycm_show_detailed_diag_in_popup = 1
let g:ycm_key_detailed_diagnostics = '<leader>d'
let g:ycm_auto_hover = ''

hi link YcmInlayHint Comment

autocmd BufRead * let b:ycm_hover = {
            \ 'command': 'GetDoc',
            \ 'syntax': &filetype
            \ }

nnoremap <silent> <leader>h <Plug>(YCMToggleInlayHints)
nnoremap <silent> <leader>ss <Plug>(YCMFindSymbolInWorkspace)
nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>gti :YcmCompleter GoToInclude<CR>
nnoremap <silent> <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <silent> <leader>gi :YcmCompleter GoToImplementation<CR>
nnoremap <silent> <leader>gc :YcmCompleter GoToCallers<CR>
nnoremap <silent> M <Plug>(YCMHover)


"nerdtree
nnoremap <silent> <leader>e :NERDTreeToggle<CR>
nnoremap <silent> <leader>nf :NERDTreeFind<CR>
"
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
"
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
            \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
"
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif


"vim-floaterm
nnoremap <silent> <leader>ft :FloatermToggle<CR>
nnoremap <silent> <leader>fn :FloatermNext<CR>
nnoremap <silent> <leader>fp :FloatermPrev<CR>
"toggole floaterm in terminal mode
tnoremap <silent> <leader>ft <C-\><C-n>:FloatermToggle<CR>
