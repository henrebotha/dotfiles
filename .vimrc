filetype off                  " required

" Before we continue, detect which version of Vim we're running {{{
if has('nvim')
  let config_path = '~/.config/nvim'
  let g:python2_host_prog = '/usr/local/bin/python2'
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let config_path = '~/.vim'
endif " }}}

set ttyfast

" We start with -X option to improve startup time, but this affects clipboard.
" Below restores clipboard functionality.
call serverlist()

" Space leader is best leader
let mapleader = "\<space>"

set visualbell
set ruler

" Manage autoload & plugins {{{
let autoload_path = config_path . '/autoload'
let plug_path = autoload_path . '/plug.vim'
if empty(glob(autoload_path))
  execute 'silent !curl -fLo ' . plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * close
endif " }}}

" Install plugins {{{

" TODO: Rework this. Detect whether we're launching as read-only. If so, set
" all plugins to load on demand, in case we open a file in write mode during
" the session.
" https://stackoverflow.com/a/36323097/1966418

call plug#begin()

Plug 'jeffkreeftmeijer/vim-dim'           " 4-bit colour scheme to force using terminal colours
Plug 'noahfrederick/vim-noctu'            " 4-bit colour scheme to force using terminal colours

Plug 'elmcast/elm-vim', { 'for': ['elm'] }
                                          " Language pack for Elm
Plug 'udalov/kotlin-vim', { 'for': ['kotlin'] }
                                          " Language pack for Kotlin
Plug 'henrebotha/vim-protobuf', { 'for': ['protobuf'] }
                                          " Language pack for Protobuf
Plug 'vim-perl/vim-perl', {
  \ 'do': 'mkdir -p after/syntax/perl && cp contrib/heredoc-sql.vim after/syntax/perl/heredoc-sql.vim',
  \ 'for': ['perl']
  \ }
                                          " Language pack for Perl
                                          " Included here because heredoc
                                          " syntax is not loaded automatically
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

Plug 'tpope/vim-git' , {
  \ 'for': ['git', 'gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail'] }
                                          " Language pack for Git
Plug 'chrisbra/NrrwRgn', { 'on': ['NR', 'NrrwRgn'] }
                                          " Emacs-style narrowing
" TODO: Replace vim-surround with vim-sandwich. See here for some
" justifications:
" https://joereynoldsaudio.com/2020/01/22/vim-sandwich-is-better-than-surround.html
Plug 'tpope/vim-surround'                 " Adds commands for surrounding chars
Plug 'wellle/targets.vim'                 " More text objects
Plug 'michaeljsmith/vim-indent-object'    " Text object for indentation blocks
Plug 'airblade/vim-gitgutter'             " Show git status in gutter, async
Plug 'tpope/vim-unimpaired'               " Pairwise commands
Plug 'junegunn/goyo.vim', { 'on': ['Goyo'] }
                                          " Distraction-free mode
Plug 'andymass/matchup.vim'               " Movement between matching if/ends etc
Plug '~/.fzf'
Plug 'junegunn/fzf.vim', { 'do': './install --bin' }
                                          " Fast fuzzy finder
Plug 'tpope/vim-apathy'                   " Some path values for various langs
Plug 'dzeban/vim-log-syntax'              " Log syntax

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
                                          " Language server protocol & completion

Plug 'metakirby5/codi.vim', { 'on': ['Codi'] }
                                          " In-buffer REPL
Plug 'chrisbra/recover.vim'               " Add 'compare' option to swap file recovery

if v:progname !=? 'view'
  Plug 'dense-analysis/ale'                 " Async linter
  Plug 'junegunn/vim-easy-align'            " Align things, easily
  Plug 'tpope/vim-commentary'               " Toggle comments
  Plug 'tpope/vim-endwise'                  " Auto-insert Ruby end, etc
  Plug 'tpope/vim-sleuth'                   " Auto-detect indentation
  Plug 'mbbill/undotree'                    " Undo tree viewer
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

" Automatically executes filetype plugin indent on and syntax enable.
call plug#end() " }}}

set backspace=indent,eol,start
set infercase
set showmatch

set hidden
nnoremap <c-n> :bnext<cr>
nnoremap <c-p> :bprev<cr>

" Disable endwise mappings as they conflict with coc accept
" mapping
let g:endwise_no_mappings=1
" Settings for coc.nvim
set nobackup
set nowritebackup
" set cmdheight=2
set signcolumn=yes
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>rn <Plug>(coc-rename)

xmap <leader>cf <Plug>(coc-format-selected)
nmap <leader>cf <Plug>(coc-format-selected)

augroup coc
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>qf <Plug>(coc-fix-current)

" Function text object
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Hook into OS clipboard. On Linux and similar, this will use the ^C ^V
" "CLIPBOARD" (register "+"), not the copy-on-select "PRIMARY" (which is
" register "*"). See
" https://specifications.freedesktop.org/clipboards-spec/clipboards-latest.txt
if has('clipboard')
  set clipboard=unnamedplus
