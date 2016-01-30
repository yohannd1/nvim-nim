if exists("s:loaded")
    finish
endif
let s:loaded = 1


function! features#debug#run()
    echo "Nim tools debugging info"
    echo "------------------------"
    echo "\n"
    echo "-------- Tools ---------"
    echo "Nim:        " . g:nvim_nim_exec_nim
    echo "Nimble:     " . g:nvim_nim_exec_nimble
    echo "Nimsuggest: " . g:nvim_nim_exec_nimsuggest
endfunction
