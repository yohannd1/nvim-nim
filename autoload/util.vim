if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:idtypes = {
            \ 'skProc':         ["p", "Function"],
            \ 'skTemplate':     ["t", "Template"],
            \ 'skType':         ["T", "Type"],
            \ 'skMacro':        ["M", "Macro"],
            \ 'skMethod':       ["m", "Method"],
            \ 'skField':        ["field", "Field"],
            \ 'skAlias':        ["a", "Alias"],
            \ 'skConditional':  ["c", "Conditional"],
            \ 'skConst':        ["C", "Constant"],
            \ 'skConverter':    ["c", "Converter"],
            \ 'skDynLib':       ["d", "Dynamic library"],
            \ 'skEnumField':    ["e", "Enum field"],
            \ 'skForVar':       ["l", "Loop variable"],
            \ 'skGenericParam': ["g", "Generic parameter"],
            \ 'skGlobalVar':    ["g", "Global variable"],
            \ 'skGlobalLet':    ["g", "Global constant"],
            \ 'skIterator':     ["i", "Iterator"],
            \ 'skLabel':        ["l", "Label"],
            \ 'skLet':          ["r", "Runtime constant"],
            \ 'skModule':       ["m", "Module"],
            \ 'skPackage':      ["p", "Package"],
            \ 'skParam':        ["p", "Parameter"],
            \ 'skResult':       ["r", "Result"],
            \ 'skStub':         ["s", "Stub"],
            \ 'skTemp':         ["t", "Temporary"],
            \ 'skUnknown':      ["u", "Unknown"],
            \ 'skVar':          ["v", "Variable"],
            \ }


function! util#FirstNonEmpty(lines)
    for line in a:lines
        if len(line) > 0
            return line
        endif
    endfor
endfunction


function! util#CheckDependency(command)
    if !executable(a:command)
        echoerr "Not found: " . a:command
        finish
    endif
    return exepath(a:command)
endfunction


function! util#JumpToLocation(file, line, col)
    if expand("%:p") != a:file
        execute ":e " . a:file
    endif
    execute ":" . a:line
    execute ":norm " . (a:col) . "|"
endfunction


function! util#JumpFromQuickfix(shouldReturn)
    let [file, location, _] = split(getline(line(".")), "|")
    let [l, c] = split(location, " col ")
    wincmd p
    call util#JumpToLocation(file, l, c)
    if a:shouldReturn
        norm zt
        wincmd p
    endif
endfunction


function! util#StartQuery()
    echohl Comment | echo "..."
endfunction


function! s:GetModule(path)
    return a:path[0]
endfunction


function! util#ParseV1(line)
    let res = split(a:line, "	")
    let path = split(res[2], "\\.")

    let result = {
                \ "ctype": res[0],
                \ "kind": res[1],
                \ "symbol": res[2],
                \ "name": res[3],
                \ "file": res[4],
                \ "line": res[5],
                \ "col": res[6],
                \ "doc": res[7],
                \ "module": s:GetModule(path),
                \ "location": join(path[0:-2], "."),
                \ "lname": path[-1],
                \ "kindstr": s:idtypes[res[1]][1],
                \ "kindshort": s:idtypes[res[1]][0],
                \ }
    return result
endfunction


function! util#ParseV2(line)
    let res = split(a:line, "	")
    let path = split(res[2], "\\.")
    let result = {
                \ "ctype": res[0],
                \ "kind": res[1],
                \ "symbol": res[2],
                \ "type": res[3],
                \ "file": res[4],
                \ "line": res[5],
                \ "col": res[6],
                \ "doc": res[7],
                \ "quality": res[8],
                \ "module": s:GetModule(path),
                \ "location": join(path[0:-2], "."),
                \ "name": path[-1],
                \ "lname": path[-1],
                \ "kindstr": s:idtypes[res[1]][1],
                \ "kindshort": s:idtypes[res[1]][0],
                \ }
    return result
endfunction
