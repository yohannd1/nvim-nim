if exists("s:loaded")
    finish
endif
let s:loaded = 1

au BufNewFile,BufRead *.nim set filetype=nim
au BufNewFile,BufRead *.nims set filetype=nims

let g:nvim_nim_enable_highlighter = 0
