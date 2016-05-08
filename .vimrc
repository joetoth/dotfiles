" - (<c-x><c-p> complete plugin names):
" You can use name rewritings to point to sources:
"    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
"    ..ActivateAddons(["github:user/repo", .. => github://user/repo
" Also see section "2.2. names of addons and addon sources

"    \'github:Shougo/neosnippet.vim',
"    \'github:Shougo/neosnippet-snippets',
"    \'github:Shougo/neomru.vim',
"    \'unite',
"    \'unite-outline',
"    \'github:osyo-manga/unite-quickfix',
"    \'github:dart-lang/dart-vim-plugin',
"    \'github:parkr/vim-jekyll',
"    \'github:fatih/vim-go',
"    \'GoldenView.Vim',
"    \'github:klen/python-mode',
"    \'github:SirVer/ultisnips',
"    \'github:honza/vim-snippets',
let s:plugins = [
    \'github:davidhalter/jedi-vim',
    \'github:Valloric/YouCompleteMe',
    \'github:Chiel92/vim-autoformat',
    \'github:junegunn/fzf',
    \'github:junegunn/fzf.vim',
    \'github:chriskempson/base16-vim',
    \'github:christoomey/vim-tmux-navigator', 
    \'github:majutsushi/tagbar', 
    \'github:scrooloose/syntastic',
    \'github:tpope/vim-unimpaired',
    \'The_NERD_tree',
    \'The_NERD_Commenter',
    \'fugitive',
    \'vimux', 
    \'github:epeli/slimux',
    \'repeat',
    \'surround',
    \'taglist-plus',
    \'vimshell',
    \'vimproc']
let s:plugin_autoinstall = 1

" load vam
" --------
fun! EnsureVamIsOnDisk(vam_install_path)
    " windows users may want to use http://mawercer.de/~marc/vam/index.php
    " to fetch VAM, VAM-known-repositories and the listed plugins
    " without having to install curl, 7-zip and git tools first
    " -> BUG [4] (git-less installation)
    let is_installed_c = "isdirectory(a:vam_install_path.'/vim-addon-manager/autoload')"
    if eval(is_installed_c)
        return 1
    else
        if 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
            " I'm sorry having to add this reminder. Eventually it'll pay off.
            call confirm("Remind yourself that most plugins ship with ".
                        \"documentation (README*, doc/*.txt). It is your ".
                        \"first source of knowledge. If you can't find ".
                        \"the info you're looking for in reasonable ".
                        \"time ask maintainers to improve documentation")
            call mkdir(a:vam_install_path, 'p')
            execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
            " VAM runs helptags automatically when you install or update 
            " plugins
            exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
        endif
        return eval(is_installed_c)
    endif
endf

fun! SetupVAM()
    " Set advanced options like this:
    let g:vim_addon_manager = {}
    let g:vim_addon_manager['auto_install'] = 1

    " Example: drop git sources unless git is in PATH. Same plugins can
    " be installed from www.vim.org. Lookup MergeSources to get more control
    " let g:vim_addon_manager['drop_git_sources'] = !executable('git')
    " let g:vim_addon_manager.debug_activation = 1

    " VAM install location:
    let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
    if !EnsureVamIsOnDisk(vam_install_path)
        echohl ErrorMsg
        echomsg "No VAM found!"
        echohl NONE
        return
    endif
    exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

    " Tell VAM which plugins to fetch & load:
    call vam#ActivateAddons(s:plugins, {'auto_install' : s:plugin_autoinstall})
    " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
endfun
call SetupVAM()

" VIM Setup {{{ ===============================================================
"

" <Leader> & <LocalLeader> mapping {{{

let mapleader=','
let maplocalleader= ' '

" Load work vim
if filereadable(glob("~/wdf/work.vim")) 
    source ~/wdf/work.vim
endif


" }}}

" Basic options {{{
set clipboard=unnamedplus

scriptencoding utf-8
set encoding=utf-8              " setup the encoding to UTF-8
set ls=2                        " status line always visible
set go-=T                       " hide the toolbar
set go-=m                       " hide the menu
" The next two lines are quite tricky, but in Gvim, if you don't do this, if you
" only hide all the scrollbars, the vertical scrollbar is showed anyway
set go+=rRlLbh                  " show all the scrollbars
set go-=rRlLbh                  " hide all the scrollbars
set fillchars+=vert:│           " better looking for windows separator
set ttimeoutlen=0               " toggle between modes almost instantly
set backspace=indent,eol,start  " defines the backspace key behavior
set virtualedit=all             " to edit where there is no actual character
set gdefault                    " s//g instead of s// by default
set splitbelow

