set nocompatible              " be iMproved, required
filetype off                  " required

" Before we continue, detect which version of Vim we're running
if has('nvim')
  let config_path = '~/.config/nvim'
  let g:python2_host_prog = '/usr/local/bin/python2'
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let config_path = '~/.vim'
endif

set ttyfast

" We start with -X option to improve startup time, but this affects clipboard.
" Below restores clipboard functionality.
call serverlist()

" Space leader is best leader
let mapleader = "\<space>"

set visualbell
set ruler

let autoload_path = config_path . '/autoload'
let plug_path = autoload_path . '/plug.vim'
if empty(glob(autoload_path))
  execute 'silent !curl -fLo ' . plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * close
endif

" TODO: Rework this. Detect whether we're launching as read-only. If so, set
" all plugins to load on demand, in case we open a file in write mode during
" the session.
" https://stackoverflow.com/a/36323097/1966418

call plug#begin()

Plug 'jeffkreeftmeijer/vim-dim'           " 4-bit colour scheme to force using terminal colours
Plug 'ap/vim-buftabline'

Plug 'zyedidia/literate.vim'              " Syntax support for Literate
Plug 'elmcast/elm-vim', { 'for': ['elm'] }
                                          " Language pack for Elm
Plug 'udalov/kotlin-vim', { 'for': ['kotlin'] }
                                          " Language pack for Kotlin
Plug 'henrebotha/vim-protobuf', { 'for': ['protobuf'] }
                                          " Language pack for Protobuf
                                          " Language pack for Perl
Plug 'vim-perl/vim-perl', {
    \ 'do': 'mkdir -p after/syntax/perl && cp contrib/heredoc-sql.vim after/syntax/perl/heredoc-sql.vim'
    \ }
Plug 'sheerun/vim-polyglot'               " Loads language packs on demand. Put
                                          " overriding language packs before this one
Plug 'joker1007/vim-ruby-heredoc-syntax', { 'for': ['ruby'] }
                                          " Highlighting heredocs in Ruby
if has('nvim')
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
endif

Plug 'tpope/vim-git' " , { 'for': ['git'] }
Plug 'chrisbra/NrrwRgn', { 'on': ['NR', 'NrrwRgn'] }
                                          " Emacs-style narrowing
Plug 'tpope/vim-surround'                 " Adds commands for surrounding chars
Plug 'wellle/targets.vim'                 " More text objects
Plug 'haya14busa/incsearch.vim'           " Highlight incremental search results
Plug 'airblade/vim-gitgutter'             " Show git status in gutter, async
Plug 'tpope/vim-unimpaired'               " Pairwise commands
Plug 'junegunn/goyo.vim', { 'on': ['Goyo'] }
                                          " Distraction-free mode
Plug 'andymass/matchup.vim'               " Movement between matching if/ends etc
Plug '~/.fzf'
Plug 'junegunn/fzf.vim', { 'do': './install --bin' }
                                          " Fast fuzzy finder
Plug 'michaeljsmith/vim-indent-object'    " Text object for indentation blocks
Plug 'tpope/vim-apathy'                   " Some path values for various langs
Plug 'dzeban/vim-log-syntax'              " Log syntax

Plug 'metakirby5/codi.vim'                " In-buffer REPL

if v:progname !=? 'view'
  Plug 'w0rp/ale'                           " Async linter
  Plug 'junegunn/vim-easy-align'            " Align things, easily
  Plug 'ervandew/supertab'                  " Tab completion
  Plug 'tpope/vim-commentary'               " Toggle comments
  Plug 'tpope/vim-endwise'                  " Auto-insert Ruby end, etc
  Plug 'tpope/vim-sleuth'                   " Auto-detect indentation
  Plug 'mbbill/undotree'                    " Undo tree viewer
  Plug 'chiel92/vim-autoformat'             " Automatically format various files
  Plug 'AndrewRadev/splitjoin.vim'          " Transform between single- and multiline code
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
                                            " Tree browser
  Plug 'tpope/vim-repeat'                   " Allow plugins to specify custom repeat actions
  Plug 'tpope/vim-ragtag'
  " Plug 'jebaum/vim-tmuxify'
  Plug 'groenewege/vim-less'                " Trim whitespace on lines I touch
  Plug 'tpope/vim-obsession'                " Sane & continuous session saving
  Plug 'tpope/vim-fugitive'                 " Git
