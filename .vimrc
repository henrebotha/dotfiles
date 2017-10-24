set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'sheerun/vim-polyglot'               " Loads language packs on demand
Plug 'vim-airline/vim-airline'            " Status line
Plug 'chrisbra/NrrwRgn'                   " Emacs-style narrowing
Plug 'tpope/vim-surround'                 " Adds commands for surrounding chars
Plug 'w0rp/ale'                           " Async linter
Plug 'haya14busa/incsearch.vim'           " Highlight incremental search results
Plug 'junegunn/vim-easy-align'            " Align things, easily
Plug 'ervandew/supertab'                  " Tab completion
Plug 'gregsexton/MatchTag'                " Highlight matching XML tag
Plug 'airblade/vim-gitgutter'             " Show git status in gutter, async
Plug 'junegunn/fzf.vim'                   " Fast fuzzy finder
Plug 'junegunn/goyo.vim'                  " Distraction-free mode
Plug 'tpope/vim-unimpaired'               " Pairwise commands
Plug 'joker1007/vim-ruby-heredoc-syntax'  " Highlighting heredocs in Ruby
Plug 'tpope/vim-commentary'               " Toggle comments
Plug 'tpope/vim-endwise'                  " Auto-insert Ruby end, etc
Plug 'tpope/vim-sleuth'                   " Auto-detect indentation
Plug 'marcelbeumer/spacedust-airline.vim' " Spacedust!
Plug 'tpope/vim-ragtag'
" Plug 'wincent/command-t'
" Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'jebaum/vim-tmuxify'

call plug#end()

let g:airline_theme='spacedust'

" Enable fzf
set rtp+=/usr/local/opt/fzf

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Shortcuts for ale to navigate between errors
" ^k - go to previous error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" ^j - go to next error
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" Keep gutter open at all times
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
function HighlightNearCursor()
  if !exists("s:highlightcursor")
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

" Bindings for goyo ("prose mode")
nmap <leader>p :Goyo<CR>

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

" Show as much as possible of a wrapped last line
set display=lastline

" Wrap at word boundaries, not in the middle of words
set linebreak

" Linter settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_slim_checkers = []
" Disable Syntastic by default; do :call ActivateSyntastic() to enable. This is
" a startup time optimisation. See
" https://github.com/vim-syntastic/syntastic/issues/91#issuecomment-2888737
" let g:pathogen_disabled = ['syntastic']
" function! ActivateSyntastic() abort
"   set rtp+=~/.vim/bundle/syntastic
"   runtime plugin/syntastic.vim
" endfunction

" Trim trailing whitespace on write
autocmd BufWritePre * %s/\s\+$//e

" Persist undo state across sessions
set undofile
set undodir=$HOME/.vim/undo
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
highligh ColorColumn ctermbg=0 guibg=lightgrey

" Store swap files in a central location
set directory^=$HOME/.vim/tmp//

" Detect & load changes to the file
set autoread
