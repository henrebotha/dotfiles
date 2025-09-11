" Don't run this if we're actually in a Markdown file, and thus loading
" ftplugins for g:markdown_fenced_languages. Actual syntax highlighting stuff
" etc should happen outside of this check, and we should then ensure to run
" the b:undo_ftplugin stuff outside of the check too.
if &filetype ==# 'markdown'
  finish
endif

nmap <buffer> <leader>debug o.tap { \|x\| binding.pry }<Esc>
