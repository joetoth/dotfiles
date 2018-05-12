function! IsWork()
    return filereadable(glob("~/wdf/work.vim"))
endfunction

let mapleader = ","

" +---------+
" | plugins |
" +---------+

call plug#begin('~/.vim/plugged')

" Workflow {{{
Plug 'tpope/vim-fugitive' 
  nmap <leader>gb :Gblame<cr>
  nmap <leader>gc :Gcommit<cr>
  nmap <leader>gp :Gpush<cr>
Plug 'airblade/vim-gitgutter'
  let g:gitgutter_map_keys = 0
  nmap <leader>ga <Plug>GitGutterStageHunk
  nmap <leader>gu <Plug>GitGutterUndoHunk
  " nmap <leader>gp <Plug>GitGutterPreviewHunk
  nmap <leader>g] <Plug>GitGutterNextHunk
  nmap <leader>g[ <Plug>GitGutterPrevHunk
Plug 'mbbill/undotree' 
  nnoremap <leader>u :UndotreeToggle<cr>

" File Management {{{
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim' " {{{
  nnoremap <c-F> <esc>:Files<cr>
  nnoremap <leader>zf <esc>:Files<cr>
  nnoremap <leader>zh <esc>:History<cr>
  nnoremap <leader>zg <esc>:GFiles<cr>
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

" Search & Replace
Plug 'haya14busa/incsearch.vim'

" Syntax {{{
Plug 'tpope/vim-commentary'
  map  gc  <Plug>Commentary
  nmap gcc <Plug>CommentaryLine
Plug 'sheerun/vim-polyglot'  
Plug 'vim-syntastic/syntastic'
Plug 'alxyzc/lc.vim'

" Interface {{{

Plug 'mhinz/vim-startify' " {{{
  nnoremap <leader>st :Startify<cr>
" }}}

Plug 'vim-airline/vim-airline' " {{{
  " airline sections {{{
  let g:airline#extensions#branch#symbol = ''
  let g:airline#extensions#hunks#enabled = 0
  " git branch
  let g:airline_section_b = '%{airline#extensions#branch#get_head()}'
  " abbreviated file path
  let g:airline_section_c = '%{pathshorten(expand("%"))}'
  " filetype
  let g:airline_section_x = '%{&ft}'
  " c.<colnum>
  let g:airline_section_y = 'c.%-3.c'
  " <linenum> of <numlines>
  let g:airline_section_z = '%4.l of %-4.L'
  " <linenum/numlines>% of <numlines>
  " let g:airline_section_y = '%P of %-4.L'
  " <linenum>:<colnum>
  " let g:airline_section_z = '%4.l:%-3.c'
  " }}}

  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline_powerline_fonts = 0
  set encoding=utf-8
  set laststatus=2
" }}}

Plug 'vim-airline/vim-airline-themes' " {{{
"  let g:default_airline_theme = 'quantum'
  " let g:alt_airline_theme = 'raven'
  " function! ToggleAirlineTheme() " {{{
  "   if g:airline_theme == g:alt_airline_theme
  "     exec 'AirlineTheme '.g:default_airline_theme
  "   else
  "     exec 'AirlineTheme '.g:alt_airline_theme
  "   endif
  " endfunction " }}}
  " nnoremap <leader>at :call ToggleAirlineTheme()<cr>

  " let g:airline_theme = g:default_airline_theme
" }}}

" Miscellaneous " {{{
Plug 'metakirby5/codi.vim' " {{{

" Motion {{{
Plug 'easymotion/vim-easymotion' " {{{
Plug 'christoomey/vim-tmux-navigator' " {{{

" Themes {{{
Plug 'chriskempson/vim-tomorrow-theme'

call plug#end()

command! PI PlugInstall
command! PU PlugUpdate | PlugUpgrade

" }}}
"
"
" ============================================================================
" AUTOCMD {{{
" ============================================================================

augroup vimrc
  au BufWritePost vimrc,.vimrc nested if expand('%') !~ 'fugitive' | source % | endif

  " IndentLines
  au FileType slim IndentLinesEnable

  " File types
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
set tags=~/tags

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

" Fix pasting
nnoremap p ]p

" efficiency ftw
inoremap jj <esc>
noremap ; :
"noremap : ;

" clear highlights on redraw
nnoremap <c-l> :nohl<cr><c-l>

" copy/paste from system clipboard
noremap <leader>y "+y
noremap <leader>yy "+yy
nnoremap <leader>p "+p
nnoremap <leader>P "+P
set clipboard=unnamedplus

nnoremap U :redo<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
nnoremap <leader>W !sudo tee > /dev/null %

" edit vimrc
nnoremap <leader>vim :vsp ~/.vimrc<cr>

" }}}

