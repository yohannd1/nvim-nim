if exists("b:loaded")
    finish
endif
let b:loaded = 1


" Check dependedncies
function! s:CheckDependency(command)
    if !executable(a:command)
        echoerr "Not found: " . a:command
        finish
    endif
    return exepath(a:command)
endfunction

let s:nim = s:CheckDependency("nim")
let s:nimble = s:CheckDependency("nimble")
let s:nimsuggest = s:CheckDependency("nimsuggest")
let s:bash = s:CheckDependency("bash")
let s:findInProject = 1


" Nim highlighter
let s:NimHighlighter = {}

function! s:NimHighlighter.New()
    let result = copy(self)
    let result.lines = []
    let result.job = jobstart([s:nimsuggest, '--v2', '--stdin', expand("%:p")], result)
    let result.file = expand("%:p")
    let tempfile = result.file . ".temp"
    call writefile(getline(1, '$'), tempfile)
    call jobsend(result.job, "highlight " . result.file . ";" . tempfile . ":1:1\nquit\n") 
    if !exists("b:old_highlights")
        let b:old_highlights = []
    endif
    return result
endfunction

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


" NimSuggest
let s:NimSuggest = {}

function! s:NimSuggest.New(command, useV2, handler)
    let result = copy(self)
    let result.lines = []
    let result.file = expand("%:p")
    let result.tempfile = result.file . ".temp"
    let result.line = line(".")
    let result.col = col(".")
    let result.handler = a:handler
    " if a:useTempFile
    "     call writefile(getline(1, '$'), result.tempfile)
    " endif
    " let nimcom = completion . " " . file . (a:useTempFile ? (";" . result.tempfile) : "") . ":" . line . ":" . col

    let result.job = jobstart([s:nimsuggest, (a:useV2 ? '--v2' : ''), '--stdin', result.file], result)
    call jobsend(result.job, a:command . " " . result.file . ":" . result.line . ":" . result.col . "\n") 
    call jobsend(result.job, "quit\n") 
    return result
endfunction

function! s:NimSuggest.on_stdout(job, chunk)
    if len(a:chunk[0]) != 0 && !(a:chunk[0] =~ "^usage")
        call extend(self.lines, a:chunk)
    endif
endfunction

function! s:NimSuggest.on_stderr()
endfunction

function! s:NimSuggest.on_exit()
    call self.handler.run(self)
endfunction


function! s:JumpToLocation(file, line, col)
    if expand("%:p") != a:file
        execute ":e " . a:file
    endif
    execute ":" . a:line
    execute ":norm " . a:col . "|"
endfunction

function! s:JumpFromQuickfix(shouldReturn)
    let [file, location, _] = split(getline(line(".")), "|")
    let [l, c] = split(location, " col ")
    wincmd p
    call s:JumpToLocation(file, l, c)
    if a:shouldReturn
        wincmd p
    endif
endfunction


" Definitions
let s:DefinitionImpl = {}
function! s:DefinitionImpl.run(data)
    if len(a:data.lines) > 0
        let [_, _, _, _, filename, l, c, _] = split(a:data.lines[0], "	")
        call s:JumpToLocation(filename, l, c + 1)
    endif
endfunction
function! s:NimGoToDefinition()
    call s:NimSuggest.New("def", 0, s:DefinitionImpl)
endfunction


" Outline
let s:OutlineImpl = {}
function! s:OutlineImpl.run(data)
    for line in a:data.lines
        if len(line) == 0
            continue
        endif
        let [_, node, fullname, type, filename, line, column, doc, random] = split(line, "	")
        let name = join(split(fullname, "\\.")[1:], ".")
        call setqflist([{
                    \ 'filename': filename,
                    \ 'lnum': line,
                    \ 'col': column + 1,
                    \ 'text': node . " : " . name }],
                    \ 'a')
    endfor
    copen
    nnoremap <buffer><silent> <return> :call <SID>JumpFromQuickfix(0)<cr>
    nnoremap <buffer><silent> o :call <SID>JumpFromQuickfix(1)<cr>
