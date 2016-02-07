if exists("s:loaded")
    finish
endif
let s:loaded = 1

let s:highlights = {
            \ 'skProc':         "Function",
            \ 'skTemplate':     "PreProc",
            \ 'skType':         "Type",
            \ 'skMacro':        "Macro",
            \ 'skMethod':       "Function",
            \ 'skField':        "Identifier",
            \ 'skAlias':        "Type",
            \ 'skConditional':  "Conditional",
            \ 'skConst':        "Constant",
            \ 'skConverter':    "Function",
            \ 'skDynLib':       "Include",
            \ 'skEnumField':    "Identifier",
            \ 'skForVar':       "Special",
            \ 'skGenericParam': "Typedef",
            \ 'skGlobalVar':    "Constant",
            \ 'skGlobalLet':    "Constant",
            \ 'skIterator':     "Keyword",
            \ 'skLabel':        "Identifier",
            \ 'skLet':          "Constant",
            \ 'skModule':       "Include",
            \ 'skPackage':      "Define",
            \ 'skParam':        "Identifier",
            \ 'skResult':       "Keyword",
            \ 'skStub':         "PreCondit",
            \ 'skTemp':         "Identifier",
            \ 'skUnknown':      "Error",
            \ 'skVar':          "Constant",
            \ }


let s:NimHighlighter = {
            \ }
            " \ 'pty': 1

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

    for m in b:highlights
        call matchdelete(m)
    endfor

    let b:highlights = []
    let semantics_set = {}

    for ctype in g:nvim_nim_highlighter_semantics
        let semantics_set[ctype] = 1
    endfor

    for line in self.lines
        if len(line) == 0
            continue
        endif

        let p = split(line, "	")
        if len(p) < 5
            continue
        endif

        let ctype = p[1]
        let line  = p[2] + 0
        let c     = p[3] + 1
        let s     = p[4] + 0
        let str   = getline(line)

        " Hack because nimsuggest gives wrong place
        if str[c - 1] == '*'
            let c -= s
        endif

        if has_key(s:highlights, ctype)
            if has_key(semantics_set, ctype)
                call add(b:highlights, matchaddpos("Semantic" . abs(util#djb(strpart(str, c - 1, s))) % 20, [[line, c, s]]))
            else
                call add(b:highlights, matchaddpos(s:highlights[ctype], [[line, c, s]]))
            endif
        else
            echoerr "No such key: " . p[1]
        endif
    endfor

endfunction

function highlighter#New()
    let result = copy(s:NimHighlighter)
    let result.lines = []
    let result.job = jobstart([g:nvim_nim_exec_nimsuggest, '--v2', '--stdin', expand("%:p")], result)
    let result.file = expand("%:p")
    let result.tempfile = util#WriteMemfile()

    call jobsend(result.job, "highlight " . result.file . ";" . result.tempfile . ":1:1\nquit\n") 
    if !exists("b:highlights")
        let b:highlights = []
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
