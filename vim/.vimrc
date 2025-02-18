filetype off                  " required

" Before we continue, detect which version of Vim we're running {{{
if has('nvim')
  let config_path = stdpath('config')
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
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let autoload_path = config_path . '/autoload'
let plug_path = autoload_path . '/plug.vim'
if empty(glob(autoload_path))
  silent execute '!curl -fLo ' . plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  autocmd VimEnter * close
endif

" Load a plugin conditionally, but allow PlugClean to see it as registered
" even when not loaded.
" https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction " }}}

" Disable polyglot's built-in Elm
" Disable Git so we can get the newer version
let g:polyglot_disabled = ['elm', 'git', 'ocaml', 'markdown', 'sh']

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
" Not using Cond for this as I want to segregate it from plain Vim installs.
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
Plug 'preservim/tagbar'                   " File outline viewer
Plug 'andymass/matchup.vim'               " Movement between matching if/ends etc
Plug isdirectory('/opt/homebrew/opt/fzf') ? '/opt/homebrew/opt/fzf' : '~/.fzf'
" TODO: fzf.vim from 556f45e (2024-10-29) onwards requires fzf 0.56, which is
" quite bleeding-edge and might not be available everywhere. Figure out a way
" to determine whether we are in an available context, and if not, pin the
" plugin to ec75ffb.
Plug 'junegunn/fzf.vim', { 'do': './install --bin' }
                                          " Fast fuzzy finder
Plug 'tpope/vim-apathy'                   " Some path values for various langs
Plug 'dzeban/vim-log-syntax'              " Log syntax

Plug 'metakirby5/codi.vim', { 'on': ['Codi'] }
                                          " In-buffer REPL
Plug 'chrisbra/recover.vim'               " Add 'compare' option to swap file recovery

Plug 'dense-analysis/ale', Cond(v:progname !=? 'view')
                                          " Async linter
Plug 'junegunn/vim-easy-align', Cond(v:progname !=? 'view')
                                          " Align things, easily
Plug 'tpope/vim-commentary', Cond(v:progname !=? 'view')
                                          " Toggle comments
Plug 'tpope/vim-endwise', Cond(v:progname !=? 'view')
                                          " Auto-insert Ruby end, etc
Plug 'tpope/vim-sleuth', Cond(v:progname !=? 'view')
                                           " Auto-detect indentation
Plug 'mbbill/undotree', Cond(v:progname !=? 'view')
                                           " Undo tree viewer
Plug 'AndrewRadev/splitjoin.vim', Cond(v:progname !=? 'view')
                                           " Transform between single- and multiline code
Plug 'scrooloose/nerdtree', Cond(v:progname !=? 'view', { 'on': 'NERDTreeToggle' })
                                          " Tree browser
Plug 'tpope/vim-repeat', Cond(v:progname !=? 'view')
                                           " Allow plugins to specify custom repeat actions
Plug 'tpope/vim-ragtag', Cond(v:progname !=? 'view')
                                           " Plug 'jebaum/vim-tmuxify'
Plug 'groenewege/vim-less', Cond(v:progname !=? 'view')
                                           " Trim whitespace on lines I touch
Plug 'tpope/vim-obsession', Cond(v:progname !=? 'view')
                                           " Sane & continuous session saving
Plug 'tpope/vim-fugitive', Cond(v:progname !=? 'view')
                                           " Git

" Automatically executes filetype plugin indent on and syntax enable.
call plug#end() " }}}

set backspace=indent,eol,start
set infercase
set showmatch

set hidden
nnoremap <c-n> :bnext<cr>
nnoremap <c-p> :bprev<cr>

set signcolumn=yes

command! -nargs=1 -complete=shellcmd Man :call Man(<q-args>)

function! Man(command) abort
  enew
  execute "read !man " . a:command
  norm ggdd
  setlocal nomodified
  setlocal ro
  setlocal ft=man
endfunction

