if exists("s:loaded")
    finish
endif
let s:loaded = 1

au BufNewFile,BufRead *.nim setlocal filetype=nim
au BufNewFile,BufRead *.nims setlocal filetype=nims
