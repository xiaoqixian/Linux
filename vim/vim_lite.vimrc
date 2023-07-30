"Notice: This is a lite version of my vim ocnfig file 
"without any plugins and with minimal completion and mappings.
"It's quite useful and lite when using vim on remote server.


"meta settings
set number
set relativenumber

syntax enable

let $LANG="en"

set noerrorbells
set novisualbell

set lbr
set tw=500 "set max text width

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

"highlight/color settings
highlight PMenu ctermfg=225 ctermbg=60 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=225 guifg=darkgrey guibg=black
highlight Comment ctermfg=104 ctermbg=none
highlight Search ctermfg=116 ctermbg=211

"mapping
let mapleader = ","

"normal mapping
nmap <leader>w :w!<CR>
nmap <leader>sf :source ~/.vimrc<CR>

"remapping actions for cursor moving between windows
nmap <S-up> <C-w>k
nmap <S-down> <C-w>j
nmap <S-right> <C-w>l
nmap <S-left> <C-w>h
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

"insert mapping
inoremap jj <ESC>

"complete mapping
function! s:CheckBackSpace()
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <TAB> <SID>CheckBackSpace() ? "\<TAB>" : "\<C-n>"