" Hook into OS clipboard. On Linux and similar, this will use the ^C ^V
" "CLIPBOARD" (register "+"), not the copy-on-select "PRIMARY" (which is
" register "*"). See
" https://specifications.freedesktop.org/clipboards-spec/clipboards-latest.txt
if has('clipboard')
  if has('mac')
    set clipboard=unnamed
  else
    set clipboard=unnamedplus
  endif
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
hi SignColumn ctermbg=NONE
hi FoldColumn ctermbg=NONE
" Fix vimdiff colours to be not so eye-bleeding. Ugly, but better
hi DiffAdd term=underline cterm=underline ctermfg=4 ctermbg=NONE
hi DiffChange term=underline cterm=underline ctermfg=5 ctermbg=NONE
hi DiffDelete term=underline cterm=underline ctermfg=6 ctermbg=NONE
hi DiffText term=underline cterm=underline ctermfg=9 ctermbg=NONE
" Make comments italic, because it's nice
hi Comment term=italic cterm=italic
" Remove the black background from folds
hi Folded ctermbg=NONE

hi fzf1 ctermfg=red ctermbg=8
hi fzf2 ctermfg=green ctermbg=8
hi fzf3 ctermfg=white ctermbg=8

hi FileOutsidePwd ctermfg=yellow
hi FileOutsidePwdIcon ctermbg=yellow
hi FileOutsidePwdIcon ctermfg=black

hi SessionActive ctermfg=green
hi SessionPaused ctermfg=yellow

hi StatusLine ctermbg=NONE
hi StatusLineNC ctermbg=NONE
hi VertSplit ctermbg=NONE

hi GitGutterAdd ctermbg=NONE
hi GitGutterAddLine ctermbg=NONE
hi GitGutterChangeDelete ctermbg=NONE
hi GitGutterChangeDeleteLineNr ctermbg=NONE
hi GitGutterChangeLineNr ctermbg=NONE
hi GitGutterDeleteInvisible ctermbg=NONE
hi GitGutterAddIntraLine ctermbg=NONE
hi GitGutterAddLineNr ctermbg=NONE
hi GitGutterChangeDeleteInvisible ctermbg=NONE
hi GitGutterChangeInvisible ctermbg=NONE
hi GitGutterDelete ctermbg=NONE
hi GitGutterDeleteLine ctermbg=NONE
hi GitGutterAddInvisible ctermbg=NONE
hi GitGutterChange ctermbg=NONE
hi GitGutterChangeDeleteLine ctermbg=NONE
hi GitGutterChangeLine ctermbg=NONE
hi GitGutterDeleteIntraLine ctermbg=NONE
hi GitGutterDeleteLineNr ctermbg=NONE

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
      \   'graphql': ['gqlint'],
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
" Search for visual mode selection
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

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

" Toggle todo items
nnoremap <silent> <leader>td :call ToggleToDoItem()<cr>
function! ToggleToDoItem() abort
  let l:line = getbufline("%", line('.'))[0]
  if l:line =~ '\([*\-]\s*\)\[ \]'
    s/\v([*\-]\s*)\[ \]/\1[x]/
  elseif l:line =~ '\([*\-]\s*\)\[x\]'
    s/\v([*\-]\s*)\[x\]/\1[ ]/
  endif
endfunction

nnoremap <leader>gg :call OpenFileFromModuleInPlusRegister()<cr>
function! OpenFileFromModuleInPlusRegister() abort
  let l:fname = getreg('+')
  let l:includeexpr = substitute(&includeexpr, 'v:fname', "'" . l:fname . "'", '')
  exec("find " . eval(l:includeexpr))
endfunction

if executable('rg')
  " Use ripgrep as our grep program
  set grepprg=rg\ --vimgrep
endif

