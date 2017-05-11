" vim: set foldmethod=marker foldlevel=0:
" ============================================================================

function! IsWork()
    return filereadable(glob("~/wdf/work.vim"))
endfunction

" .vimrc of Junegunn Choi {{{
" ============================================================================

" Vim 8 defaults
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let s:darwin = has('mac')

" }}}
" ============================================================================
" VIM-PLUG BLOCK {{{
" ============================================================================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
if plug#begin('~/.vim/plugged')

if s:darwin
  let g:plug_url_format = 'git@github.com:%s.git'
else
  let $GIT_SSL_NO_VERIFY = 'true'
endif

" My plugins
Plug 'junegunn/vim-easy-align',       { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity']      }
Plug 'junegunn/vim-emoji'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-slash'
Plug 'junegunn/vim-fnr'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-journal'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/vader.vim',  { 'on': 'Vader', 'for': 'vader' }
Plug 'junegunn/vim-ruby-x', { 'on': 'RubyX' }
Plug 'junegunn/fzf',        { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/rainbow_parentheses.vim'
if v:version >= 703
  Plug 'junegunn/vim-after-object'
endif
if s:darwin
  Plug 'junegunn/vim-xmark'
endif
unlet! g:plug_url_format

" Colors
Plug 'tomasr/molokai'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'AlessandroYorba/Monrovia'

" Edit
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary',        { 'on': '<Plug>Commentary' }
Plug 'mbbill/undotree',             { 'on': 'UndotreeToggle'   }
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'rhysd/vim-grammarous'
Plug 'beloglazov/vim-online-thesaurus'

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --gocode-completer --tern-completer
  endif
endfunction

if !IsWork()
  Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp',  'python', 'bazel'], 'do': function('BuildYCM') }
  Plug 'Chiel92/vim-autoformat'
  Plug 'google/vim-maktaba'
  Plug 'bazelbuild/vim-bazel'
  Plug 'bazelbuild/vim-ft-bzl'
endif

Plug 'SirVer/ultisnips', { 'on': 'InsertEnter' }
Plug 'honza/vim-snippets'

" Browsing
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
autocmd! User indentLine doautocmd indentLine Syntax

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeFind' }
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END

if v:version >= 703
  Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle'      }
endif
Plug 'justinmk/vim-gtfo'

" Git
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-lawrencium'
if v:version >= 703
  Plug 'mhinz/vim-signify'
endif

" Lang
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'groenewege/vim-less'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'kchmck/vim-coffee-script'
Plug 'slim-template/vim-slim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-rails',      { 'for': []      }
Plug 'derekwyatt/vim-scala'
Plug 'honza/dockerfile.vim'
Plug 'solarnz/thrift.vim'
Plug 'dag/vim-fish'
Plug 'chrisbra/unicode.vim', { 'for': 'journal' }
Plug 'octol/vim-cpp-enhanced-highlight'

" Lint
Plug 'metakirby5/codi.vim'
Plug 'w0rp/ale', { 'on': 'ALEEnable', 'for': ['ruby', 'sh'] }

" Joe
Plug 'christoomey/vim-tmux-navigator' 
Plug 'easymotion/vim-easymotion'
Plug 'davidhalter/jedi-vim'
call plug#end()
endif

" }}}
" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================

  let mapleader      = ','
  let maplocalleader = ','

  augroup vimrc
    autocmd!
  augroup END

  set nu
  set autoindent
  set smartindent
  set lazyredraw
  set laststatus=2
  set showcmd
  set visualbell
  set backspace=indent,eol,start
  set timeoutlen=500
  set whichwrap=b,s
  set shortmess=aIT
  set hlsearch " CTRL-L / CTRL-R W
  set incsearch
  set hidden
  set ignorecase smartcase
  set wildmenu
  set wildmode=full
  set tabstop=2
  set shiftwidth=2
  set expandtab smarttab
  set scrolloff=5
  set encoding=utf-8
  set list
  set listchars=tab:\|\ ,
  set virtualedit=block
  set nojoinspaces
  set diffopt=filler,vertical
  set autoread
  set clipboard=unnamed
  set foldlevelstart=99
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  set nocursorline
  set completeopt=menuone,preview
  set nrformats=hex
  silent! set cryptmethod=blowfish2

  set formatoptions+=1
  if has('patch-7.3.541')
    set formatoptions+=j
  endif
  if has('patch-7.4.338')
    let &showbreak = '↳ '
    set breakindent
    set breakindentopt=sbr
  endif

  if has('termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif

  " %< Where to truncate
  " %n buffer number
  " %F Full path
  " %m Modified flag: [+], [-]
  " %r Readonly flag: [RO]
  " %y Type:          [vim]
  " fugitive#statusline()
  " %= Separator
  " %-14.(...)
  " %l Line
  " %c Column
  " %V Virtual column
  " %P Percentage
  " %#HighlightGroup#
  set statusline=%<[%n]\ %F\ %m%r%y\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %=%-14.(%l,%c%V%)\ %P
  silent! if emoji#available()
    let s:ft_emoji = map({
      \ 'c':          'baby_chick',
      \ 'clojure':    'lollipop',
      \ 'coffee':     'coffee',
      \ 'cpp':        'chicken',
      \ 'css':        'art',
      \ 'eruby':      'ring',
      \ 'gitcommit':  'soon',
      \ 'haml':       'hammer',
      \ 'help':       'angel',
      \ 'html':       'herb',
      \ 'java':       'older_man',
      \ 'javascript': 'monkey',
      \ 'make':       'seedling',
      \ 'markdown':   'book',
      \ 'perl':       'camel',
      \ 'python':     'snake',
      \ 'ruby':       'gem',
      \ 'scala':      'barber',
      \ 'sh':         'shell',
      \ 'slim':       'dancer',
      \ 'text':       'books',
      \ 'vim':        'poop',
      \ 'vim-plug':   'electric_plug',
      \ 'yaml':       'yum',
      \ 'yaml.jinja': 'yum'
    \ }, 'emoji#for(v:val)')

    function! S_filetype()
      if empty(&filetype)
        return emoji#for('grey_question')
      else
        return get(s:ft_emoji, &filetype, '['.&filetype.']')
      endif
    endfunction

    function! S_modified()
      if &modified
        return emoji#for('kiss').' '
      elseif !&modifiable
        return emoji#for('construction').' '
      else
        return ''
      endif
    endfunction

    function! S_fugitive()
      if !exists('g:loaded_fugitive')
        return ''
      endif
      let head = fugitive#head()
      if empty(head)
        return ''
      else
        return head == 'master' ? emoji#for('crown') : emoji#for('dango').'='.head
      endif
    endfunction

    let s:braille = split('"⠉⠒⠤⣀', '\zs')
    function! Braille()
      let len = len(s:braille)
      let [cur, max] = [line('.'), line('$')]
      let pos  = min([len * (cur - 1) / max([1, max - 1]), len - 1])
      return s:braille[pos]
    endfunction

    hi def link User1 TablineFill
    let s:cherry = emoji#for('cherry_blossom')
    function! MyStatusLine()
      let mod = '%{S_modified()}'
      let ro  = "%{&readonly ? emoji#for('lock') . ' ' : ''}"
      let ft  = '%{S_filetype()}'
      let fug = ' %{S_fugitive()}'
      let sep = ' %= '
      let pos = ' %l,%c%V '
      let pct = ' %P '

      return s:cherry.' [%n] %F %<'.mod.ro.ft.fug.sep.pos.'%{Braille()}%*'.pct.s:cherry
    endfunction

    " Note that the "%!" expression is evaluated in the context of the
    " current window and buffer, while %{} items are evaluated in the
    " context of the window that the statusline belongs to.
    set statusline=%!MyStatusLine()
  endif

  set pastetoggle=<F9>
  set modelines=2
  set synmaxcol=1000

  " For MacVim
  set noimd
  set imi=1
  set ims=-1

  " ctags
  set tags=./tags;/

  " Annoying temporary files
  set backupdir=/tmp//,.
  set directory=/tmp//,.
  if v:version >= 703
    set undodir=/tmp//,.
  endif

  " Shift-tab on GNU screen
  " http://superuser.com/questions/195794/gnu-screen-shift-tab-issue
  "set t_kB=[Z

  " set complete=.,w,b,u,t
  set complete-=i

  silent! set ttymouse=xterm2
  " mousee
  set mouse=a

  " 80 chars/line
  set textwidth=0
  if exists('&colorcolumn')
    set colorcolumn=80
  endif

  " Keep the cursor on the same column
  set nostartofline

  " FOOBAR=~/<CTRL-><CTRL-F>
  set isfname-==

  if exists('&fixeol')
    set nofixeol
  endif

  if has('gui_running')
    set guifont=Menlo:h14 columns=80 lines=40
    silent! colo seoul256-light
  else
    silent! colo seoul256
  endif

  " }}}
" ============================================================================
" MAPPINGS {{{
" ============================================================================

  " ----------------------------------------------------------------------------
  " Basic mappings
  " ----------------------------------------------------------------------------

  noremap <C-F> <C-D>
  noremap <C-B> <C-U>

  " Save
  inoremap <C-s>     <C-O>:update<cr>
  nnoremap <C-s>     :update<cr>
  nnoremap <leader>s :update<cr>
  nnoremap <leader>w :update<cr>

  " Disable CTRL-A on tmux or on screen
  if $TERM =~ 'screen'
    nnoremap <C-a> <nop>
    nnoremap <Leader><C-a> <C-a>
  endif

  " Quit
  inoremap <C-w>     <esc>:q<cr>
  nnoremap <C-w>     :q<cr>
  vnoremap <C-w>     <esc>
  nnoremap <Leader>q :q<cr>
  nnoremap <Leader>Q :qa!<cr>

  " Tags
  nnoremap <C-]> g<C-]>
  nnoremap g[ :pop<cr>

  " Jump list (to newer position)
  nnoremap <C-p> <C-i>

  " <F10> | NERD Tree
  nnoremap <F10> :NERDTreeToggle<cr>

  " <F11> | Tagbar
  if v:version >= 703
    inoremap <F11> <esc>:TagbarToggle<cr>
    nnoremap <F11> :TagbarToggle<cr>
    let g:tagbar_sort = 0
  endif

  " jk | Escaping!
  inoremap jk <Esc>
  xnoremap jk <Esc>
  cnoremap jk <C-c>

  " Movement in insert mode
  noremap <C-l> <C-w>l
  noremap <C-h> <C-w>h
  noremap <C-j> <C-w>j
  noremap <C-k> <C-w>k
  inoremap <C-^> <C-o><C-^>

  " Make Y behave like other capitals
  nnoremap Y y$

  " qq to record, Q to replay
  nnoremap Q @q

  " Zoom
  function! s:zoom()
    if winnr('$') > 1
      tab split
    elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                    \ 'index(v:val, '.bufnr('').') >= 0')) > 1
      tabclose
    endif
  endfunction
  nnoremap <silent> <leader>z :call <sid>zoom()<cr>

  " Last inserted text
  nnoremap g. :normal! `[v`]<cr><left>

  " ----------------------------------------------------------------------------
  " nvim
  " ----------------------------------------------------------------------------
  if has('nvim')
    tnoremap <a-a> <esc>a
    tnoremap <a-b> <esc>b
    tnoremap <a-d> <esc>d
    tnoremap <a-f> <esc>f
  endif

  " ----------------------------------------------------------------------------
  " Quickfix
  " ----------------------------------------------------------------------------
  nnoremap ]q :cnext<cr>zz
  nnoremap [q :cprev<cr>zz
  nnoremap ]l :lnext<cr>zz
  nnoremap [l :lprev<cr>zz

  " ----------------------------------------------------------------------------
  " Buffers
  " ----------------------------------------------------------------------------
  nnoremap ]b :bnext<cr>
  nnoremap [b :bprev<cr>

  " ----------------------------------------------------------------------------
  " Tabs
  " ----------------------------------------------------------------------------
  nnoremap ]t :tabn<cr>
  nnoremap [t :tabp<cr>

  " ----------------------------------------------------------------------------
  " <tab> / <s-tab> | Tab navigation
  " ----------------------------------------------------------------------------
  nnoremap <tab>   :tabn<cr>
  nnoremap <S-tab> :tabp<cr>
  nnoremap <leader>t :tabnew<cr>

  " ----------------------------------------------------------------------------
  " tmux
  " ----------------------------------------------------------------------------
  function! s:tmux_send(content, dest) range
    let dest = empty(a:dest) ? input('To which pane? ') : a:dest
    let tempfile = tempname()
    call writefile(split(a:content, "\n", 1), tempfile, 'b')
    call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
          \ shellescape(tempfile), shellescape(dest)))
    call delete(tempfile)
  endfunction

  function! s:tmux_map(key, dest)
    execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
    execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
  endfunction

  call s:tmux_map('<leader>tt', '')
  call s:tmux_map('<leader>th', '.left')
  call s:tmux_map('<leader>tj', '.bottom')
  call s:tmux_map('<leader>tk', '.top')
  call s:tmux_map('<leader>tl', '.right')
  call s:tmux_map('<leader>ty', '.top-left')
  call s:tmux_map('<leader>to', '.top-right')
  call s:tmux_map('<leader>tn', '.bottom-left')
  call s:tmux_map('<leader>t.', '.bottom-right')

  " ----------------------------------------------------------------------------
  " <tab> / <s-tab> / <c-v><tab> | super-duper-tab
  " ----------------------------------------------------------------------------
  function! s:can_complete(func, prefix)
    if empty(a:func)
      return 0
    endif
    let start = call(a:func, [1, ''])
    if start < 0
      return 0
    endif

    let oline  = getline('.')
    let line   = oline[0:start-1] . oline[col('.')-1:]

    let opos   = getpos('.')
    let pos    = copy(opos)
    let pos[2] = start + 1

    call setline('.', line)
    call setpos('.', pos)
    let result = call(a:func, [0, matchstr(a:prefix, '\k\+$')])
    call setline('.', oline)
    call setpos('.', opos)

    if !empty(type(result) == type([]) ? result : result.words)
      call complete(start + 1, result)
      return 1
    endif
    return 0
  endfunction

  function! s:feedkeys(k)
    call feedkeys(a:k, 'n')
    return ''
  endfunction

  function! s:super_duper_tab(pumvisible, next)
    let [k, o] = a:next ? ["\<c-n>", "\<tab>"] : ["\<c-p>", "\<s-tab>"]
    if a:pumvisible
      return s:feedkeys(k)
    endif

    let line = getline('.')
    let col = col('.') - 2
    if line[col] !~ '\k\|[/~.]'
      return s:feedkeys(o)
    endif

    let prefix = expand(matchstr(line[0:col], '\S*$'))
    if prefix =~ '^[~/.]'
      return s:feedkeys("\<c-x>\<c-f>")
    endif
    if s:can_complete(&omnifunc, prefix) || s:can_complete(&completefunc, prefix)
      return ''
    endif
    return s:feedkeys(k)
  endfunction

  if has_key(g:plugs, 'ultisnips')
    " UltiSnips will be loaded only when tab is first pressed in insert mode
    if !exists(':UltiSnipsEdit')
      inoremap <silent> <Plug>(tab) <c-r>=plug#load('ultisnips')?UltiSnips#ExpandSnippet():''<cr>
      imap <tab> <Plug>(tab)
    endif

    let g:SuperTabMappingForward  = "<tab>"
    let g:SuperTabMappingBackward = "<s-tab>"
    function! SuperTab(m)
      return s:super_duper_tab(a:m == 'n' ? "\<c-n>" : "\<c-p>",
                             \ a:m == 'n' ? "\<tab>" : "\<s-tab>")
    endfunction
  else
    inoremap <silent> <tab>   <c-r>=<SID>super_duper_tab(pumvisible(), 1)<cr>
    inoremap <silent> <s-tab> <c-r>=<SID>super_duper_tab(pumvisible(), 0)<cr>
  endif

  " ----------------------------------------------------------------------------
  " Markdown headings
  " ----------------------------------------------------------------------------
  nnoremap <leader>1 m`yypVr=``
  nnoremap <leader>2 m`yypVr-``
  nnoremap <leader>3 m`^i### <esc>``4l
  nnoremap <leader>4 m`^i#### <esc>``5l
  nnoremap <leader>5 m`^i##### <esc>``6l

  " ----------------------------------------------------------------------------
  " Moving lines
  " ----------------------------------------------------------------------------
"    nnoremap <silent> <C-k> :move-2<cr>
"    nnoremap <silent> <C-j> :move+<cr>
"    nnoremap <silent> <C-h> <<
"    nnoremap <silent> <C-l> >>
"    xnoremap <silent> <C-k> :move-2<cr>gv
"    xnoremap <silent> <C-h> <gv
"    xnoremap <silent> <C-j> :move'>+<cr>gv
"    xnoremap <silent> <C-l> >gv
"    xnoremap < <gv
"    xnoremap > >gv

  " ----------------------------------------------------------------------------
  " <Leader>c Close quickfix/location window
  " ----------------------------------------------------------------------------
  nnoremap <leader>c :cclose<bar>lclose<cr>

  " ----------------------------------------------------------------------------
  " Readline-style key bindings in command-line (excerpt from rsi.vim)
  " ----------------------------------------------------------------------------
  cnoremap        <C-A> <Home>
  cnoremap        <C-B> <Left>
  cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
  cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
  cnoremap        <M-b> <S-Left>
  cnoremap        <M-f> <S-Right>
  silent! exe "set <S-Left>=\<Esc>b"
  silent! exe "set <S-Right>=\<Esc>f"

  " ----------------------------------------------------------------------------
  " #gi / #gpi | go to next/previous indentation level
  " ----------------------------------------------------------------------------
  function! s:go_indent(times, dir)
    for _ in range(a:times)
      let l = line('.')
      let x = line('$')
      let i = s:indent_len(getline(l))
      let e = empty(getline(l))

      while l >= 1 && l <= x
        let line = getline(l + a:dir)
        let l += a:dir
        if s:indent_len(line) != i || empty(line) != e
          break
        endif
      endwhile
      let l = min([max([1, l]), x])
      execute 'normal! '. l .'G^'
    endfor
  endfunction
  nnoremap <silent> gi :<c-u>call <SID>go_indent(v:count1, 1)<cr>
  nnoremap <silent> gpi :<c-u>call <SID>go_indent(v:count1, -1)<cr>

  " ----------------------------------------------------------------------------
  " <leader>bs | buf-search
  " ----------------------------------------------------------------------------
  nnoremap <leader>bs :cex []<BAR>bufdo vimgrepadd @@g %<BAR>cw<s-left><s-left><right>

  " ----------------------------------------------------------------------------
  " #!! | Shebang
  " ----------------------------------------------------------------------------
  inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

  " ----------------------------------------------------------------------------
  " <leader>ij | Open in IntelliJ
  " ----------------------------------------------------------------------------
  if s:darwin
    nnoremap <silent> <leader>ij
    \ :call system('"/Applications/IntelliJ IDEA.app/Contents/MacOS/idea" '.expand('%:p'))<cr>
  endif

  " }}}
" ============================================================================
" FUNCTIONS & COMMANDS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" :Chomp
" ----------------------------------------------------------------------------
command! Chomp %s/\s\+$// | normal! ``

" ----------------------------------------------------------------------------
" :Count
" ----------------------------------------------------------------------------
command! -nargs=1 Count execute printf('%%s/%s//gn', escape(<q-args>, '/')) | normal! ``

" ----------------------------------------------------------------------------
" :CopyRTF
" ----------------------------------------------------------------------------
function! s:colors(...)
  return filter(map(filter(split(globpath(&rtp, 'colors/*.vim'), "\n"),
        \                  'v:val !~ "^/usr/"'),
        \           'fnamemodify(v:val, ":t:r")'),
        \       '!a:0 || stridx(v:val, a:1) >= 0')
endfunction

function! s:copy_rtf(line1, line2, ...)
  let [ft, cs, nu] = [&filetype, g:colors_name, &l:nu]
  let lines = getline(1, '$')

  tab new
  setlocal buftype=nofile bufhidden=wipe nonumber
  let &filetype = ft
  call setline(1, lines)

  execute 'colo' get(a:000, 0, 'seoul256-light')
  hi Normal ctermbg=NONE guibg=NONE

  let lines = getline(a:line1, a:line2)
  let indent = repeat(' ', min(map(filter(copy(lines), '!empty(v:val)'), 'len(matchstr(v:val, "^ *"))')))
  call setline(a:line1, map(lines, 'substitute(v:val, indent, "", "")'))

  call tohtml#Convert2HTML(a:line1, a:line2)
  g/^\(pre\|body\) {/s/background-color: #[0-9]*; //
  silent %write !textutil -convert rtf -textsizemultiplier 1.3 -stdin -stdout | pbcopy

  bd!
  tabclose

  let &l:nu = nu
  execute 'colorscheme' cs
endfunction

if s:darwin
  command! -range=% -nargs=? -complete=customlist,s:colors CopyRTF call s:copy_rtf(<line1>, <line2>, <f-args>)
endif

" ----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" ----------------------------------------------------------------------------
function! s:root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in git repo'
  else
    execute 'lcd' root
    echo 'Changed directory to: '.root
  endif
endfunction
command! Root call s:root()

" ----------------------------------------------------------------------------
" <F5> / <F6> | Run script
" ----------------------------------------------------------------------------
function! s:run_this_script(output)
  let head   = getline(1)
  let pos    = stridx(head, '#!')
  let file   = expand('%:p')
  let ofile  = tempname()
  let rdr    = " 2>&1 | tee ".ofile
  let win    = winnr()
  let prefix = a:output ? 'silent !' : '!'
  " Shebang found
  if pos != -1
    execute prefix.strpart(head, pos + 2).' '.file.rdr
  " Shebang not found but executable
  elseif executable(file)
    execute prefix.file.rdr
  elseif &filetype == 'ruby'
    execute prefix.'/usr/bin/env ruby '.file.rdr
  elseif &filetype == 'tex'
    execute prefix.'latex '.file. '; [ $? -eq 0 ] && xdvi '. expand('%:r').rdr
  elseif &filetype == 'dot'
    let svg = expand('%:r') . '.svg'
    let png = expand('%:r') . '.png'
    " librsvg >> imagemagick + ghostscript
    execute 'silent !dot -Tsvg '.file.' -o '.svg.' && '
          \ 'rsvg-convert -z 2 '.svg.' > '.png.' && open '.png.rdr
  else
    return
  end
  redraw!
  if !a:output | return | endif

  " Scratch buffer
  if exists('s:vim_exec_buf') && bufexists(s:vim_exec_buf)
    execute bufwinnr(s:vim_exec_buf).'wincmd w'
    %d
  else
    silent!  bdelete [vim-exec-output]
    silent!  vertical botright split new
    silent!  file [vim-exec-output]
    setlocal buftype=nofile bufhidden=wipe noswapfile
    let      s:vim_exec_buf = winnr()
  endif
  execute 'silent! read' ofile
  normal! gg"_dd
  execute win.'wincmd w'
endfunction
nnoremap <silent> <F5> :call <SID>run_this_script(0)<cr>
nnoremap <silent> <F6> :call <SID>run_this_script(1)<cr>

" ----------------------------------------------------------------------------
" <F8> | Color scheme selector
" ----------------------------------------------------------------------------
function! s:rotate_colors()
  if !exists('s:colors')
    let s:colors = s:colors()
  endif
  let name = remove(s:colors, 0)
  call add(s:colors, name)
  execute 'colorscheme' name
  redraw
  echo name
endfunction
nnoremap <silent> <F8> :call <SID>rotate_colors()<cr>

" ----------------------------------------------------------------------------
" :Shuffle | Shuffle selected lines
" ----------------------------------------------------------------------------
function! s:shuffle() range
ruby << RB
  first, last = %w[a:firstline a:lastline].map { |e| VIM::evaluate(e).to_i }
  (first..last).map { |l| $curbuf[l] }.shuffle.each_with_index do |line, i|
    $curbuf[first + i] = line
  end
RB
endfunction
command! -range Shuffle <line1>,<line2>call s:shuffle()

" ----------------------------------------------------------------------------
" Syntax highlighting in code snippets
" ----------------------------------------------------------------------------
function! s:syntax_include(lang, b, e, inclusive)
  let syns = split(globpath(&rtp, "syntax/".a:lang.".vim"), "\n")
  if empty(syns)
    return
  endif

  if exists('b:current_syntax')
    let csyn = b:current_syntax
    unlet b:current_syntax
  endif

  let z = "'" " Default
  for nr in range(char2nr('a'), char2nr('z'))
    let char = nr2char(nr)
    if a:b !~ char && a:e !~ char
      let z = char
      break
    endif
  endfor

  silent! exec printf("syntax include @%s %s", a:lang, syns[0])
  if a:inclusive
    exec printf('syntax region %sSnip start=%s\(%s\)\@=%s ' .
                \ 'end=%s\(%s\)\@<=\(\)%s contains=@%s containedin=ALL',
                \ a:lang, z, a:b, z, z, a:e, z, a:lang)
  else
    exec printf('syntax region %sSnip matchgroup=Snip start=%s%s%s ' .
                \ 'end=%s%s%s contains=@%s containedin=ALL',
                \ a:lang, z, a:b, z, z, a:e, z, a:lang)
  endif

  if exists('csyn')
    let b:current_syntax = csyn
  endif
endfunction

function! s:file_type_handler()
  if &ft =~ 'jinja' && &ft != 'jinja'
    call s:syntax_include('jinja', '{{', '}}', 1)
    call s:syntax_include('jinja', '{%', '%}', 1)
  elseif &ft =~ 'mkd\|markdown'
    for lang in ['ruby', 'yaml', 'vim', 'sh', 'bash:sh', 'python', 'java', 'c',
          \ 'clojure', 'clj:clojure', 'scala', 'sql', 'gnuplot']
      call s:syntax_include(split(lang, ':')[-1], '```'.split(lang, ':')[0], '```', 0)
    endfor

    highlight def link Snip Folded
    setlocal textwidth=78
    setlocal completefunc=emoji#complete
  elseif &ft == 'sh'
    call s:syntax_include('ruby', '#!ruby', '/\%$', 1)
  endif
endfunction

" ----------------------------------------------------------------------------
" SaveMacro / LoadMacro
" ----------------------------------------------------------------------------
function! s:save_macro(name, file)
  let content = eval('@'.a:name)
  if !empty(content)
    call writefile(split(content, "\n"), a:file)
    echom len(content) . " bytes save to ". a:file
  endif
endfunction
command! -nargs=* SaveMacro call <SID>save_macro(<f-args>)

function! s:load_macro(file, name)
  let data = join(readfile(a:file), "\n")
  call setreg(a:name, data, 'c')
  echom "Macro loaded to @". a:name
endfunction
command! -nargs=* LoadMacro call <SID>load_macro(<f-args>)

" ----------------------------------------------------------------------------
" HL | Find out syntax group
" ----------------------------------------------------------------------------
function! s:hl()
  " echo synIDattr(synID(line('.'), col('.'), 0), 'name')
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction
command! HL call <SID>hl()

" ----------------------------------------------------------------------------
" :A
" ----------------------------------------------------------------------------
function! s:a(cmd)
  let name = expand('%:r')
  let ext = tolower(expand('%:e'))
  let sources = ['c', 'cc', 'cpp', 'cxx']
  let headers = ['h', 'hh', 'hpp', 'hxx']
  for pair in [[sources, headers], [headers, sources]]
    let [set1, set2] = pair
    if index(set1, ext) >= 0
      for h in set2
        let aname = name.'.'.h
        for a in [aname, toupper(aname)]
          if filereadable(a)
            execute a:cmd a
            return
          end
        endfor
      endfor
    endif
  endfor
endfunction
command! A call s:a('e')
command! AV call s:a('botright vertical split')

" ----------------------------------------------------------------------------
" Todo
" ----------------------------------------------------------------------------
function! s:todo() abort
  let entries = []
  for cmd in ['git grep -niI -e TODO -e FIXME -e XXX 2> /dev/null',
            \ 'grep -rniI -e TODO -e FIXME -e XXX * 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
command! Todo call s:todo()

" ----------------------------------------------------------------------------
" ConnectChrome
" ----------------------------------------------------------------------------
if s:darwin
  function! s:connect_chrome(bang)
    augroup connect-chrome
      autocmd!
      if !a:bang
        autocmd BufWritePost <buffer> call system(join([
        \ "osascript -e 'tell application \"Google Chrome\"".
        \               "to tell the active tab of its first window\n",
        \ "  reload",
        \ "end tell'"], "\n"))
      endif
    augroup END
  endfunction
  command! -bang ConnectChrome call s:connect_chrome(<bang>0)
endif

" ----------------------------------------------------------------------------
" AutoSave
" ----------------------------------------------------------------------------
function! s:autosave(enable)
  augroup autosave
    autocmd!
    if a:enable
      autocmd TextChanged,InsertLeave <buffer>
            \  if empty(&buftype) && !empty(bufname(''))
            \|   silent! update
            \| endif
    endif
  augroup END
endfunction

command! -bang AutoSave call s:autosave(<bang>1)

" ----------------------------------------------------------------------------
" TX
" ----------------------------------------------------------------------------
command! -nargs=1 TX
  \ call system('tmux split-window -d -l 16 '.<q-args>)
cnoremap !! TX<space>

" ----------------------------------------------------------------------------
" EX | chmod +x
" ----------------------------------------------------------------------------
command! EX if !empty(expand('%'))
         \|   write
         \|   call system('chmod +x '.expand('%'))
         \|   silent e
         \| else
         \|   echohl WarningMsg
         \|   echo 'Save the file first'
         \|   echohl None
         \| endif

" ----------------------------------------------------------------------------
" Profile
" ----------------------------------------------------------------------------
function! s:profile(bang)
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start /tmp/profile.log
    profile func *
    profile file *
  endif
endfunction
command! -bang Profile call s:profile(<bang>0)

" ----------------------------------------------------------------------------
" call LSD()
" ----------------------------------------------------------------------------
function! LSD()
  syntax clear

  for i in range(16, 255)
    execute printf('highlight LSD%s ctermfg=%s', i - 16, i)
  endfor

  let block = 4
  for l in range(1, line('$'))
    let c = 1
    let max = len(getline(l))
    while c < max
      let stride = 4 + reltime()[1] % 8
      execute printf('syntax region lsd%s_%s start=/\%%%sl\%%%sc/ end=/\%%%sl\%%%sc/ contains=ALL', l, c, l, c, l, min([c + stride, max]))
      let rand = abs(reltime()[1] % (256 - 16))
      execute printf('hi def link lsd%s_%s LSD%s', l, c, rand)
      let c += stride
    endwhile
  endfor
endfunction


" ----------------------------------------------------------------------------
" Open FILENAME:LINE:COL
" ----------------------------------------------------------------------------
function! s:goto_line()
  let tokens = split(expand('%'), ':')
  if len(tokens) <= 1 || !filereadable(tokens[0])
    return
  endif

  let file = tokens[0]
  let rest = map(tokens[1:], 'str2nr(v:val)')
  let line = get(rest, 0, 1)
  let col  = get(rest, 1, 1)
  bd!
  silent execute 'e' file
  execute printf('normal! %dG%d|', line, col)
endfunction

autocmd vimrc BufNewFile * nested call s:goto_line()


" ----------------------------------------------------------------------------
" co? : Toggle options (inspired by unimpaired.vim)
" ----------------------------------------------------------------------------
function! s:map_change_option(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap co%s :%s<bar>set %s?<cr>", key, op, opt)
endfunction

call s:map_change_option('p', 'paste')
call s:map_change_option('n', 'number')
call s:map_change_option('w', 'wrap')
call s:map_change_option('h', 'hlsearch')
call s:map_change_option('m', 'mouse', 'let &mouse = &mouse == "" ? "a" : ""')
call s:map_change_option('t', 'textwidth',
    \ 'let &textwidth = input("textwidth (". &textwidth ."): ")<bar>redraw')
call s:map_change_option('b', 'background',
    \ 'let &background = &background == "dark" ? "light" : "dark"<bar>redraw')

" ----------------------------------------------------------------------------
" <Leader>?/! | Google it / Feeling lucky
" ----------------------------------------------------------------------------
function! s:goog(pat, lucky)
  let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
  let q = substitute(q, '[[:punct:] ]',
       \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
  call system(printf('open "https://www.google.com/search?%sq=%s"',
                   \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <leader>? :call <SID>goog(expand("<cWORD>"), 0)<cr>
nnoremap <leader>! :call <SID>goog(expand("<cWORD>"), 1)<cr>
xnoremap <leader>? "gy:call <SID>goog(@g, 0)<cr>gv
xnoremap <leader>! "gy:call <SID>goog(@g, 1)<cr>gv


" }}}
" ============================================================================
" TEXT OBJECTS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Common
" ----------------------------------------------------------------------------
function! s:textobj_cancel()
if v:operator == 'c'
  augroup textobj_undo_empty_change
    autocmd InsertLeave <buffer> execute 'normal! u'
          \| execute 'autocmd! textobj_undo_empty_change'
          \| execute 'augroup! textobj_undo_empty_change'
  augroup END
endif
endfunction

noremap         <Plug>(TOC) <nop>
inoremap <expr> <Plug>(TOC) exists('#textobj_undo_empty_change')?"\<esc>":''

" ----------------------------------------------------------------------------
" ?ii / ?ai | indent-object
" ?io       | strictly-indent-object
" ----------------------------------------------------------------------------
function! s:indent_len(str)
return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endfunction

function! s:indent_object(op, skip_blank, b, e, bd, ed)
let i = min([s:indent_len(getline(a:b)), s:indent_len(getline(a:e))])
let x = line('$')
let d = [a:b, a:e]

if i == 0 && empty(getline(a:b)) && empty(getline(a:e))
  let [b, e] = [a:b, a:e]
  while b > 0 && e <= line('$')
    let b -= 1
    let e += 1
    let i = min(filter(map([b, e], 's:indent_len(getline(v:val))'), 'v:val != 0'))
    if i > 0
      break
    endif
  endwhile
endif

for triple in [[0, 'd[o] > 1', -1], [1, 'd[o] < x', +1]]
  let [o, ev, df] = triple

  while eval(ev)
    let line = getline(d[o] + df)
    let idt = s:indent_len(line)

    if eval('idt '.a:op.' i') && (a:skip_blank || !empty(line)) || (a:skip_blank && empty(line))
      let d[o] += df
    else | break | end
  endwhile
endfor
execute printf('normal! %dGV%dG', max([1, d[0] + a:bd]), min([x, d[1] + a:ed]))
endfunction
xnoremap <silent> ii :<c-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), 0, 0)<cr>
onoremap <silent> ii :<c-u>call <SID>indent_object('>=', 1, line('.'), line('.'), 0, 0)<cr>
xnoremap <silent> ai :<c-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), -1, 1)<cr>
onoremap <silent> ai :<c-u>call <SID>indent_object('>=', 1, line('.'), line('.'), -1, 1)<cr>
xnoremap <silent> io :<c-u>call <SID>indent_object('==', 0, line("'<"), line("'>"), 0, 0)<cr>
onoremap <silent> io :<c-u>call <SID>indent_object('==', 0, line('.'), line('.'), 0, 0)<cr>

" ----------------------------------------------------------------------------
" <Leader>I/A | Prepend/Append to all adjacent lines with same indentation
" ----------------------------------------------------------------------------
nmap <silent> <leader>I ^vio<C-V>I
nmap <silent> <leader>A ^vio<C-V>$A

" ----------------------------------------------------------------------------
" ?i_ ?a_ ?i. ?a. ?i, ?a, ?i/
" ----------------------------------------------------------------------------
function! s:between_the_chars(incll, inclr, char, vis)
let cursor = col('.')
let line   = getline('.')
let before = line[0 : cursor - 1]
let after  = line[cursor : -1]
let [b, e] = [cursor, cursor]

try
  let i = stridx(join(reverse(split(before, '\zs')), ''), a:char)
  if i < 0 | throw 'exit' | end
  let b = len(before) - i + (a:incll ? 0 : 1)

  let i = stridx(after, a:char)
  if i < 0 | throw 'exit' | end
  let e = cursor + i + 1 - (a:inclr ? 0 : 1)

  execute printf("normal! 0%dlhv0%dlh", b, e)
catch 'exit'
  call s:textobj_cancel()
  if a:vis
    normal! gv
  endif
finally
  " Cleanup command history
  if histget(':', -1) =~ '<SNR>[0-9_]*between_the_chars('
    call histdel(':', -1)
  endif
  echo
endtry
endfunction

for [s:c, s:l] in items({'_': 0, '.': 0, ',': 0, '/': 1, '-': 0})
execute printf("xmap <silent> i%s :<C-U>call <SID>between_the_chars(0,  0, '%s', 1)<CR><Plug>(TOC)", s:c, s:c)
execute printf("omap <silent> i%s :<C-U>call <SID>between_the_chars(0,  0, '%s', 0)<CR><Plug>(TOC)", s:c, s:c)
execute printf("xmap <silent> a%s :<C-U>call <SID>between_the_chars(%s, 1, '%s', 1)<CR><Plug>(TOC)", s:c, s:l, s:c)
execute printf("omap <silent> a%s :<C-U>call <SID>between_the_chars(%s, 1, '%s', 0)<CR><Plug>(TOC)", s:c, s:l, s:c)
endfor

" ----------------------------------------------------------------------------
" ?ie | entire object
" ----------------------------------------------------------------------------
xnoremap <silent> ie gg0oG$
onoremap <silent> ie :<C-U>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>

" ----------------------------------------------------------------------------
" ?il | inner line
" ----------------------------------------------------------------------------
xnoremap <silent> il <Esc>^vg_
onoremap <silent> il :<C-U>normal! ^vg_<CR>

" ----------------------------------------------------------------------------
" ?i# | inner comment
" ----------------------------------------------------------------------------
function! s:inner_comment(vis)
if synIDattr(synID(line('.'), col('.'), 0), 'name') !~? 'comment'
  call s:textobj_cancel()
  if a:vis
    normal! gv
  endif
  return
endif

let origin = line('.')
let lines = []
for dir in [-1, 1]
  let line = origin
  let line += dir
  while line >= 1 && line <= line('$')
    execute 'normal!' line.'G^'
    if synIDattr(synID(line('.'), col('.'), 0), 'name') !~? 'comment'
      break
    endif
    let line += dir
  endwhile
  let line -= dir
  call add(lines, line)
endfor

execute 'normal!' lines[0].'GV'.lines[1].'G'
endfunction
xmap <silent> i# :<C-U>call <SID>inner_comment(1)<CR><Plug>(TOC)
omap <silent> i# :<C-U>call <SID>inner_comment(0)<CR><Plug>(TOC)

" ----------------------------------------------------------------------------
" ?ic / ?iC | Blockwise column object
" ----------------------------------------------------------------------------
function! s:inner_blockwise_column(vmode, cmd)
if a:vmode == "\<C-V>"
  let [pvb, pve] = [getpos("'<"), getpos("'>")]
  normal! `z
