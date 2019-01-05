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
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'flazz/vim-colorschemes'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim', { 'for': 'markdown'}
Plug 'junegunn/limelight.vim', { 'for': 'markdown'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'mileszs/ack.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'henrik/vim-qargs'
if has('nvim')
  Plug 'equalsraf/neovim-gui-shim'
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
  Plug 'ncm2/ncm2'
  Plug 'ncm2/ncm2-path'
  " Plug 'ncm2/ncm2-tagprefix'
  Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
  Plug 'ncm2/ncm2-neoinclude' | Plug 'Shougo/neoinclude.vim'
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
  Plug 'roxma/nvim-yarp'
  " set root directory to detected one
  Plug 'airblade/vim-rooter'
else
  Plug 'valloric/youcompleteme'
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
else
  " youcompleteme config
  nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
  nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
  nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
endif

" ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" ctrlp config
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,*/node_modules/*
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" indent guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

" ale configuration
let g:ale_statusline_format = ['â¨‰ %d', 'âš  %d', 'â¬¥ ok']
let g:ale_sign_column_always = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_linters_explicit = 1
let g:ale_linters = { 'typescript': ['tslint', 'tsserver'], 'javascript': ['eslint', 'flow'], 'ruby': [], }

" airline configuration
let g:airline_powerline_fonts = 1

" configure tests
function! ContainerTransform(cmd) abort
  if filereadable('Vagrantfile')
    return 'vssh '.shellescape(a:cmd)
  endif
  if filereadable('docker-compose.yml')
    return 'docker-compose run app '.shellescape(a:cmd)
  endif
  return a:cmd
endfunction

if has('nvim')
  let g:test#strategy = 'neovim'
endif
let test#javascript#mocha#file_pattern = '\vtests?/.*\.(ts|js|jsx|coffee)$'
let test#javascript#mocha#executable = 'node_modules/.bin/mocha'
let test#javascript#jest#executable = 'node_modules/.bin/jest'
let g:test#custom_transformations = {'container': function('ContainerTransform')}
let g:test#transformation = 'container'
nmap <silent> t<C-n> :TestNearest<CR> " t Ctrl+n
nmap <silent> t<C-f> :TestFile<CR>    " t Ctrl+f
nmap <silent> t<C-s> :TestSuite<CR>   " t Ctrl+s
nmap <silent> t<C-l> :TestLast<CR>    " t Ctrl+l
nmap <silent> t<C-g> :TestVisit<CR>   " t Ctrl+g

" LanguageClient configuration
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'ruby': ['/usr/local/bin/solargraph', 'stdio'],
    \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1
let g:LanguageClient_windowLogMessageLevel = 'Error'

nnoremap <silent> d<C-s> :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> d<C-d> :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" let g:loaded_airline = 1
if exists('g:GuiLoaded')
  GuiFont FuraCode\ NF:h14
endif
