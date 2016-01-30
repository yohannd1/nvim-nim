if exists("s:loaded")
    finish
endif
let s:loaded = 1

let s:NimHighlighter = {}

function! s:NimHighlighter.on_stdout(job, chunk)
    if len(a:chunk[0]) != 0 && !(a:chunk[0] =~ "^usage")
        call extend(self.lines, a:chunk)
    endif
endfunction

function! s:NimHighlighter.on_stderr(job, chunk)
endfunction

function! s:NimHighlighter.on_exit()
    if self.file != expand("%:p")
        return
    endif
    let highlights = {
                \ 'skProc':         ["Function", []],
                \ 'skTemplate':     ["PreProc", []],
                \ 'skType':         ["Type", []],
                \ 'skMacro':        ["Macro", []],
                \ 'skMethod':       ["Function", []],
                \ 'skField':        ["Identifier", []],
                \ 'skAlias':        ["Type", []],
                \ 'skConditional':  ["Conditional", []],
                \ 'skConst':        ["Constant", []],
                \ 'skConverter':    ["Function", []],
                \ 'skDynLib':       ["Include", []],
                \ 'skEnumField':    ["Identifier", []],
                \ 'skForVar':       ["Special", []],
                \ 'skGenericParam': ["Typedef", []],
                \ 'skGlobalVar':    ["Constant", []],
                \ 'skGlobalLet':    ["Constant", []],
                \ 'skIterator':     ["Keyword", []],
                \ 'skLabel':        ["Identifier", []],
                \ 'skLet':          ["Constant", []],
                \ 'skModule':       ["Include", []],
                \ 'skPackage':      ["Define", []],
                \ 'skParam':        ["Identifier", []],
                \ 'skResult':       ["Keyword", []],
                \ 'skStub':         ["PreCondit", []],
                \ 'skTemp':         ["Identifier", []],
                \ 'skUnknown':      ["Error", []],
                \ 'skVar':          ["Constant", []]
                \ }

    for line in self.lines
        if len(line) == 0
            continue
        endif
        let p = split(line, "	")
        let line = p[2] + 0
        let c = p[3] + 1
        let s = p[4] + 0
        if getline(line)[c - 1] == '*'
            let c -= s
        endif
        call add(highlights[p[1]][1], [line, c, s])
    endfor

    let new_highlights = []
    for [k, v] in items(highlights)
        call add(new_highlights, matchaddpos(v[0], v[1]))
    endfor

    for m in b:old_highlights
        call matchdelete(m)
    endfor

    let b:old_highlights = new_highlights
endfunction

function highlighter#New()
    let result = copy(s:NimHighlighter)
    let result.lines = []
    let result.job = jobstart([g:nvim_nim_exec_nimsuggest, '--v2', '--stdin', expand("%:p")], result)
    let result.file = expand("%:p")
    let tempfile = result.file . ".temp"
    call writefile(getline(1, '$'), tempfile)
    call jobsend(result.job, "highlight " . result.file . ";" . tempfile . ":1:1\nquit\n") 
    if !exists("b:old_highlights")
        let b:old_highlights = []
    endif
    return result
endfunction


function! highlighter#guard()
    if line("$") + 0 < 500
        call highlighter#New()
    endif
endfunction