endif

execute "normal! \<C-V>".a:cmd."o\<C-C>"
let [line, col] = [line('.'), col('.')]
let [cb, ce]    = [col("'<"), col("'>")]
let [mn, mx]    = [line, line]

for dir in [1, -1]
  let l = line + dir
  while line('.') > 1 && line('.') < line('$')
    execute "normal! ".l."G".col."|"
    execute "normal! v".a:cmd."\<C-C>"
    if cb != col("'<") || ce != col("'>")
      break
    endif
    let [mn, mx] = [min([line('.'), mn]), max([line('.'), mx])]
    let l += dir
  endwhile
endfor

execute printf("normal! %dG%d|\<C-V>%s%dG", mn, col, a:cmd, mx)

if a:vmode == "\<C-V>"
  normal! o
  if pvb[1] < line('.') | execute "normal! ".pvb[1]."G" | endif
  if pvb[2] < col('.')  | execute "normal! ".pvb[2]."|" | endif
  normal! o
  if pve[1] > line('.') | execute "normal! ".pve[1]."G" | endif
  if pve[2] > col('.')  | execute "normal! ".pve[2]."|" | endif
endif
endfunction

xnoremap <silent> ic mz:<C-U>call <SID>inner_blockwise_column(visualmode(), 'iw')<CR>
xnoremap <silent> iC mz:<C-U>call <SID>inner_blockwise_column(visualmode(), 'iW')<CR>
xnoremap <silent> ac mz:<C-U>call <SID>inner_blockwise_column(visualmode(), 'aw')<CR>
xnoremap <silent> aC mz:<C-U>call <SID>inner_blockwise_column(visualmode(), 'aW')<CR>
onoremap <silent> ic :<C-U>call   <SID>inner_blockwise_column('',           'iw')<CR>
onoremap <silent> iC :<C-U>call   <SID>inner_blockwise_column('',           'iW')<CR>
onoremap <silent> ac :<C-U>call   <SID>inner_blockwise_column('',           'aw')<CR>
onoremap <silent> aC :<C-U>call   <SID>inner_blockwise_column('',           'aW')<CR>

