if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:InfoImpl = {}

function! s:New(useWeb)
    let result = copy(s:InfoImpl)
    let result.useWeb = a:useWeb
    return result
endfunction

function! s:InfoImpl.run(data)
    if len(a:data.lines) == 0
        echo "No information found"
        return
    endif

    let res = util#ParseV1(a:data.lines[0])

    if self.useWeb
        call util#open_module_doc(res.location, res.lname)
    else
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


function! features#info#web()
    call suggest#New("def", 1, 0, s:New(1))
endfunction


function! features#info#run()
    call suggest#New("def", 1, 0, s:New(0))
endfunction
