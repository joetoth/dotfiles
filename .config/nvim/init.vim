if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup init
    autocmd VimEnter * PlugInstall
  augroup END
endif

function! IsWork()
    return filereadable(glob("~/wdf/work.vim"))
endfunction

" plugs
call plug#begin()
  function! DoRemote(arg)
    UpdateRemotePlugins
  endfunction

  function! BuildYCM(info)
    if a:info.status == 'installed' || a:info.force
      !./install.py --clang-completer --gocode-completer --tern-completer
    endif
  endfunction

  "Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
  "Plug 'Shougo/denite.nvim',
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
Plug 'junegunn/fzf.vim',
Plug 'junegunn/vim-peekaboo' " quote or @ or ctrl+r to browse register 
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeFind' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle'   }

augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END

  if !IsWork()
    Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp',  'python', 'bazel'], 'do': function('BuildYCM') }
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
    Plug 'Chiel92/vim-autoformat'
    Plug 'google/vim-maktaba'
    Plug 'bazelbuild/vim-bazel'
    Plug 'bazelbuild/vim-ft-bzl'
  endif
call plug#end()

" basics
colorscheme gruvbox
filetype plugin indent on
set background=dark
hi Search guibg=#ff2a50 guifg=#ffffff
let &colorcolumn=join(range(81,250), ',')
" gruvbox's dark0, so it just looks like cursorline stops at 80
highlight ColorColumn guibg=#282828
" so listchars are only visible on the current line
highlight SpecialKey guifg=#282828
if has('mouse') | set mouse=a | endif
set cino=:0,(shiftwidth
set clipboard=unnamedplus
set cursorline
set expandtab
set hidden
set ignorecase
set list
set magic
set nostartofline
set number
set shiftwidth=2
set smartcase
set tabstop=2
set termguicolors

" keys
"" leader
"let g:mapleader="\<SPACE>"
let g:mapleader=","
nnoremap ; :

" End of line / Beginning
noremap H 0
noremap L $

" touch files after saving (to force inotify to update)
autocmd BufWritePost * silent! !touch %

if IsWork()
    source ~/wdf/work.vim
endif

augroup myvimrc
    au!
    au BufWritePost $MYVIMRC so $MYVIMRC
augroup END

" <F10> | NERD Tree
nnoremap <F10> :NERDTreeToggle<cr>
nnoremap <leader>n :NERDTreeFind<cr>

" Quickly open/reload vim
nnoremap <leader>vi :split $MYVIMRC<CR>

" UNDO ====================================================
" Create dirs
" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand('~/.config/nvim/undo')
    " Create dirs
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

let g:undotree_WindowLayout = 2
nnoremap <leader>u :UndotreeToggle<CR>
" redo
nnoremap U :redo<CR>


" ----------------------------------------------------------------------------
" YCM
" ----------------------------------------------------------------------------
augroup vimrc
    autocmd!
augroup END

autocmd vimrc FileType c,cpp,go,py nnoremap <buffer> ]d :YcmCompleter GoTo<CR>
autocmd vimrc FileType c,cpp,py    nnoremap <buffer> K  :YcmCompleter GetType<CR>
autocmd vimrc FileType c,cpp,py    nnoremap <buffer> m   :YcmCompleter GoToReferences<CR>
" }}}
"

" ============================================================================
" FZF {{{
" ============================================================================

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
  " let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif
"
"command! -bang -nargs=? -complete=dir Files
"  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
"
nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
nnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        :Marks<CR>
" nnoremap <silent> q/ :History/<CR>
