if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:InfoImpl = {}

function! s:InfoImpl.run(data)
    if len(a:data.lines) == 0
        echo "No information found"
    else
        let [_, ctype, name, type, filename, l, c, doc] = split(a:data.lines[0], "	")
        echohl Function | echon "Type"
        echohl Comment | echon ": "
        echohl Typedef | echon type
    endif
endfunction


function! features#info#run()
    call suggest#New("def", 0, s:InfoImpl)
endfunction
