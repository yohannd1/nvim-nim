if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:InfoImpl = {}

let s:idtypes = {
            \ 'skProc':         "Function",
            \ 'skTemplate':     "Template",
            \ 'skType':         "Type",
            \ 'skMacro':        "Macro",
            \ 'skMethod':       "Method",
            \ 'skField':        "Field",
            \ 'skAlias':        "Alias",
            \ 'skConditional':  "Conditional",
            \ 'skConst':        "Constant",
            \ 'skConverter':    "Converter",
            \ 'skDynLib':       "Dynamic library",
            \ 'skEnumField':    "Enum field",
            \ 'skForVar':       "Loop variable",
            \ 'skGenericParam': "Generic parameter",
            \ 'skGlobalVar':    "Global variable",
            \ 'skGlobalLet':    "Global constant",
            \ 'skIterator':     "Iterator",
            \ 'skLabel':        "Label",
            \ 'skLet':          "Runtime constant",
            \ 'skModule':       "Module",
            \ 'skPackage':      "Package",
            \ 'skParam':        "Parameter",
            \ 'skResult':       "Result",
            \ 'skStub':         "Stub",
            \ 'skTemp':         "Temporary",
            \ 'skUnknown':      "Unknown",
            \ 'skVar':          "Variable"
            \ }

function! s:InfoImpl.run(data)
    if len(a:data.lines) == 0
        echo "No information found"
    else
        echohl None
        let [_, ctype, name, type, filename, l, c, doc] = split(a:data.lines[0], "\\t")
        let path = join(split(name, '\.')[0:-2], ".")
        let module = split(name, '\.')[0]
        let name = split(name, '\.')[-1]
        let node_type = s:idtypes[ctype]

        echohl Function | echon name
        echohl Comment | echon "\n » "
        echohl Type | echon node_type

        if len(type) > 0 && name != type
            echon "\n"
            echohl Comment | echon " » "
            echohl Typedef | echon type
        end

        echohl Comment | echon "\n » "
        echohl Include | echon path
        echohl Comment | echon " ("
        echohl String | echon filename
        echohl Comment | echon ")"
    endif
endfunction


function! features#info#run()
    call util#StartQuery()
    call suggest#New("def", 0, s:InfoImpl)
endfunction