if has('popupwin')
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif
let g:fzf_vim = {}
let g:fzf_vim.grep_multi_line = 2
" Bindings for fzf
if executable('fzf')
  nnoremap <leader>f :Files<cr>
  nnoremap <leader>gf :GFiles?<cr>
  nnoremap <leader>t :Tags<cr>
  nnoremap <leader>i :Lines
  nnoremap <leader>/ :BLines<cr>
  nnoremap <leader>b :Buffers<cr>
  nnoremap <leader>r :Rg!
  nnoremap <leader>c :Commands<cr>
  nnoremap <leader>m :Marks<cr>
  command! -bang -nargs=* RgPerl call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -t perl ".shellescape(<q-args>), 1, <bang>0)',

  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --hidden -g "!.git" --vimgrep --color=always -- '.shellescape(<q-args>),
    \   <bang>0 ? fzf#vim#with_preview('down:70%')
    \           : fzf#vim#with_preview('down:70%:hidden', '?'),
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
  " fnamemodify(tagfiles()[0], ':p:h') gives the dir containing tagfile.
  " expand('%:p') gives the full path to the current file.
  " The substitute() therefore gives the current file path relative to the dir
  " containing the tagfile.
  " We scope this to only files that are in pwd using the stridx
  " The system call here reads: "Delete all tags for the current file, then
  " generate & append tags for the current file."
  autocmd BufEnter,BufRead,BufWritePost * if stridx(expand('%:p'), getcwd()) == 0 && len(tagfiles()) | call system("(sed -i '/^\\S\\+\\s" . escape(expand('%'), '{}*/.') . "\\>/d' " . tagfiles()[0] . " && ctags -a -f " . tagfiles()[0] . " " . expand('%') . ") &") | endif
augroup END

" Only show tagbar when we are trying to navigate to a tag.
let g:tagbar_autoclose = 1
nnoremap <silent> <F8> :TagbarToggle<CR>

" Make a new empty buffer
nnoremap <leader>n :enew<cr>

" More convenient mappings for toggling a fold
nnoremap <leader>z za
nnoremap <leader>Z zA

nnoremap <leader>W :set wrap!<cr>

" Yank file path, optionally with line number
nnoremap <leader>yf :let @+=expand("%")<cr>
nnoremap <leader>yl :let @+=expand("%") . ':' . line(".")<cr>
vnoremap yr :call CopyWithRef()<cr>

" https://stackoverflow.com/a/64639752/1966418
function! VisualSelection()
  if mode()=="v"
    let [line_start, column_start] = getpos("v")[1:2]
    let [line_end, column_end] = getpos(".")[1:2]
  else
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
  end

  if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
    let [line_start, column_start, line_end, column_end] =
          \   [line_end, column_end, line_start, column_start]
  end
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ['']
  endif
  if &selection ==# "exclusive"
    let column_end -= 1
  endif
  if visualmode() ==# "\<C-V>"
    for idx in range(len(lines))
      let lines[idx] = lines[idx][: column_end - 1]
      let lines[idx] = lines[idx][column_start - 1:]
    endfor
  else
    let lines[-1] = lines[-1][: column_end - 1]
    let lines[ 0] = lines[ 0][column_start - 1:]
  endif
  return join(lines, "\n")
endfunction

" Copy the file name, Git repo name, and commit hash along with whatever's
" selected.
function! CopyWithRef()
  let repoRemote=trim(system("git remote -v | head -n1 | awk '{print $2}' | sed 's/^\\w\\+\\(\\@\\|\\/\\/\\).\\+:\\/\\?//'"))
  let commit=trim(system("git rev-parse --short=8 HEAD"))
  let lineNumber=a:firstline
  let filePathFull=expand('%:p')
  if filereadable(filePathFull)
    let repoTopLevel=FindRepoRoot()
    let filePathRelative=substitute(filePathFull, repoTopLevel.'/', '', '')
  else
    let filePathRelative='<untitled>'
  endif
  let visualSelection=VisualSelection()

  let @+=repoRemote
  let @+=@+.'@'
  let @+=@+.commit
  let @+=@+.':'
  let @+=@+.filePathRelative
  let @+=@+.':'
  let @+=@+.lineNumber
  let @+=@+."\n\n"
  let @+=@+.visualSelection
endfunction

