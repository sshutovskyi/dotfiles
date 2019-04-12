set nocompatible              " be iMproved, required
filetype off                  " required

" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
  execute '!mkdir -p ~/.vim/plugged'
  execute '!mkdir -p ~/.vim/autoload'
  execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-eunuch' " helpers for UNIX
Plug 'tpope/vim-sleuth' " autodetect indentation rules
Plug 'rhysd/committia.vim', { 'for': 'gitcommit' }
Plug 'janko-m/vim-test'
Plug 'bronson/vim-trailing-whitespace'
Plug 'christoomey/vim-system-copy'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'flazz/vim-colorschemes'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim', { 'for': 'markdown'}
Plug 'junegunn/limelight.vim', { 'for': 'markdown'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
if has('nvim')
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
  Plug 'ncm2/ncm2'
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
  Plug 'roxma/nvim-yarp'
  " set root directory to detected one
  Plug 'airblade/vim-rooter'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
else
endif

call plug#end()
filetype plugin indent on
filetype plugin on
syntax enable
set omnifunc=syntaxcomplete#Complete

" set swap files directory
set directory=$HOME/.vim/swapfiles/
set undofile
set undodir=$HOME/.vim/undo/

" Set standard file encoding
set encoding=utf8
" No special per file vim override configs
set nomodeline

set mouse=a

" display options
set relativenumber
set number
set nowrap

" only for markdown
autocmd FileType markdown setlocal wrap
set showmatch      " highlight matching bracket
set lazyredraw     " redraw only when we need to.
set noshowmode     " don't show current mode
set showcmd        " show current command

set laststatus=2   " Always display the status line
colorscheme Tomorrow-Night

" configuration
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab
set visualbell
set autoindent
set backspace=indent,eol,start
set nojoinspaces               " Prevents inserting two spaces after punctuation on a join (J)
set splitright                 " Puts new vsplit windows to the right of the current
set splitbelow                 " Puts new split windows to the bottom of the current
" set autochdir
set autoread
set wildmenu                   " visual autocomplete for command menu
set hidden
set colorcolumn=80,120 " show ruler on columns 80 and 120

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" search options
set ignorecase
set smartcase " all lowercase search is case insensitive
set hlsearch  " hightlight matches
set incsearch " search as the characters are entered

" fold
set foldenable
set foldlevelstart=1
set foldmethod=syntax
autocmd BufNewFile,BufReadPost *.coffee setl foldmethod=indent

let mapleader=","

" map H and L to switch tabs
nmap L gt
nmap H gT

" maintain visual mode after ><
vmap < <gv
vmap > >gv

" add :FormatJSON command to prettify json
com! FormatJSON %!python -m json.tool

" autocompletion
if has('nvim')
  " enable ncm2 for all buffers
  autocmd BufEnter * call ncm2#enable_for_buffer()

  " IMPORTANTE: :help Ncm2PopupOpen for more information
  set completeopt=noinsert,menuone,noselect
  " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
  " found' messages
  set shortmess+=c

  " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
  inoremap <c-c> <ESC>

  " When the <Enter> key is pressed while the popup menu is visible, it only
  " hides the menu. Use this mapping to close the menu and also start a new
  " line.
  inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

  " Use <TAB> to select the popup menu:
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
endif

" fzf
nnoremap <C-p> :Files<Cr>
nnoremap <C-f> :Rg<Cr>

" indent guides
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

" ale configuration
let g:ale_sign_column_always = 1
let g:ale_linters_explicit = 1
let g:ale_linters = { 'typescript': ['tslint'], 'javascript': ['eslint', 'flow'], 'ruby': [], }
let g:ale_fixers = { 'typescript': ['tslint', 'prettier'] }
let g:ale_fix_on_save = 1

" airline configuration
let g:airline_powerline_fonts = 1

" configure tests
function! ContainerTransform(cmd) abort
  if filereadable('Vagrantfile')
    return 'vssh '.shellescape(a:cmd)
  endif
  if filereadable('docker-compose.yml')
    return 'docker-compose run --rm app '.(a:cmd)
  endif
  return a:cmd
endfunction

if has('nvim')
  let g:test#strategy = 'neovim'
endif
let test#javascript#mocha#executable = 'node_modules/.bin/mocha'
let test#javascript#mocha#file_pattern = '\vtests?/.*\.(ts|js|jsx|coffee)$'
let test#javascript#jest#executable = 'npm test -- --rootDir=. --testRegex="(src/.*\.spec\.ts|test/.*\.e2e-spec\.ts)$"'
let g:test#custom_transformations = {'container': function('ContainerTransform')}
let g:test#transformation = 'container'
nmap <silent> t<C-n> :TestNearest<CR> " t Ctrl+n
nmap <silent> t<C-f> :TestFile<CR>    " t Ctrl+f
nmap <silent> t<C-s> :TestSuite<CR>   " t Ctrl+s
nmap <silent> t<C-l> :TestLast<CR>    " t Ctrl+l
nmap <silent> t<C-g> :TestVisit<CR>   " t Ctrl+g

" LanguageClient configuration
let g:LanguageClient_serverCommands = {
    \ 'typescript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'ruby': ['/usr/local/bin/solargraph', 'stdio'],
    \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1
let g:LanguageClient_windowLogMessageLevel = 'Error'

nnoremap <silent> d<C-s> :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> d<C-d> :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> d<C-r> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> d<C-f> :call LanguageClient_textDocument_codeAction()<CR>
