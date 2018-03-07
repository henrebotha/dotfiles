set nocompatible              " be iMproved, required
filetype off                  " required

" Space leader is best leader
let mapleader = "\<space>"

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * close
endif

call plug#begin()

Plug 'elmcast/elm-vim'                    " Language pack for Elm
Plug 'henrebotha/kotlin-vim', { 'commit': '8905918' }
                                          " Language pack for Kotlin with fix
                                          " for comment syntax
Plug 'henrebotha/vim-protobuf'            " Language pack for Protobuf
Plug 'sheerun/vim-polyglot'               " Loads language packs on demand. Put
                                          " overriding language packs before this one
Plug 'vim-airline/vim-airline'            " Status line
Plug 'chrisbra/NrrwRgn', { 'on': ['NR', 'NrrwRgn'] }
                                          " Emacs-style narrowing
let g:airline#extensions#nrrwrgn#enabled = 0
Plug 'tpope/vim-surround'                 " Adds commands for surrounding chars
Plug 'w0rp/ale'                           " Async linter
Plug 'haya14busa/incsearch.vim'           " Highlight incremental search results
Plug 'junegunn/vim-easy-align'            " Align things, easily
Plug 'ervandew/supertab'                  " Tab completion
" Plug 'gregsexton/MatchTag'                " Highlight matching XML tag
Plug 'airblade/vim-gitgutter'             " Show git status in gutter, async
Plug 'junegunn/fzf.vim', { 'do': './install --bin' }
                                          " Fast fuzzy finder
Plug 'junegunn/goyo.vim'                  " Distraction-free mode
Plug 'tpope/vim-unimpaired'               " Pairwise commands
Plug 'joker1007/vim-ruby-heredoc-syntax'  " Highlighting heredocs in Ruby
Plug 'tpope/vim-commentary'               " Toggle comments
Plug 'tpope/vim-endwise'                  " Auto-insert Ruby end, etc
Plug 'tpope/vim-sleuth'                   " Auto-detect indentation
Plug 'mhallendal/spacedust-theme'         " Spacedust!
Plug 'marcelbeumer/spacedust-airline.vim' " Spacedust!
Plug 'mbbill/undotree'                    " Undo tree viewer
Plug 'chiel92/vim-autoformat'             " Automatically format various files
Plug 'AndrewRadev/splitjoin.vim'          " Transform between single- and multiline code
Plug 'andymass/matchup.vim'               " Movement between matching if/ends etc
Plug 'zyedidia/literate.vim'              " Syntax support for Literate
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
                                          " Tree browser
Plug 'tpope/vim-ragtag'
" Plug 'wincent/command-t'
" Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'jebaum/vim-tmuxify'

call plug#end()

" Disable polyglot's built-in Elm
let g:polyglot_disabled = ['elm']

let g:elm_format_autosave = 1

" Make Vim respond faster to some stuff, e.g. vim-gitgutter load delay
set updatetime=250

let g:airline_theme='spacedust'
" Fix vimdiff colours to be not so eye-bleeding. Ugly, but better
hi DiffAdd term=underline cterm=underline ctermfg=4 ctermbg=NONE
hi DiffChange term=underline cterm=underline ctermfg=5 ctermbg=NONE
hi DiffDelete term=underline cterm=underline ctermfg=6 ctermbg=NONE
hi DiffText term=underline cterm=underline ctermfg=9 ctermbg=NONE

" Enable fzf
set rtp+=/usr/local/opt/fzf

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
" ^k - go to previous error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" ^j - go to next error
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
set listchars=tab:>\ ,eol:¬,space:-

" " Highlight search results when using `/`
" set hls

" incsearch.vim settings
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

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

" Bindings for fzf
nmap <leader>f :Files<CR>
nmap <leader>t :Tags<CR>
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --hidden: Search hidden files and folders
" --color: Search color options
command! -bang -nargs=* Search call fzf#vim#grep('rg --column --line-number --no-heading --hidden --color "always" -e '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
nmap <leader>s :Search<CR>

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

" Make airline actually show up
set laststatus=2

" Enable powerline fonts
let g:airline_powerline_fonts = 1

" Line numbers
set number
set relativenumber
" relativenumber slows down rendering, so we use lazyredraw to buffer redraws
set lazyredraw

" Show as much as possible of a wrapped last line
set display=lastline

" Wrap at word boundaries, not in the middle of words
set linebreak

" Trim trailing whitespace on write
autocmd BufWritePre * %s/\s\+$//e

" Persist undo state across sessions
" https://www.reddit.com/r/vim/comments/2ib9au/why_does_exiting_vim_make_the_next_prompt_appear/cl0zb7m/
let s:vim_cache = expand("$HOME/.vim/undo")
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

" Markdown
" Enable syntax highlighting in fenced code blocks
let g:markdown_fenced_languages = ['slim', 'html', 'ruby', 'javascript', 'java', 'clojure', 'erb=eruby', 'coffee', 'xml', 'json', 'sql']

" Enable mouse scrolling inside tmux
set mouse=a

" JS lib syntax
" let g:used_javascript_libs = 'angularjs'

" Enable modelines for tweaking config per file
set modeline
set modelines=5

" Show partially-typed commands in the bottom right
set showcmd

" Show a ruler for column width
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Store swap files in a central location
set directory^=$HOME/.vim/tmp//

let g:nrrw_rgn_resize_window = 'relative'
let g:nrrw_rgn_width = 100

" <Leader>zz to keep cursor centred
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

" <Leader>u to show the undo viewer
nnoremap <Leader>u :UndotreeToggle<CR>

" <Leader>af to autoformat
nnoremap <Leader>af :Autoformat<CR>

" Detect & load changes to the file
set autoread

" Enable bash-like command line completion
set wildmode=list:longest,full

nnoremap <Leader>tree :NERDTree<CR>

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
