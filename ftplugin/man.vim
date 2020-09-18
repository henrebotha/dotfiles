setlocal signcolumn=no
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal signcolumn<'
else
  let b:undo_ftplugin = 'setlocal signcolumn<'
endif
