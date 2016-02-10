if exists("g:nvim_nim_ftdetect_loaded")
    finish
endif
let g:nvim_nim_ftdetect_loaded = 1

au BufNewFile,BufRead *.nim setlocal filetype=nim
au BufNewFile,BufRead *.nims setlocal filetype=nims