" display options
" ---------------
syntax on
set showcmd  " show # of items selected below status line
set scrolloff=3
set visualbell t_vb=
set cursorline " highlight the cursor line
set t_Co=256 " use 256 colors
set background=dark " your default background
set ttyfast                     " better screen redraw
set title                       " set the terminal title to the current file
set showcmd                     " shows partial commands
set hidden                      " hide the inactive buffers
set ruler                       " sets a permanent rule
set lazyredraw                  " only redraws if it is needed
set autoread                    " update a open file edited outside of Vim
set so=7                        " Set 7 lines to the cursor - when moving vertically using j/k

if !has("gui_running")
  set term=screen-256color
endif

set background=dark
let base16colorspace=256        " Access colors present in 256 colorspace"
colorscheme base16-tomorrow

" Searching {{{

set incsearch                   " incremental searching
set showmatch                   " show pairs match
set mat=2                       " How many tenths of a second to blink when matching brackets 
set hlsearch                    " highlight search results
set smartcase                   " smart case ignore
set ignorecase                  " ignore case letters

" text options
" ------------
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
set smarttab
set smartindent
set textwidth=80
set colorcolumn=81
set encoding=utf-8
set modelines=10

" History and permanent undo levels

set history=1000
set undofile
set undoreload=1000

" Make a dir if no exists {{{

function! MakeDirIfNoExists(path)
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path), "p")
    endif
endfunction

" }}}

" Backups {{{

set backup
set noswapfile
set backupdir=$HOME/.vim/tmp/backup/
set undodir=$HOME/.vim/tmp/undo/
set directory=$HOME/.vim/tmp/swap/
set viminfo+=n$HOME/.vim/tmp/viminfo

" make this dirs if no exists previously
silent! call MakeDirIfNoExists(&undodir)
silent! call MakeDirIfNoExists(&backupdir)
silent! call MakeDirIfNoExists(&directory)

" }}}

" Wildmenu {{{
" Remap code completion to Ctrl+Space {{{2
" inoremap <Nul> <C-x><C-o>

set wildmenu                        " Command line autocompletion
set wildmode=list:longest,full      " Shows all the options

set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.bak,*.?~,*.??~,*.???~,*.~      " Backup files

" }}}

" comments
" --------
set comments+=",b:##"
set formatoptions="tcnqrlo"


" highlight SpellBad groups brightly
highlight SpellBad cterm=underline,bold ctermfg=black ctermbg=DarkRed

" key mappings
" ---------------

" make jj leave insert mode
inoremap jj <ESC>

" Make hidden characters look nice when shown.
set listchars=tab:▷\ ,eol:¬,extends:»,precedes:«

" Upgrade my ability to enter command mode.
nnoremap ; :

" End of line / Beginning
noremap H 0
noremap L $

" Shift U normally undoes all changes to an line without going 
" through 'undo', so you can't redo. Just remapped to redo
nnoremap U :redo<CR>

" use visual lines, not real lines
nnoremap j gj
nnoremap k gk

" use commas for macros
let mapleader=','

" make Y like D
nnoremap Y y$

" use perlre regex instead of vim's
nnoremap / /\v
vnoremap / /\v

" Return to last edit position 
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" macros
" ------

" Fast saving
"nmap <leader>w :w!<cr>

" Allow saving of files as sudo when I forgot to start vim using sudo.
"command W w !sudo tee > /dev/null %

" turn off search highlighting
nnoremap <leader><space> :nohlsearch<cr>

" show line numbers
set number

" Not sure about this yet
" set relativenumber

function! ListLeaders()
     silent! redir @a
     silent! nmap <LEADER>
     silent! redir END
     silent! new
     silent! put! a
     silent! g/^s*$/d
     silent! %s/^.*,//
     silent! normal ggVg
     silent! sort
     silent! let lines = getline(1,"$")
endfunction

nmap <buffer> ? :<C-u>call ListLeaders()<CR>

" gq a paragraph
nnoremap <leader>q gqip

" underline with -/=/~/_
nnoremap <leader>- yypVr-
nnoremap <leader>= yypVr=
nnoremap <leader>~ yypVr~
nnoremap <leader>_ yypVr_

" edit vimrc
nnoremap <leader>vim :vsp ~/.vimrc<cr>
" Switch to alternate file
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" snippets stuff
let g:snips_author = 'Joe Toth <joetoth@gmail.com>'

