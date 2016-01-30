if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:DefinitionImpl = {}


function! s:DefinitionImpl.run(data)
    if len(a:data.lines) > 0
        let [_, _, _, _, filename, l, c, _] = split(a:data.lines[0], "	")
        call util#JumpToLocation(filename, l, c + 2)
    endif
endfunction


function! features#definition#run()
    call suggest#New("def", 0, s:DefinitionImpl)
endfunction