endif

set tildeop

" If we're launching in diff mode, remap :q to :qa because I'm lazy
if &diff
  cnoreabbrev q qa
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
set t_Co=16
hi LineNr ctermfg=14
hi CursorLineNr ctermfg=14
if exists('g:plugs') && has_key(g:plugs, 'vim-noctu')
  colorscheme noctu
  set bg=dark
endif
" Fix vimdiff colours to be not so eye-bleeding. Ugly, but better
hi DiffAdd term=underline cterm=underline ctermfg=4 ctermbg=NONE
hi DiffChange term=underline cterm=underline ctermfg=5 ctermbg=NONE
hi DiffDelete term=underline cterm=underline ctermfg=6 ctermbg=NONE
hi DiffText term=underline cterm=underline ctermfg=9 ctermbg=NONE
" Make comments italic, because it's nice
hi Comment term=italic cterm=italic
" Remove the black background from folds
hi Folded ctermbg=NONE

" Shortcut to rapidly toggle `set list`
nnoremap <leader>l :set list!<cr>

" Some experimental stuff for vim-gitgutter
nnoremap <leader>gdargs :echo 'gitgutter diff args: ' . g:gitgutter_diff_args<cr>

function! GitGutterToggleCached() abort
  if g:gitgutter_diff_args =~ ' --cached'
    let g:gitgutter_diff_args = substitute(g:gitgutter_diff_args, ' --cached', '', '')
  else
    let g:gitgutter_diff_args = g:gitgutter_diff_args . ' --cached'
  endif
  :GitGutterAll
endfunc

nnoremap <leader>gdca :call GitGutterToggleCached()<cr>

function! GitGutterToggleWhitespace() abort
  if g:gitgutter_diff_args =~ ' -w'
    let g:gitgutter_diff_args = substitute(g:gitgutter_diff_args, ' -w', '', '')
  else
    let g:gitgutter_diff_args = g:gitgutter_diff_args . ' -w'
  endif
  :GitGutterAll
endfunc

nnoremap <leader>gdw :call GitGutterToggleWhitespace()<cr>

nmap <silent> <c-k> <Plug>(ale_previous_wrap)
nnoremap <leader>ap :ALEPreviousWrap<cr>
nmap <silent> <c-j> <Plug>(ale_next_wrap)
nnoremap <leader>an :ALENextWrap<cr>
nnoremap <leader>af :ALEFix<cr>
" Keep gutter open at all times. Causes flickering when toggling Goyo
let g:ale_sign_column_always = 1
" Slow it down a little
let g:ale_lint_delay = 500
" Only enable one JS linter
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \   'typescript': ['eslint'],
      \   'html': [],
      \   'scss': ['scsslint']
      \}
let g:ale_fixers = {
      \   '*': ['trim_whitespace'],
      \   'javascript': ['prettier'],
      \}
let g:ale_set_highlights = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

set listchars=tab:>\ ,eol:¬,space:·,trail:·

set incsearch
set hlsearch
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
nnoremap / /\v
cnoremap %s/ %s/\v

" Use C-l to highlight the current cursor position
nnoremap <c-l> :call HighlightNearCursor()<cr>
function! HighlightNearCursor() abort
  if !exists('s:highlightcursor')
    match Todo /\k*\%#\k*/
    let s:highlightcursor=1
  else
    match None
    unlet s:highlightcursor
  endif
endfunction

nnoremap <leader>gg :call OpenFileFromModuleInPlusRegister()<cr>
function! OpenFileFromModuleInPlusRegister() abort
  let l:fname = getreg('+')
  let l:includeexpr = substitute(&includeexpr, 'v:fname', "'" . l:fname . "'", '')
  exec("find " . eval(l:includeexpr))
endfunction

" Use ripgrep as our grep program
set grepprg=rg\ --vimgrep

if has('popupwin')
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif
hi fzf1 ctermfg=red ctermbg=8
hi fzf2 ctermfg=green ctermbg=8
hi fzf3 ctermfg=white ctermbg=8
" Bindings for fzf
if executable('fzf')
  nnoremap <leader>f :Files<cr>
  nnoremap <leader>gf :GFiles?<cr>
  nnoremap <leader>t :Tags<cr>
  nnoremap <leader>i :Lines
  nnoremap <leader>/ :BLines<cr>
  nnoremap <leader>b :Buffers<cr>
  nnoremap <leader>r :Rg
  nnoremap <leader>c :Commands<cr>
  nnoremap <leader>m :Marks<cr>
  command! -bang -nargs=* RgPerl call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -t perl ".shellescape(<q-args>), 1, <bang>0)',

  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --vimgrep --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('down:80%')
    \           : fzf#vim#with_preview('down:80%:hidden', '?'),
    \   <bang>0)
else
  " Fallbacks just in case we're not set up yet
  nnoremap <leader>f :e
  nnoremap <leader>b :b
  nnoremap <leader>m :marks
endif

