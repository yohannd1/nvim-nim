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
    if empty(self.lines) && self.file != expand("%:p")
        return
    endif

    let highlights = {
                \ 'skProc':         ["Function",    [], 0],
                \ 'skTemplate':     ["PreProc",     [], 0],
                \ 'skType':         ["Type",        [], 0],
                \ 'skMacro':        ["Macro",       [], 0],
                \ 'skMethod':       ["Function",    [], 0],
                \ 'skField':        ["Identifier",  [], 0],
                \ 'skAlias':        ["Type",        [], 0],
                \ 'skConditional':  ["Conditional", [], 0],
                \ 'skConst':        ["Constant",    [], 1],
                \ 'skConverter':    ["Function",    [], 0],
                \ 'skDynLib':       ["Include",     [], 0],
                \ 'skEnumField':    ["Identifier",  [], 0],
                \ 'skForVar':       ["Special",     [], 1],
                \ 'skGenericParam': ["Typedef",     [], 0],
                \ 'skGlobalVar':    ["Constant",    [], 1],
                \ 'skGlobalLet':    ["Constant",    [], 1],
                \ 'skIterator':     ["Keyword",     [], 0],
                \ 'skLabel':        ["Identifier",  [], 0],
                \ 'skLet':          ["Constant",    [], 1],
                \ 'skModule':       ["Include",     [], 1],
                \ 'skPackage':      ["Define",      [], 0],
                \ 'skParam':        ["Identifier",  [], 1],
                \ 'skResult':       ["Keyword",     [], 0],
                \ 'skStub':         ["PreCondit",   [], 0],
                \ 'skTemp':         ["Identifier",  [], 1],
                \ 'skUnknown':      ["Error",       [], 0],
                \ 'skVar':          ["Constant",    [], 1]
                \ }

    for line in self.lines
        if len(line) == 0
            continue
        endif

        let p = split(line, "	")
        if len(p) < 5
            continue
        endif

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
        if g:nvim_nim_highlighter_semantic && v[2]
            for pos in v[1]
                let l = getline(pos[0])
                let c = pos[1]
                let class = (char2nr(l[c]) * char2nr(l[c + 1])) % 20
                call add(new_highlights, matchaddpos("Semantic" . class, [pos]))
            endfor
        else
            call add(new_highlights, matchaddpos(v[0], v[1]))
        endif
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
    if g:nvim_nim_highlighter_enable
        if line("$") + 0 < 500
            call highlighter#New()
        endif
    endif
endfunction
