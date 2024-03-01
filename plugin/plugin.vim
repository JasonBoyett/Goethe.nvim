if exists ("g:goethe")
  finish
endif
let g:goethe = 1

command! -nargs=0 PersistTheme lua require("goethe").persist()
command! -nargs=0 ThemeHistory lua require("goethe").picker()
command! -nargs=0 ThemeHistoryReset lua require("goethe").reset_history()
command! -nargs=0 ThemeReset lua require("goethe").reset()