endif

call plug#end()

set backspace=indent,eol,start
set infercase
set pastetoggle=<Leader>pt
set showmatch

set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" Hook into Linux clipboard
if has('clipboard')
  set clipboard=unnamedplus
endif

" Sensible directions for splitting windows
set splitbelow
set splitright

" Configure language client for reason
if has('nvim')
  let g:LanguageClient_serverCommands = {
      \ 'reason': ['ocaml-language-server', '--stdio'],
      \ 'ocaml': ['ocaml-language-server', '--stdio'],
      \ }
endif

" Disable polyglot's built-in Elm
" Disable Git so we can get the newer version
let g:polyglot_disabled = ['elm', 'git', 'ocaml']

let g:elm_format_autosave = 1

" Make Vim respond faster to some stuff, e.g. vim-gitgutter load delay
set updatetime=250

" Colours go from 0 to 7: black, red, green, yellow, blue, magenta, cyan, white
" Then from 8 to 15, bright versions of the above
" 16 is pure black
hi LineNr ctermfg=14
hi CursorLineNr ctermfg=14
" 'Fix' colors
" set t_8f=[38;2;%lu;%lu;%lum
" set t_8b=[48;2;%lu;%lu;%lum
" set termguicolors
" colorscheme Spacedust
colorscheme dim
set bg=dark
" let g:airline_theme='term'
" Fix vimdiff colours to be not so eye-bleeding. Ugly, but better
hi DiffAdd term=underline cterm=underline ctermfg=4 ctermbg=NONE
hi DiffChange term=underline cterm=underline ctermfg=5 ctermbg=NONE
hi DiffDelete term=underline cterm=underline ctermfg=6 ctermbg=NONE
hi DiffText term=underline cterm=underline ctermfg=9 ctermbg=NONE

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Some experimental stuff for vim-gitgutter
nmap <leader>gdargs :echo 'gitgutter diff args: ' . g:gitgutter_diff_args<CR>

function! GitGutterToggleCached()
  if g:gitgutter_diff_args =~ ' --cached'
    let g:gitgutter_diff_args = substitute(g:gitgutter_diff_args, ' --cached', '', '')
  else
    let g:gitgutter_diff_args = g:gitgutter_diff_args . ' --cached'
  endif
  :GitGutterAll
endfunc

nmap <leader>gdca :call GitGutterToggleCached()<CR>

function! GitGutterToggleWhitespace()
  if g:gitgutter_diff_args =~ ' -w'
    let g:gitgutter_diff_args = substitute(g:gitgutter_diff_args, ' -w', '', '')
  else
    let g:gitgutter_diff_args = g:gitgutter_diff_args . ' -w'
  endif
  :GitGutterAll
endfunc

nmap <leader>gdw :call GitGutterToggleWhitespace()<CR>

" Shortcuts for ale to navigate between errors
" go to previous error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" go to next error
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" Keep gutter open at all times. Causes flickering when toggling Goyo
let g:ale_sign_column_always = 1
" Slow it down a little
let g:ale_lint_delay = 500
" Only enable one JS linter... TODO: find a per-file solution
let g:ale_linters = {
      \   'javascript': ['jshint'],
      \   'typescript': ['eslint'],
      \   'html': [],
      \   'scss': ['scsslint']
      \}
let g:ale_set_highlights = 0

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:>\ ,eol:¬,space:-,trail:-

" incsearch.vim settings
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
let g:incsearch#magic = '\v'

" Use C-l to highlight the current cursor position
nnoremap <C-l> :call HighlightNearCursor()<CR>
function! HighlightNearCursor()
  if !exists('s:highlightcursor')
    match Todo /\k*\%#\k*/
    let s:highlightcursor=1
  else
    match None
    unlet s:highlightcursor
  endif
endfunction

" Use ripgrep as our grep program
set grepprg=rg\ --vimgrep