" ----------------------------------------------------------------------------
" ?i<shift>-` | Inside ``` block
" ----------------------------------------------------------------------------
xnoremap <silent> i~ g_?^```<cr>jo/^```<cr>kV:<c-u>nohl<cr>gv
xnoremap <silent> a~ g_?^```<cr>o/^```<cr>V:<c-u>nohl<cr>gv
onoremap <silent> i~ :<C-U>execute "normal vi`"<cr>
onoremap <silent> a~ :<C-U>execute "normal va`"<cr>


" }}}
" ============================================================================
" PLUGINS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" vim-plug extension
" ----------------------------------------------------------------------------
function! s:plug_gx()
let line = getline('.')
let sha  = matchstr(line, '^  \X*\zs\x\{7,9}\ze ')
let name = empty(sha) ? matchstr(line, '^[-x+] \zs[^:]\+\ze:')
                    \ : getline(search('^- .*:$', 'bn'))[2:-2]
let uri  = get(get(g:plugs, name, {}), 'uri', '')
if uri !~ 'github.com'
  return
endif
let repo = matchstr(uri, '[^:/]*/'.name)
let url  = empty(sha) ? 'https://github.com/'.repo
                    \ : printf('https://github.com/%s/commit/%s', repo, sha)
call netrw#BrowseX(url, 0)
endfunction