set completeopt=menuone,longest,preview

"augroup filetype
filetype plugin indent on

" Tmux navigation
let g:tmux_navigator_no_mappings = 1

"TMUX Pane Navigation
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" Toggle QuickFix Window
nnoremap <silent> <c-q> :call QuickfixToggle()<cr>

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

" Close window
nnoremap <silent> <c-w> :q<CR>

"nmap <Leader>nt :NERDTreeToggle<cr>
nmap <Leader>nt :NERDTreeFind<cr>

" Golang

"au FileType go nmap <Leader>i <Plug>(go-info)
"au FileType go nmap <Leader>e <Plug>(go-doc)
"au FileType go nmap <Leader>igv <Plug>(go-doc-vertical)
"au FileType go nmap <Leader>igb<Plug>(go-doc-browser)
"au FileType go nmap <leader>r <Plug>(go-run)
"au FileType go nmap <leader>gb <Plug>(go-build)
"au FileType go nmap <leader>t <Plug>(go-test)
"au FileType go nmap <leader>c <Plug>(go-coverage)
"au FileType go nmap <leader>gd <Plug>(go-def)
"au FileType go nmap <Leader>ids <Plug>(go-def-split)
"au FileType go nmap <Leader>v <Plug>(go-def-vertical)
"au FileType go nmap <Leader>idt <Plug>(go-def-tab)

au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>
au Filetype go nnoremap <leader>s :sp <CR>:exe "GoDef"<CR>
au Filetype go nnoremap <leader>t :tab split <CR>:exe "GoDef"<CR>

au FileType go map <leader>1 :wa<CR> :GolangTestCurrentPackage<CR>
au FileType go map <leader>rf :wa<CR> :GolangTestFocused<CR>

augroup myvimrc
  au!
  au BufWritePost .vimrc,.vimrc.after,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC
augroup END

" Easy Motion
" These keys are easier to type than the default set

" i and l are too easy to mistake for each other slowing
" down recognition. The home keys and the immediate keys
" accessible by middle fingers are available 
"let g:EasyMotion_keys='asdfjkoweriop'
" Require tpope/vim-repeat to enable dot repeat support
" Jump to anywhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
nmap s <Plug>(easymotion-s)
" Bidirectional & within line 't' motion
" nmap t <Plug>(easymotion-bd-tl)
" Use uppercase target labels and type as a lower case
let g:EasyMotion_use_upper = 1
 " type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1

" Make nerdtree look nice
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30

" Golden View
"call vam#ActivateAddons(['GoldenView.Vim'], {'auto_install' : 1})
"let g:goldenview__enable_default_mapping = 0

" Gundo
nmap ,u :GundoToggle<CR>

" open on the right so as not to compete with the nerdtree
let g:gundo_right = 1 

" a little wider for wider screens
let g:gundo_width = 60


