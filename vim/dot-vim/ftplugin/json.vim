if executable('jq')
  setlocal formatprg=jq
else
  setlocal formatprg=python\ -mjson.tool
endif
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setlocal formatprg<'