" Bindings for fzf
nmap <leader>f :Files<CR>
nmap <leader>t :Tags<CR>
nmap <leader>i :Lines
nmap <leader>/ :BLines<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>r :Rg
nmap <leader>c :Commands<CR>
command! -bang -nargs=* RgPerl call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -t perl ".shellescape(<q-args>), 1, <bang>0)',

" Bindings for session management
" https://dockyard.com/blog/2018/06/01/simple-vim-session-management-part-1
" Remove `options` from sessionoptions — options get mangled sometimes
let sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"
" let g:sessions_dir = '~/.vim/sessions'
" exec 'nmap <leader>ss :mksession! ' . g:sessions_dir . '/' | " session save
" exec 'nmap <leader>sr :source ' . g:sessions_dir . '/' | " session restore
nmap <leader>ss :Obsession Session
nmap <leader>sr :source Session

" Bindings for goyo ("prose mode")
nmap <leader>p :Goyo <bar> highlight StatusLineNC ctermfg=white<CR>
" Detect window resize with goyo active & maximize window size when it happens
" Workaround for https://github.com/junegunn/goyo.vim/issues/159
augroup goyohacks
  autocmd!
  autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
augroup END

" Use 2 spaces per tab
set tabstop=2
set shiftwidth=2

" Use soft tabs
set expandtab
set smarttab
set shiftround

set autoindent
set smartindent

" Add filetype to statusline
" :h statusline for details on the defaults
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)%y\ %P

" relativenumber slows down rendering, so we use lazyredraw to buffer redraws
" may not be needed since we no longer use relativenumber
set lazyredraw

" Show as much as possible of a wrapped last line
set display=lastline

" Wrap at word boundaries, not in the middle of words
set linebreak

" Indent line breaks on indented blocks, and indicate it
set breakindent
set breakindentopt=sbr
set showbreak=↪

" Persist undo state across sessions
" https://www.reddit.com/r/vim/comments/2ib9au/why_does_exiting_vim_make_the_next_prompt_appear/cl0zb7m/
let s:vim_cache = expand("$HOME/.vim/undo") " TODO: change for nvim? Or keep across Vim installs?
if filewritable(s:vim_cache) == 0 && exists("*mkdir")
  call mkdir(s:vim_cache, "p", 0700)
endif
set undofile
let &undodir=s:vim_cache
set undolevels=1000
set undoreload=10000

" Keybinds for vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Enable syntax highlighting in Markdown fenced code blocks
let g:markdown_fenced_languages = ['html', 'ruby', 'javascript', 'java', 'clojure', 'erb=eruby', 'xml', 'json', 'sql']

" Enable mouse scrolling inside tmux
set mouse=a
set mousemodel=popup

" Enable modelines for tweaking config per file
set modeline
set modelines=5

" Show partially-typed commands in the bottom right
set showcmd

" Store swap files in a central location
set directory^=$HOME/.vim/tmp// " TODO: change for nvim? Or keep across Vim installs?

let g:nrrw_rgn_resize_window = 'relative'
let g:nrrw_rgn_width = 100

" Keep cursor centred
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

" Show the undo viewer
nnoremap <Leader>u :UndotreeToggle<CR>

nnoremap <Leader>af :Autoformat<CR>

" Detect & load changes to the file
set autoread
set autowrite

set fileformats=unix,mac,dos
set nomodeline

" Enable bash-like command line completion
set wildmenu
set wildmode=list:longest,full
set wildignorecase

nnoremap <Leader>tree :NERDTree<CR>

let g:netrw_sort_by = 'time'
let g:netrw_sort_direction = 'reverse'
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_fastbrowse = 1
let g:netrw_sort_by = 'name'
let g:netrw_sort_direction = 'normal'

" ------------
" Text objects
" ------------

" Slashes
onoremap <silent> a/ :<C-U>normal! F/vf/<CR>
xnoremap <silent> a/ :<C-U>normal! F/vf/<CR>
onoremap <silent> i/ :<C-U>normal! T/vt/<CR>
xnoremap <silent> i/ :<C-U>normal! T/vt/<CR>

" ------------------------
" Abbreviations & snippets
" ------------------------

" Type <// to auto-close XML tags
inoremap <// </<C-x><C-o>

" ------------------------
" Brave experimental stuff
" ------------------------

set cmdwinheight=1

