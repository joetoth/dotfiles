


if empty(glob('~/.config/nvim/plugged'))
  silent !curl -fLo ~/.config/nvim/plugged/ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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

"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'Shougo/denite.nvim',
Plug 'hkupty/iron.nvim',
Plug 'airblade/vim-gitgutter'
Plug 'bazelbuild/vim-bazel',
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
Plug 'junegunn/fzf.vim',
Plug 'junegunn/vim-peekaboo' " quote or @ or ctrl+r to browse register
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeFind' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle'   }
"Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" (Optional) Showing function signature and inline doc.
Plug 'Shougo/echodoc.vim'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"

if has('python3')
    Plug 'SirVer/ultisnips' " Snippet engine
    Plug 'honza/vim-snippets' " Actual snippets
    Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
endif
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

" SCM support
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

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
"" gruvbox's dark0, so it just looks like cursorline stops at 80
hi Normal ctermbg=NONE guibg=NONE 
let &colorcolumn=join(range(81,250), ',')
highlight ColorColumn guibg=#282828
"" so listchars are only visible on the current line
highlight SpecialKey guifg=#282828

if has('mouse') | set mouse=a | endif
set cino=:0,(shiftwidth
set clipboard=unnamed
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
setlocal signcolumn=yes " Always show gutter so text doesn't realign everytime
set spell spelllang=en

" search options
set hlsearch " highlight search matches. Turn of with :nohlsearch after a search
set incsearch " highlight partial search pattern matches while typing
set ignorecase " usually ignore case when searching
set smartcase " unless a search term starts with a capital letter
if exists('+inccommand')
    set inccommand=nosplit
endif
" leader combination to stop search highlighting
noremap / :nohlsearch <CR>/

" Completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

imap <c-space> <Plug>(asyncomplete_force_refresh)
set completeopt+=preview
" keys
"" leader
"let g:mapleader="\<SPACE>"
let g:mapleader=","
nnoremap ; :

if has('python3')
    let g:UltiSnipsExpandTrigger="<c-e>"
    call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))
endif

" Movement
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

inoremap <C-l> <C-w>l
inoremap <C-h> <C-w>h
inoremap <C-j> <C-w>j
inoremap <C-k> <C-w>k

nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" settings for neovim terminals
if has('nvim')
"    autocmd vimrc TermOpen * setlocal nospell
"    autocmd vimrc TermOpen * set bufhidden=hide
"    autocmd vimrc BufEnter * if &buftype == 'terminal' | :startinsert | endif
    let g:terminal_scrollback_buffer_size=100000
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
endif


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
let g:deoplete#enable_at_startup = 1

nnoremap <leader>u :UndotreeToggle<CR>
" redo
nnoremap U :redo<CR>


" ----------------------------------------------------------------------------
" YCM
" ----------------------------------------------------------------------------
augroup vimrc
  autocmd!
augroup END

"autocmd vimrc FileType c,cpp,go,py nnoremap <buffer> ]d :YcmCompleter GoTo<CR>
"autocmd vimrc FileType c,cpp,py    nnoremap <buffer> K  :YcmCompleter GetType<CR>
"autocmd vimrc FileType c,cpp,py    nnoremap <buffer> m   :YcmCompleter GoToReferences<CR>
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

" qq to record, Q to replay
nnoremap Q @q
nnoremap <silent> q/ :History/<CR>
nnoremap <silent> q, :History<CR>
nnoremap <silent> q; :History:<CR>
map <silent><c-e>  :History<cr>
"
" Required for operations modifying multiple buffers like rename.
set hidden

if !IsWork()
  let g:formatters_python = ['yapf']
  let g:formatter_yapf_style = 'google'
  autocmd FileType python set shiftwidth=2
  autocmd FileType python set tabstop=2
  autocmd FileType python set softtabstop=2


  if executable('clangd')
      au User lsp_setup call lsp#register_server({
          \ 'name': 'clangd',
          \ 'cmd': {server_info->['clangd']},
          \ 'whitelist': ['cpp'],
          \ })
  endif

  if executable('pyls')
      " pip install python-language-server
      au User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'whitelist': ['python'],
          \ })
  endif
endif

map <C-F> :Autoformat<cr>
" Use CTRL-S for saving, also in Insert mode
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>
"
nnoremap <silent> <leader>g :LspDefinition<CR>

" Iron
"nmap <leader>s <Plug>(iron-send-motion)
"vmap <leader>s <Plug>(iron-send-motion)
"vmap <enter> <Plug>(iron-send-motion)
"nmap <leader>p <Plug>(iron-repeat-cmd)

augroup ironmapping
    autocmd!
    nmap <ENTER> V<Plug>(iron-send-motion)
    vmap <ENTER> <Plug>(iron-send-motion)
    nmap <leader>p <Plug>(iron-repeat-cmd)
augroup END



" let g:LanguageClient_autoStart = 1

" nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
" nnoremap <silent> <leader>g :call LanguageClient_textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
"let g:LanguageClient_serverCommands = {
"      \ 'python': ['pyls'],
"      \ 'cpp': ['clangd'],
"      \ 'cc': ['clangd'],
"      \ 'go': ['go-langserver'],
"\ }
" UltiSnips settings
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsSnippetsDir = "~/.config/nvim/snippets/"      
