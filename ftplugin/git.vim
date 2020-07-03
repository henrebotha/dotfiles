setlocal keywordprg=git\ show
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal keywordprg<'
else
  let b:undo_ftplugin = 'setlocal keywordprg<'
endif
