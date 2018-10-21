set shell=/bin/zsh

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif

function! IsWork()
    return filereadable(glob("~/wdf/work.vim"))
endfunction

let mapleader = ","

" +---------+
" | plugins |
" +---------+

call plug#begin('~/.vim/plugged')

" Workflow {{{
"Plug 'tpope/vim-fugitive' 
"  nmap <leader>gb :Gblame<cr>
"  nmap <leader>gc :Gcommit<cr>
"  nmap <leader>gp :Gpush<cr>
"Plug 'airblade/vim-gitgutter'
"  let g:gitgutter_map_keys = 0
"  nmap <leader>ga <Plug>GitGutterStageHunk
"  nmap <leader>gu <Plug>GitGutterUndoHunk
"  " nmap <leader>gp <Plug>GitGutterPreviewHunk
"  nmap <leader>g] <Plug>GitGutterNextHunk
"  nmap <leader>g[ <Plug>GitGutterPrevHunk
Plug 'joetoth/simpleterm.vim'

Plug 'mbbill/undotree' 
  nnoremap <leader>u :UndotreeToggle<cr>

" File Management {{{
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim' " {{{
  nnoremap <c-F> <esc>:Files<cr>
  nnoremap <leader>, <esc>:Files<cr>
  nnoremap <leader>zh <esc>:History<cr>
  nnoremap <leader>zg <esc>:GFiles<cr>
  nnoremap <leader>s <esc>:Ag<cr>
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeFind' }
  nmap <leader>n :NERDTreeFind<CR>
  nnoremap <leader>N :NERDTreeToggle<CR>
  augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
          \  if isdirectory(expand('<amatch>'))
          \|   call plug#load('nerdtree')
          \|   execute 'autocmd! nerd_loader'
          \| endif
  augroup END
Plug 'junegunn/vim-peekaboo' " Registers / Copy / Paste

" Search & Replace
"Plug 'haya14busa/incsearch.vim'

" Syntax {{{
Plug 'tpope/vim-commentary'
  map  gc  <Plug>Commentary
  nmap gcc <Plug>CommentaryLine
"Plug 'sheerun/vim-polyglot'  
"Plug 'vim-syntastic/syntastic'
"Vim syntax for Elsa, the lambda calculus evaluator.
" Plug 'alxyzc/lc.vim'

" Interface {{{
Plug 'mhinz/vim-startify' " {{{
  nnoremap <leader>st :Startify<cr>
" }}}

