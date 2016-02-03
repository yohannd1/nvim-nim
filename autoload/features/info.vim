if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:InfoImpl = {}

function! s:InfoImpl.run(data)
    if len(a:data.lines) == 0
        echo "No information found"
    else
        let res = util#ParseV1(a:data.lines[0])

        echohl None
        echohl Function | echon res.lname
        echohl Comment | echon "\n » "
        echohl Type | echon res.kindstr

        if len(res.name) > 0 && res.lname != res.name
            echon "\n"
            echohl Comment | echon " » "
            echohl Typedef | echon res.name
        end

        echohl Comment | echon "\n » "
        echohl Include | echon res.location
        echohl Comment | echon " ("
        echohl String | echon res.file
        echohl Comment | echon ")"

        if res.doc != "\"\""
            echohl Comment | echon "\n » "
            echohl Normal | echon res.doc
        endif
    endif
endfunction


function! features#info#run()
    call suggest#New("def", 0, 0, s:InfoImpl)
endfunction