endfunction
function! s:NimOutline()
    cclose
    call setqflist([])
    call s:NimSuggest.New("outline", 1, s:OutlineImpl)
endfunction


" Usage
let s:UsagesImpl = {}
function! s:UsagesImpl.run(data)
    for line in a:data.lines
        if len(line) == 0
            continue
        endif

        let [ctype, context, fullname, type, filename, line, column, doc, random] = split(line, "	")
        if !s:findInProject && filename != expand("%:p")
            continue
        endif

        let module = split(fullname, '\.')[0]
        let name = split(fullname, '\.')[-1]
        call setqflist([{
                    \ 'filename': filename,
                    \ 'lnum': line,
                    \ 'col': column + 1,
                    \ 'text': ctype . ": " . name . " (" . fullname . ")"}],
                    \ 'a')
    endfor
    copen
    nnoremap <buffer><silent> <return> :call <SID>JumpFromQuickfix(0)<cr>
    nnoremap <buffer><silent> o :call <SID>JumpFromQuickfix(1)<cr>
endfunction
function! s:NimUsages(findInProject)
    cclose
    call setqflist([])
    let s:findInProject = a:findInProject
    call s:NimSuggest.New("use", 1, s:UsagesImpl)
endfunction


function! s:FirstNonEmpty(lines)
    for line in a:lines
        if len(line) > 0
            return line
        endif
    endfor
endfunction


let s:RenameImpl = {}
function! s:RenameImpl.run(data)
    if len(a:data.lines) == 0
        return
    endif

    let oldName = split(split(s:FirstNonEmpty(a:data.lines), "	")[2], "\\.")[-1]
    let newName = input("Rename symbol: ", oldName)

    for line in a:data.lines
        if len(line) == 0
            continue
        endif

        let [_, _, _, _, filename, line, column, _, _] = split(line, "	")
        if !s:findInProject && filename != expand("%:p")
            continue
        endif

        if filename != expand("%:p")
            execute ":e " . expand("%:p")
        endif

        let left = getline(line)[0:column - 1]
        let right = getline(line)[column + len(oldName):-1]
        call setline(line, left . newName . right)
    endfor
endfunction
function! s:NimRenameSymbol(inProject)
    let s:findInProject = a:inProject
    call s:NimSuggest.New("use", 1, s:RenameImpl)
endfunction


" Info
let s:InfoImpl = {}
function! s:InfoImpl.run(data)
    if len(a:data.lines) == 0
        echo "No information found"
    else
        let [_, ctype, name, type, filename, l, c, doc] = split(a:data.lines[0], "	")
        echohl Function | echon "Type"
        echohl Comment | echon ": "
        echohl Statement | echon type
    endif
endfunction
function! s:NimInfo()
    call s:NimSuggest.New("def", 0, s:InfoImpl)
endfunction


" Config
function! s:NimDebug()
    echo "Nim tools debugging info"
    echo "------------------------"
    echo "\n"
    echo "-------- Tools ---------"
    echo "Nim:        " . s:nim
    echo "Nimble:     " . s:nimble
    echo "Nimsuggest: " . s:nimsuggest
endfunction

command! NimDefinition          :call s:NimGoToDefinition()
command! NimInfo                :call s:NimInfo()
command! NimUsages              :call s:NimUsages(0)
command! NimUsagesProject       :call s:NimUsages(1)
command! NimOutline             :call s:NimOutline()
command! NimRenameSymbol        :call s:NimRenameSymbol(0)
command! NimRenameSymbolProject :call s:NimRenameSymbol(1)
command! NimDebug               :call s:NimDebug()

function! s:hlGuard()
    if line("$") + 0 < 500
        call s:NimHighlighter.New()
    endif
endfunction

autocmd! CursorHold,InsertLeave,TextChanged,InsertEnter *.nim call s:hlGuard()
autocmd! BufReadPost,BufWritePost *.nim call s:hlGuard()