function! s:scroll_preview(down)
silent! wincmd P
if &previewwindow
  execute 'normal!' a:down ? "\<c-e>" : "\<c-y>"
  wincmd p
endif
endfunction

function! s:plug_doc()
let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
if has_key(g:plugs, name)
  for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
    execute 'tabe' doc
  endfor
endif
endfunction

function! s:setup_extra_keys()
" PlugDiff
nnoremap <silent> <buffer> J :call <sid>scroll_preview(1)<cr>
nnoremap <silent> <buffer> K :call <sid>scroll_preview(0)<cr>
nnoremap <silent> <buffer> <c-n> :call search('^  \X*\zs\x')<cr>
nnoremap <silent> <buffer> <c-p> :call search('^  \X*\zs\x', 'b')<cr>
nmap <silent> <buffer> <c-j> <c-n>o
nmap <silent> <buffer> <c-k> <c-p>o

" gx
nnoremap <buffer> <silent> gx :call <sid>plug_gx()<cr>

" helpdoc
nnoremap <buffer> <silent> H  :call <sid>plug_doc()<cr>
endfunction

autocmd vimrc FileType vim-plug call s:setup_extra_keys()

let g:plug_window = '-tabnew'
let g:plug_pwindow = 'vertical rightbelow new'

" ----------------------------------------------------------------------------
" MatchParen delay
" ----------------------------------------------------------------------------
let g:matchparen_insert_timeout=5