" Yank entire buffer into clipboard, then quit
nnoremap <leader>yq :w! /tmp/scratchpad.txt<CR>gg0vG$y:q!<CR>

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

function! FindRepoRoot()
  return system('git rev-parse --show-toplevel 2>/dev/null' . ' || ' . 'hg root 2>/dev/null')[:-2]->escape(' ')
endfunction

" Allow gf (and similar) to find things relative to the repo root.
function! s:AddRepoRootToPath()
  if isdirectory(FindRepoRoot())
    execute "set path+=" . FindRepoRoot()
  endif
endfunction

call s:AddRepoRootToPath()
augroup change_pwd
  autocmd!
  autocmd DirChanged * call s:AddRepoRootToPath()
augroup end

function! FileInsidePwd() abort
  " Consider the current file to be outside the cwd if the cwd is not an
  " initial substring of the file path. Additionally, if the current file is
  " [No Name], we consider it to be inside the cwd (until such time as it
  " gets saved to a different location).
  return strlen(expand('%:p')) == 0 || stridx(expand('%:p'), getcwd()) == 0
endfunction

function! RelativePath(path)
  return fnamemodify(a:path,':~:.')
endfunction

function! RelativePathSession()
  return RelativePath(v:this_session)
endfunction

set statusline=%#Directory#%{v\:servername\ ==\ ''?'':v\:servername.'\ '}%*
set statusline+=%<
" Colour the file path conditional on its being outside the ocurrent pwd
" https://gist.github.com/romainl/58245df413641497a02ffc06fd1f4747
" Note: this may have performance implications due to the system() call on
" every redraw. If letters like h/j/k/l/w/b/o start showing up on the screen
" without having been inserted, that's a sign that the performance here is not
" good enough & we should rethink the FileInsidePwd() function.
set statusline+=%#FileOutsidePwd#%{FileInsidePwd()?'':expand('%')}%*%#StatusLine#%{FileInsidePwd()?expand('%').'\ ':''}%*
set statusline+=%#FileOutsidePwdIcon#%{FileInsidePwd()?'':'[↗]'}%*%#StatusLine#%{FileInsidePwd()?'\ ':''}%*
set statusline+=\ %h%m%r
set statusline+=%=
" Add filetype to statusline
set statusline+=%y
set statusline+=\ %-.(%l,%c%V%)
set statusline+=\ %P
if exists('g:plugs') && has_key(g:plugs, 'vim-obsession')
  set statusline+=\ %{v\:this_session\ ==\ ''?'[no\ session]':''}
  set statusline+=%#SessionPaused#%{v\:this_session\ ==\ ''?'':ObsessionStatus('','[◼\ '.RelativePathSession().']')}
  set statusline+=%#SessionActive#%{v\:this_session\ ==\ ''?'':ObsessionStatus('[▶\ '.RelativePathSession().']','')}
  set statusline+=%#StatusLine#
endif
set laststatus=2

" Reduce prevalence of 'press enter to continue' on file write
set shortmess=filnxtToOS

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
let &showbreak = '⤷ '

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

set backup
set writebackup
set backupdir^=~/.vim/backup//
set backupcopy=yes
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

" Keybinds for vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Enable syntax highlighting in Markdown fenced code blocks
" Note: Ensure all associated ftplugins exit early if we're actually in
" Markdown.
let g:markdown_fenced_languages = ['html', 'ruby', 'javascript', 'erb=eruby', 'xml', 'json', 'sql']

" Enable mouse scrolling inside tmux
set mouse=a
set mousemodel=popup

" Change cursor shape based on mode
if empty($TMUX)
  " Vertical bar in insert mode
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  " Block in normal mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  " Underline in replace mode
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  " Vertical bar in insert mode
  let &t_SI = "\e[5 q"
  " Block in normal mode
  let &t_SR = "\e[4 q"
  " Underline in replace mode
  let &t_EI = "\e[1 q"
endif

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

if filereadable(expand('~/.vim-work'))
  source ~/.vim-work
endif

" vim: set foldmethod=marker foldlevel=0:
