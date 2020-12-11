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
Plug 'tpope/vim-repeat' " repeat plugin actions with dot
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar' " file browsing with -
Plug 'rhysd/committia.vim', { 'for': 'gitcommit' } " better looking git commit
Plug 'vim-test/vim-test' " run tests for different languages
Plug 'bronson/vim-trailing-whitespace' " highlight trailing whitespaces
Plug 'christoomey/vim-system-copy'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'flazz/vim-colorschemes'
Plug 'jiangmiao/auto-pairs'
Plug 'stephpy/vim-yaml'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'yarn install'}
Plug 'neoclide/coc-sources'
Plug 'airblade/vim-rooter' " set root directory to detected one
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'junegunn/vim-easy-align'
Plug 'vimwiki/vimwiki'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'christianrondeau/vim-base64'
Plug 'drewtempelmeyer/palenight.vim'

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
autocmd FileType markdown setlocal wrap linebreak
autocmd FileType markdown setlocal spell
set showmatch      " highlight matching bracket
set lazyredraw     " redraw only when we need to.
set noshowmode     " don't show current mode
set showcmd        " show current command

set laststatus=2   " Always display the status line
set background=dark
colorscheme palenight
let g:airline_theme = "palenight"
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif
" Italics for my favorite color scheme
let g:palenight_terminal_italics=1

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

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

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

" fzf
nnoremap <C-p> :GFiles<Cr>
nnoremap <C-f> :call fzf#vim#ag(expand('<cword>'))<Cr>

" indent guides
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

" ale configuration
let g:ale_sign_column_always = 1
let g:ale_linters_explicit = 1
let g:ale_linters = { 'typescript': ['tslint'], 'javascript': ['eslint', 'flow'], 'ruby': [], }
let g:ale_fixers = { 'typescript': ['tslint', 'prettier'] }
" let g:ale_fix_on_save = 1

" airline configuration
let g:airline_powerline_fonts = 1

" configure tests
function! ContainerTransform(cmd) abort
  if filereadable('Vagrantfile')
    return 'vssh '.shellescape(a:cmd)
  endif
  if filereadable('docker-compose.local.yml') && filereadable('docker-compose.yml')
    return 'docker-compose -f docker-compose.yml -f docker-compose.local.yml run --rm node-tests '.(a:cmd)
  elseif filereadable('docker-compose.yml')
    return 'docker-compose run --rm node-tests '.(a:cmd)
  endif
  return a:cmd
endfunction

if has('nvim')
  let g:test#strategy = 'neovim'
endif
let test#javascript#mocha#executable = 'npm test'
" let test#javascript#mocha#file_pattern = '\vtests?/.*\.(ts|js|jsx|coffee)$'
let test#javascript#jest#executable = 'npm test'
" let g:test#custom_transformations = {'container': function('ContainerTransform')}
" let g:test#transformation = 'container'
nmap <silent> t<C-n> :TestNearest<CR> " t Ctrl+n
nmap <silent> t<C-f> :TestFile<CR>    " t Ctrl+f
nmap <silent> t<C-s> :TestSuite<CR>   " t Ctrl+s
nmap <silent> t<C-l> :TestLast<CR>    " t Ctrl+l
nmap <silent> t<C-g> :TestVisit<CR>   " t Ctrl+g

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
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
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }

au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

let g:rooter_patterns = ['package.json', 'Makefile', '.git', '.git/']

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