" ----------------------------------------------------------------------------
" vim-commentary
" ----------------------------------------------------------------------------
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" ----------------------------------------------------------------------------
" vim-fugitive
" ----------------------------------------------------------------------------
nmap     <Leader>g :Gstatus<CR>gg<c-n>
nnoremap <Leader>d :Gdiff<CR>

" ----------------------------------------------------------------------------
" vim-ruby
" ----------------------------------------------------------------------------
" ft-ruby-syntax
let ruby_operators = 1
let ruby_space_errors = 1
let ruby_fold = 1
let ruby_no_expensive = 1
let ruby_spellcheck_strings = 1

autocmd vimrc FileType ruby command! Rubocop :call system('rubocop -a '.expand('%')) | e
" ft-ruby-omni
" let rubycomplete_buffer_loading = 1
" let rubycomplete_classes_in_global = 1
" let rubycomplete_load_gemfile = 1

" ----------------------------------------------------------------------------
" matchit.vim
" ----------------------------------------------------------------------------
runtime macros/matchit.vim

" ----------------------------------------------------------------------------
" ack.vim
" ----------------------------------------------------------------------------
if executable('ag')
let &grepprg = 'ag --nogroup --nocolor --column'
else
let &grepprg = 'grep -rn $* *'
endif
command! -nargs=1 -bar Grep execute 'silent! grep! <q-args>' | redraw! | copen

