if exists ("g:goethe")
  finish
endif
let g:goethe = 1

command! -nargs=0 PersistTheme lua require("goethe").persist()
command! -nargs=0 ThemeHistory lua require("goethe").picker()
