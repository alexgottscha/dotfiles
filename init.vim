set background=dark
set nohlsearch
set clipboard=unnamedplus
set smartcase
set mouse=
set listchars=tab:>\ ,trail:-,eol:$

call plug#begin()
"color schemes
Plug 'liuchengxu/space-vim-dark'

"syntax highlighting and code features
Plug 'Yggdroot/indentLine'
Plug 'fatih/vim-go'
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-terraform'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'obreitwi/vim-sort-folds'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'stephpy/vim-yaml'

call plug#end()  " Automatically executes filetype plugin indent on and syntax enable.
                 " You can revert the settings after the call. e.g. filetype indent off, syntax off, etc.

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 conceallevel=0
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 conceallevel=0
autocmd FileType sh setlocal shiftwidth=2 tabstop=2
autocmd FileType Jenkinsfile setlocal shiftwidth=2 tabstop=2
autocmd BufRead,BufNewFile *.tpl set filetype=terraform
autocmd BufRead,BufNewFile *.tmpl set filetype=terraform
autocmd BufRead,BufNewFile *.tpl set syntax=terraform
autocmd BufRead,BufNewFile *.tmpl set syntax=terraform
"autocmd BufRead,BufNewFile *.json set syntax=javascript

set expandtab
set conceallevel=0
noremap = :Tab /=<CR>
highlight Visual cterm=reverse ctermbg=NONE
let g:pymode_python = 'python3'
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1

" Vertical Split Buffer Function
function VerticalSplitBuffer(buffer)
    execute "vert belowright sb" a:buffer 
endfunction

" Vertical Split Buffer Mapping
command -nargs=1 Vsbuffer call VerticalSplitBuffer(<f-args>)

if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
endif
set number