" ----------------------------------------------------------------------------
" vim-after-object
" ----------------------------------------------------------------------------
silent! if has_key(g:plugs, 'vim-after-object')
autocmd VimEnter * silent! call after_object#enable('=', ':', '#', ' ', '|')
endif

" ----------------------------------------------------------------------------
" <Enter> | vim-easy-align
" ----------------------------------------------------------------------------
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '\': { 'pattern': '\\' },
\ '/': { 'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['!Comment'] },
\ ']': {
\     'pattern':       '\]\zs',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       ')\zs',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ 'f': {
\     'pattern': ' \(\S\+(\)\@=',
\     'left_margin': 0,
\     'right_margin': 0
\   },
\ 'd': {
\     'pattern': ' \ze\S\+\s*[;=]',
\     'left_margin': 0,
\     'right_margin': 0
\   }
\ }

" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement
nmap ga <Plug>(EasyAlign)
nmap gaa ga_

" xmap <Leader><Enter>   <Plug>(LiveEasyAlign)
" nmap <Leader><Leader>a <Plug>(LiveEasyAlign)

" inoremap <silent> => =><Esc>mzvip:EasyAlign/=>/<CR>`z$a<Space>

" ----------------------------------------------------------------------------
" vim-github-dashboard
" ----------------------------------------------------------------------------
let g:github_dashboard = { 'username': 'junegunn' }

" ----------------------------------------------------------------------------
" indentLine
" ----------------------------------------------------------------------------
let g:indentLine_enabled = 0

" ----------------------------------------------------------------------------
" vim-signify
" ----------------------------------------------------------------------------
let g:signify_vcs_list = ['git']
let g:signify_skip_filetype = { 'journal': 1 }

" ----------------------------------------------------------------------------
" vim-slash
" ----------------------------------------------------------------------------
function! s:blink(times, delay)
let s:blink = { 'ticks': 2 * a:times, 'delay': a:delay }

function! s:blink.tick(_)
  let self.ticks -= 1
  let active = self == s:blink && self.ticks > 0

  if !self.clear() && active && &hlsearch
    let [line, col] = [line('.'), col('.')]
    let w:blink_id = matchadd('IncSearch',
          \ printf('\%%%dl\%%>%dc\%%<%dc', line, max([0, col-2]), col+2))
  endif
  if active
    call timer_start(self.delay, self.tick)
  endif
endfunction

function! s:blink.clear()
  if exists('w:blink_id')
    call matchdelete(w:blink_id)
    unlet w:blink_id
    return 1
  endif
endfunction

call s:blink.clear()
call s:blink.tick(0)
return ''
endfunction

if has('timers')
if has_key(g:plugs, 'vim-slash')
  noremap <expr> <plug>(slash-after) <sid>blink(2, 50)
else
  noremap <expr> n 'n'.<sid>blink(2, 50)
  noremap <expr> N 'N'.<sid>blink(2, 50)
  cnoremap <expr> <cr> (stridx('/?', getcmdtype()) < 0 ? '' : <sid>blink(2, 50))."\<cr>"
endif
endif

" ----------------------------------------------------------------------------
" vim-emoji :dog: :cat: :rabbit:!
" ----------------------------------------------------------------------------
function! s:replace_emojis() range
for lnum in range(a:firstline, a:lastline)
  let line = getline(lnum)
  let subs = substitute(line,
        \ ':\([^:]\+\):', '\=emoji#for(submatch(1), submatch(0))', 'g')
  if line != subs
    call setline(lnum, subs)
  endif
endfor
endfunction
command! -range EmojiReplace <line1>,<line2>call s:replace_emojis()

" ----------------------------------------------------------------------------
" goyo.vim + limelight.vim
" ----------------------------------------------------------------------------
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

function! s:goyo_enter()
if has('gui_running')
  set fullscreen
  set background=light
  set linespace=7
elseif exists('$TMUX')
  silent !tmux set status off
endif
Limelight
let &l:statusline = '%M'
hi StatusLine ctermfg=red guifg=red cterm=NONE gui=NONE
endfunction

function! s:goyo_leave()
if has('gui_running')
  set nofullscreen
  set background=dark
  set linespace=0
elseif exists('$TMUX')
  silent !tmux set status on
endif
Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <Leader>G :Goyo<CR>

" ----------------------------------------------------------------------------
" gv.vim / gl.vim
" ----------------------------------------------------------------------------
function! s:gv_expand()
let line = getline('.')
GV --name-status
call search('\V'.line, 'c')
normal! zz
endfunction

autocmd! FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>

" ----------------------------------------------------------------------------
" undotree
" ----------------------------------------------------------------------------
let g:undotree_WindowLayout = 2
nnoremap <leader>u :UndotreeToggle<CR>

" ----------------------------------------------------------------------------
" clojure
" ----------------------------------------------------------------------------
function! s:lisp_maps()
nnoremap <buffer> <leader>a[ vi[<c-v>$:EasyAlign\ g/^\S/<cr>gv=
nnoremap <buffer> <leader>a{ vi{<c-v>$:EasyAlign\ g/^\S/<cr>gv=
nnoremap <buffer> <leader>a( vi(<c-v>$:EasyAlign\ g/^\S/<cr>gv=
nnoremap <buffer> <leader>rq :silent update<bar>Require<cr>
nnoremap <buffer> <leader>rQ :silent update<bar>Require!<cr>
nnoremap <buffer> <leader>rt :silent update<bar>RunTests<cr>
nmap     <buffer> <leader>*  cqp<c-r><c-w><cr>
nmap     <buffer> <c-]>      <Plug>FireplaceDjumpzz
imap     <buffer> <c-j><c-n> <c-o>(<right>.<space><left><tab>
endfunction

function! s:countdown(message, seconds)
for t in range(a:seconds)
  let left = a:seconds - t
  echom printf('%s in %d second%s', a:message, left, left > 1 ? 's' : '')
  redraw
  sleep 1
endfor
echo
endfunction

function! s:figwheel()
call system('tmux send-keys -t right C-u "(start-figwheel!)" Enter')
call system('open-chrome localhost:3449')
call s:countdown('Piggieback', 5)
Piggieback (figwheel-sidecar.repl-api/repl-env)
endfunction

augroup vimrc
autocmd FileType lisp,clojure,scheme RainbowParentheses
autocmd FileType lisp,clojure,scheme call <sid>lisp_maps()

" Clojure
autocmd FileType clojure xnoremap <buffer> <Enter> :Eval<CR>
autocmd FileType clojure nmap <buffer> <Enter> cpp

" Figwheel
autocmd BufReadPost *.cljs command! -buffer Figwheel call s:figwheel()
augroup END

let g:clojure_maxlines = 60

set lispwords+=match
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let']

" let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
let g:paredit_smartjump = 1

" vim-cljfmt
let g:clj_fmt_autosave = 0
autocmd vimrc BufWritePre *.clj call cljfmt#AutoFormat()
autocmd vimrc BufWritePre *.cljc call cljfmt#AutoFormat()

" ----------------------------------------------------------------------------
" vim-markdown
" ----------------------------------------------------------------------------
" let g:markdown_fenced_languages = ['sh', 'ruby', 'clojure', 'vim', 'java', 'gnuplot']

" ----------------------------------------------------------------------------
" splitjoin
" ----------------------------------------------------------------------------
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nnoremap gss :SplitjoinSplit<cr>
nnoremap gsj :SplitjoinJoin<cr>

" ----------------------------------------------------------------------------
" vimawesome.com
" ----------------------------------------------------------------------------
function! VimAwesomeComplete() abort
let prefix = matchstr(strpart(getline('.'), 0, col('.') - 1), '[.a-zA-Z0-9_/-]*$')
echohl WarningMsg
echo 'Downloading plugin list from VimAwesome'
echohl None
ruby << EOF
require 'json'
require 'open-uri'

query = VIM::evaluate('prefix').gsub('/', '%20')
items = 1.upto(max_pages = 3).map do |page|
  Thread.new do
    url  = "http://vimawesome.com/api/plugins?page=#{page}&query=#{query}"
    data = open(url).read
    json = JSON.parse(data, symbolize_names: true)
    json[:plugins].map do |info|
      pair = info.values_at :github_owner, :github_repo_name
      next if pair.any? { |e| e.nil? || e.empty? }
      {word: pair.join('/'),
       menu: info[:category].to_s,
       info: info.values_at(:short_desc, :author).compact.join($/)}
    end.compact
  end
end.each(&:join).map(&:value).inject(:+)
VIM::command("let cands = #{JSON.dump items}")
EOF
if !empty(cands)
  inoremap <buffer> <c-v> <c-n>
  augroup _VimAwesomeComplete
    autocmd!
    autocmd CursorMovedI,InsertLeave * iunmap <buffer> <c-v>
          \| autocmd! _VimAwesomeComplete
  augroup END

  call complete(col('.') - strchars(prefix), cands)
endif
return ''
endfunction

autocmd vimrc FileType vim inoremap <buffer> <c-x><c-v> <c-r>=VimAwesomeComplete()<cr>

" ----------------------------------------------------------------------------
" YCM
" ----------------------------------------------------------------------------
autocmd vimrc FileType c,cpp,go,py nnoremap <buffer> ]d :YcmCompleter GoTo<CR>

autocmd vimrc FileType c,cpp,py    nnoremap <buffer> K  :YcmCompleter GetType<CR>
" }}}
" ============================================================================
" FZF {{{
" ============================================================================

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
  " let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        :Marks<CR>
" nnoremap <silent> q: :History:<CR>
" nnoremap <silent> q/ :History/<CR>

inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader>4 <plug>(fzf-maps-n)
xmap <leader>4 <plug>(fzf-maps-x)
omap <leader>4 <plug>(fzf-maps-o)

function! s:plugs_sink(line)
  let dir = g:plugs[a:line].dir
  for pat in ['doc/*.txt', 'README.md']
    let match = get(split(globpath(dir, pat), "\n"), 0, '')
    if len(match)
      execute 'tabedit' match
      return
    endif
  endfor
  tabnew
  execute 'Explore' dir
endfunction

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source':  sort(keys(g:plugs)),
  \ 'sink':    function('s:plugs_sink')}))

" }}}
" ============================================================================
" AUTOCMD {{{
" ============================================================================

augroup vimrc
  au BufWritePost vimrc,.vimrc nested if expand('%') !~ 'fugitive' | source % | endif

  " IndentLines
  au FileType slim IndentLinesEnable

  " File types
  au BufNewFile,BufRead *.icc               set filetype=cpp
  au BufNewFile,BufRead *.pde               set filetype=java
  au BufNewFile,BufRead *.coffee-processing set filetype=coffee
  au BufNewFile,BufRead Dockerfile*         set filetype=dockerfile

  " Included syntax
  au FileType,ColorScheme * call <SID>file_type_handler()

  " Fugitive
  au FileType gitcommit setlocal completefunc=emoji#complete
  au FileType gitcommit nnoremap <buffer> <silent> cd :<C-U>Gcommit --amend --date="$(date)"<CR>

  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
  au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/

  " Unset paste on InsertLeave
  au InsertLeave * silent! set nopaste

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

" ----------------------------------------------------------------------------
" Help in new tabs
" ----------------------------------------------------------------------------
function! s:helptab()
  if &buftype == 'help'
    wincmd T
    nnoremap <buffer> q :q<cr>
  endif
endfunction
autocmd vimrc BufEnter *.txt call s:helptab()

" }}}
" ============================================================================
" JOE {{{
" ============================================================================

" Allow saving of files as sudo when I forgot to start vim using sudo.
nnoremap <leader>W !sudo tee > /dev/null %

" edit vimrc
nnoremap <leader>vim :vsp ~/.vimrc<cr>

"TMUX Pane Navigation
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" Toggle QuickFix Window
nnoremap <silent> <c-x> :call QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

" Upgrade my ability to enter command mode.
nnoremap ; :

" End of line / Beginning
noremap H 0
noremap L $

" make Y like D
nnoremap Y y$

" redo
nnoremap U :redo<CR>


nmap <leader>n :NERDTreeFind<CR>
nnoremap <leader>N :NERDTreeToggle<CR>

nmap s <Plug>(easymotion-overwin-f)

map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <leader>p :YcmCompleter GetDoc<CR>
" Command History
map <silent> <c-r> :History:<cr>
map <silent> <c-f> :BLines<cr>

map <leader>b :Buffers<cr>
map <leader>f :Autoformat<cr>

let g:formatters_python = ['yapf']
let g:formatter_yapf_style = 'google'

let g:jedi#force_py_version = 3
au FileType python setlocal omnifunc=python3complete#Complete

let g:jedi#goto_command = ""
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = ""
let g:jedi#usages_command = "<c-g>"
let g:jedi#completions_command = ""
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "1"

" }}}

" ============================================================================
" LOCAL VIMRC {{{
" ============================================================================
let s:local_vimrc = fnamemodify(resolve(expand('<sfile>')), ':p:h').'/vimrc-extra'
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif

" }}}
" ============================================================================
" WORK
"" ============================================================================ ============================================================================
if IsWork()
    source ~/wdf/work.vim
endif

" }}}