" Airline
set noshowmode
set timeoutlen=1000
set laststatus=2
let g:airline_powerline_fonts = 0
"let g:airline_theme = "wombat"
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#tabline#enabled = 1
" Python-mode
" " Activate rope
" " Keys:
" " K             Show python docs
" " <Ctrl-Space>  Rope autocomplete
" " <Ctrl-c>g     Rope goto definition
" " <Ctrl-c>d     Rope show documentation
" " <Ctrl-c>f     Rope find occurrences
" " <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" " [[            Jump on previous class or function (normal, visual, operator
" modes)
" " ]]            Jump on next class or function (normal, visual, operator
" modes)
" " [M            Jump on previous class or method (normal, visual, operator
" modes)
" " ]M            Jump on next class or method (normal, visual, operator modes)
" let g:pymode_rope = 1

" Documentation
"let g:pymode_doc = 1
"let g:pymode_doc_key = 'K'
"
""Linting
"let g:pymode_lint = 1
"let g:pymode_lint_checker = "pyflakes,pep8"
"" Auto check on save
"let g:pymode_lint_write = 1
"
"" Support virtualenv
"let g:pymode_virtualenv = 1
"
"" Enable breakpoints plugin
"let g:pymode_breakpoint = 1
"let g:pymode_breakpoint_bind = '<leader>b'
"
"" syntax highlighting
"let g:pymode_syntax = 1
"let g:pymode_syntax_all = 1
"let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"let g:pymode_syntax_space_errors = g:pymode_syntax_all

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"let g:syntastic_auto_loc_list = 0
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 1

"
"" Don't autofold code
"let g:pymode_f

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

set foldenable              " can slow Vim down with some plugins
set foldlevelstart=99       " can slow Vim down with some plugins
set foldmethod=syntax       " can slow Vim down with some pluginsolding = 0

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


" set autochdir
"
" ECLIM
"let g:EclimCompletionMethod = 'omnifunc'
""------------------ Eclim shortcut mappings:
""see Eclim cheatsheet /usr/share/vim/vimfiles/eclim/doc/vim/cheatsheet.txt
"map <leader>pp :ProjectProblems<CR>    
"map <leader>pp :ProjectProblems<CR>    
"
"autocmd FileType java nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
"
""au filetype java map <cr> :JavaSearchContext<cr>
"map <leader>jd :JavaDocSearch -x all<cr>
"map <leader>jj :JavaImport<cr>
"map <leader>jo :JavaImport<cr>
"map <leader>jf :JavaFormat<CR>
"map <leader>jr :JavaRename 
"map <leader>jm :JavaMove
"map <leader>js :JavaSearch<CR>
"map <leader>jc :JavaSearchContext<CR>  
"map <leader>jh :JavaHierarchy<CR>
"map <leader>ji :JavaImport<CR>
"map <leader>je :JavaCorrect<CR>

function! Auto_complete_string()                               
    if pumvisible()                                            
        return "\<C-n>"                                        
    else                                                       
        return "\<C-x>\<C-o>\<C-r>=Auto_complete_opened()\<CR>"
    end                                                        
endfunction                                                    

function! Auto_complete_opened()                               
    if pumvisible()                                            
        return "\<c-n>\<c-p>\<c-n>"                            
    else                                                       
        return "\<bs>\<C-n>"                                   
    end                                                        
endfunction                                                    

inoremap <expr> <Nul> Auto_complete_string()

au Filetype java set makeprg=:ProjectBuild

vnoremap <silent> s :call Pick()<CR><CR>

function! Pick()
  let query = s:get_visual_selection()
  call DebugPrintMsg('query='.query)
  let url = '"https://www.google.com/search?q=' . query. '"'
  call DebugPrintMsg(url)
  call Open(url)
  redraw!
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
"s:get_visual_selection()                                                    {{{
"Credit: Peter Rodding http://peterodding.com/code/ returns the visual
"selection
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [lnum1, col1] = getpos("'<")[1:2] 
    let [lnum2, col2] = getpos("'>")[1:2] 
    let lines = getline(lnum1, lnum2) 
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)] 
    let lines[0] = lines[0][col1 - 1:] 
    return join(lines, "\n") 
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" frisk#debug#PrintHeader()                                                       {{{ 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! DebugHeader(text)
    if s:debug
        echom repeat(' ', 80)
        echom repeat('=', 80)
        echom a:text." Debug"
        echom repeat('-', 80)
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" frisk#debug#PrintMsg()                                                          {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! DebugPrintMsg(text)
    if s:debug
        echom a:text
    endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" debug#Enable()                                                            {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! DebugEnable(enable)
    if a:enable
        let  s:debug = 1
    else
        let  s:debug = 0
    endif
endfunction


" UltiSnips
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
function! ExpandSnippetOrCarriageReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<CR>"
    endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" File
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fa :Ag<cr>
nnoremap <leader>fs :w!<cr>

" Buffer
map <leader>bb :Buffers<cr>
map <silent> <c-f> :BLines<cr>
map <leader>bf :Autoformat<cr>
"nnoremap <silent> <c-F> :Lines!<cr>
"nnoremap <silent> <c-F> :Lines!<cr>

" Command History
nnoremap <silent> <c-r> :History:<cr>

" tagbar for outline
" c-s search content in files

" Windows
nnoremap <leader>ws :split<cr>
nnoremap <leader>- :split<cr>
nnoremap <leader>wv :vsplit<cr>
nnoremap <leader><leader>v :vsplit<cr>

" YCM / Semantic
"let g:ycm_python_binary_path = '/usr/bin/python3'
"let g:ycm_autoclose_preview_window_after_completion=1
let g:pyclewn_python = '/usr/bin/python'

map <leader>sg :YcmCompleter GoToDefinitionElseDeclaration<CR>
"map <leader>sd :YcmCompleter GoToDeclaration<CR>
map <leader>sf :split <CR>:YcmCompleter GoToDefinition<CR>
map <leader>sd :split <CR>:YcmCompleter GoToDefinition<CR>

let g:ycm_filetype_specific_completion_to_disable = { 'python' : 1 }
let g:ycm_filetype_blacklist = { 'python' : 1 }