" Motion {{{
Plug 'easymotion/vim-easymotion' " {{{
"Plug 'christoomey/vim-tmux-navigator' " {{{


" Themes {{{
Plug 'chriskempson/vim-tomorrow-theme'

" Language Server
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
"   if executable('pyls')
"       " pip install python-language-server
"       au User lsp_setup call lsp#register_server({
"           \ 'name': 'pyls',
"           \ 'cmd': {server_info->['pyls']},
"           \ 'whitelist': ['python'],
"           \ })
"   endif
"   if executable('clangd')
"       au User lsp_setup call lsp#register_server({
"           \ 'name': 'clangd',
"           \ 'cmd': {server_info->['clangd']},
"           \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
"           \ })
"   endif
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
" noremap <c-g> :LspDefinition<cr>
Plug 'natebosch/vim-lsc'
let g:lsc_server_commands = {
      \ 'c': '/google/bin/releases/editor-devtools/ciderlsp',
      \ 'cpp': '/google/bin/releases/editor-devtools/ciderlsp',
      \ 'go': '/google/bin/releases/editor-devtools/ciderlsp',
      \ 'objc': '/google/bin/releases/editor-devtools/ciderlsp',
      \ 'objcpp': '/google/bin/releases/editor-devtools/ciderlsp',
      \ }
" Enable default mappings (support is language/LSP dependent)
let g:lsc_auto_map = v:true

call plug#end()

command! PI PlugInstall
command! PU PlugUpdate | PlugUpgrade

" }}}
"
"
" ============================================================================
" AUTOCMD {{{
" ============================================================================
"
augroup NAME_OF_GROUP
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC
augroup end

augroup vimrc
  " Remove all commands otherwise when saving it keeps adding commands
  autocmd! 
  au BufWritePost vimrc,.vimrc nested if expand('%') !~ 'fugitive' | source % | endif

  " IndentLines
  au FileType slim IndentLinesEnable

  " File types
  au BufNewFile,BufRead .xonshrc               set filetype=python
  au BufNewFile,BufRead *.cc               set filetype=cpp
  au BufNewFile,BufRead Dockerfile*         set filetype=dockerfile

  " Close preview window
  if exists('##CompleteDone')
    au CompleteDone * pclose
  else
    au InsertLeave * if !pumvisible() && (!exists('*getcmdwintype') || empty(getcmdwintype())) | pclose | endif
  endif

  " Automatic rename of tmux window
  if exists('$TMUX') && !exists('$NORENAME')
    au BufEnter * if empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
    au VimLeave * call system('tmux set-window automatic-rename on')
  endif
augroup END



" +-------------+
" | indentation |
" +-------------+
" {{{

" Change tabs to spaces
set expandtab

" Two-space tabwidth
set sw=2
set softtabstop=2

" auto-indent
set ai

" 2-space indents in c/c++/java/python files
autocmd FileType c set sw=2
autocmd FileType c set softtabstop=2
autocmd FileType cpp set sw=2
autocmd FileType cpp set softtabstop=2
autocmd FileType java set sw=2
autocmd FileType java set sw=2
autocmd FileType py set softtabstop=2
autocmd FileType py set softtabstop=2

" }}}

" +--------------+
" | visual aides |
" +--------------+
" {{{

" Enable syntax highlighting
syntax on

" Highlight the current line
set cursorline

" Show line numbers
set nu

" 256 colors
set t_Co=256
set t_ut=

" Set the color scheme
colors Tomorrow-Night
set bg=dark

" colorcolumn
silent! set colorcolumn=80

" }}}

" +----------------+
" | normalize keys |
" +----------------+
" {{{
 
" Make backspace work right.
"
set backspace=indent,eol,start

" auto-complete comments
set fo+=r

" }}}

" +--------+
" | search |
" +--------+
" {{{

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

" }}}

" +------+
" | misc |
" +------+
" {{{

" set ctags file
"set tags=~/tags

" enable mouse
set mouse=a

" scrolling settings
set scrolloff=10
set sidescrolloff=10

" disable bells
set noerrorbells
set visualbell
set t_vb=

" enable modelines
set modeline

" enable wildmenu for smart tab complete
set wildmenu

" source any local configs
silent! source ~/.vimrc_local

" Backup
let bkdir = expand('~/.vim/backup')
call system('mkdir ' . bkdir)
let &backupdir = bkdir
set backup

" Create dirs
" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
  let myUndoDir = expand('~/.vim/undo')
  " Create dirs
  call system('mkdir ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
endif

" }}}

" +--------------+
" | key mappings |
" +--------------+
" {{{
"
" noremap <c-i>: call term_sendkeys(buf, a:cmd."\<CR>")

" save and close a buffer using ctrl+x
inoremap <c-x> <esc>:x<cr>
noremap <c-x> :x<cr>

" force-close a buffer
inoremap <c-q> <esc>:q!<cr>
noremap <c-q> :q!<cr>

" create a new tab using ctrl+t
noremap <c-t> <esc>:tabnew<cr>

" un-indent more easily
inoremap <s-tab> <c-d>
vnoremap > >gv
vnoremap < <gv


tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

inoremap <C-h> <esc><C-w>h
inoremap <C-j> <esc><C-w>j
inoremap <C-k> <esc><C-w>k
inoremap <C-l> <esc><C-w>l

" Quickly create a new terminal in a new tab
tnoremap <c-a>c <c-w>:tab term<CR>
noremap <c-a>c <esc>:tab term<CR>
inoremap <c-a>c <esc>:tab term<CR>

tnoremap <c-a>v <c-w>:vert term<CR>
noremap <c-a>v <esc>:vert term<CR>
inoremap <c-a>v <esc>:vert term<CR>

tnoremap <c-a>s <c-w>:term<CR>
noremap <c-a>s <esc>:term<CR>
inoremap <c-a>s <esc>:term<CR>

nnor <cr> :Sline<CR>j
vnor <cr>"+y :Sexe %paste<cr>

"noremap <leader>yy "+yy

" Fix pasting
" nnoremap p ]p

" efficiency ftw
inoremap jj <esc>
noremap ; :
"noremap : ;

" clear highlights on redraw
"nnoremap <c-l> :nohl<cr><c-l>

" copy/paste from system clipboard
vnoremap y "+y
"noremap <leader>yy "+yy
"nnoremap <leader>p "+p
"nnoremap <leader>P "+P
set clipboard=unnamedplus

nnoremap U :redo<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
nnoremap <leader>W !sudo tee > /dev/null %<CR>

" edit vimrc
nnoremap <leader>vim :vsp ~/.vimrc<cr>

autocmd VimLeave * call system('echo ' . shellescape(getreg('+')) . ' | xclip -selection clipboard')
" }}}
"
"
if !exists('g:lasttab')
  let g:lasttab = 1
endif
nnoremap <c-a><c-a> <esc>:exe "tabn ".g:lasttab<CR>
inoremap <c-a><c-a> <esc>:exe "tabn ".g:lasttab<CR>
tnoremap <c-a><c-a> <c-w>:exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