" Tags stuff
" Let Vim look upwards from pwd to find a tags file (it's the ;/ pattern that
" does it, see :h file-searching)
set tags=./tags;/,./TAGS;/,~/.tags/*tags,tags;/,TAGS;/

" Update tags in-place when viewing or editing a file
augroup ctags
  autocmd!
  " We scope this to only files that are in pwd using the stridx
  " FIXME: The tags file has the wrong paths! It omits the `/worktree-name`
  " part, so e.g. main.git paths are ~/git_tree/main/lib/…. Somehow I need to
  " tell ctags to put the worktree name in there…
  autocmd BufEnter,BufRead,BufWritePost * if stridx(expand('%:p'), getcwd()) == 0 && len(tagfiles()) | call system("(sed -i '/^\\S\\+\\s" . escape(expand('%'), '/') . "\\>/d' " . tagfiles()[0] . " && ctags -a -f " . tagfiles()[0] . " " . expand('%') . ") &") | endif
augroup END

" Make a new empty buffer
nnoremap <leader>n :enew<cr>

" More convenient mappings for toggling a fold
nnoremap <leader>z za
nnoremap <leader>Z zA

" Yank file path, optionally with line number
nnoremap <leader>yf :let @+=expand("%")<cr>
nnoremap <leader>yl :let @+=expand("%") . ':' . line(".")<cr>

" Bindings for session management
" https://dockyard.com/blog/2018/06/01/simple-vim-session-management-part-1
" Remove `options` from sessionoptions — options get mangled sometimes
let sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"

" session save
nnoremap <leader>ss :call mkdir(".vim", "p", 0700) <bar> Obsession .vim/Session.vim<cr>
" session restore
nnoremap <leader>sr :source .vim/Session.vim<cr>

" Bindings for goyo ("prose mode")
nnoremap <leader>p :Goyo<cr>
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

function! FileInsidePwd() abort
  return stridx(expand('%:p'), getcwd()) == 0
endfunction

set statusline=%#Directory#%{v\:servername\ ==\ ''?'':v\:servername.'\ '}%*
set statusline+=%<
" Colour the file path conditional on its being outside the ocurrent pwd
" https://gist.github.com/romainl/58245df413641497a02ffc06fd1f4747
" Note: this may have performance implications due to the system() call on
" every redraw. If letters like h/j/k/l/w/b/o start showing up on the screen
" without having been inserted, that's a sign that the performance here is not
" good enough & we should rethink the FileInsidePwd() function.
set statusline+=%#FileOutsidePwd#%{FileInsidePwd()?'':expand('%').'[🡕]\ '}%*%#StatusLine#%{FileInsidePwd()?expand('%').'\ ':''}%*
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
set statusline+=%h%m%r%=%-14.(%l,%c%V%)
" Add filetype to statusline
set statusline+=%y
set statusline+=\ %P
set laststatus=2
hi FileOutsidePwd ctermfg=yellow
hi StatusLine ctermbg=none
hi StatusLineNC ctermbg=none
hi VertSplit ctermbg=none

" Reduce prevalence of 'press enter to continue' on file write
set shortmess=filnxtToOS
" coc.nvim
set shortmess+=c

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
" Disallow NrrwRgn <leader>nr mapping, so we can map it ourselves
let g:nrrw_rgn_nomap_nr = 1
xnoremap <leader>nr :NR!<cr>
nnoremap <leader>wr :WidenRegion!<cr>

" Keep cursor centred
nnoremap <leader>zz :let &scrolloff=999-&scrolloff<cr>

" Show the undo viewer
nnoremap <leader>u :UndotreeToggle<cr>

" Detect & load changes to the file
set autoread
set autowrite

set fileformats=unix,mac,dos

" Enable bash-like command line completion
set wildmenu
set wildmode=list:longest,full
set wildignorecase

nnoremap <leader>tree :NERDTree<cr>

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

" Lines
onoremap <silent> al :normal val<cr>
xnoremap <silent> al $o0
onoremap <silent> il :normal vil<cr>
xnoremap <silent> il g_o^

" Slashes
onoremap <silent> a/ :<c-u>normal! F/vf/<cr>
xnoremap <silent> a/ :<c-u>normal! F/vf/<cr>
onoremap <silent> i/ :<c-u>normal! T/vt/<cr>
xnoremap <silent> i/ :<c-u>normal! T/vt/<cr>

" Most recent insert (mnemonic: edit)
onoremap <silent> ae :normal `[v`]<cr>
xnoremap <silent> ae :normal `[v`]<cr>
" onoremap <silent> ie :normal `[v`]h<cr>
" onoremap <silent> ie :normal `[v`]h<cr>

" ------------------------
" Abbreviations & snippets
" ------------------------

" Type <// to auto-close XML tags
" TODO: this seems busted??
inoremap <// </<c-x><c-o>

" ------------------------
" Brave experimental stuff
" ------------------------

set cmdwinheight=1

" vim: set foldmethod=marker foldlevel=0:
