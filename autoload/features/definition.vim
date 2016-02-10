if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:DefinitionImpl = {}


function! s:DefinitionImpl.run(data)
    let res = util#ParseV1(a:data.lines[0])
    call util#JumpToLocation(res.file, res.line, res.col + 1)
endfunction


function! features#definition#run()
    call suggest#New("def", 0, 0, s:DefinitionImpl)
endfunction
