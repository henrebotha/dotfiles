setlocal formatprg=python\ -mjson.tool
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal formatprg<'
else
  let b:undo_ftplugin = 'setlocal formatprg<'
endif
