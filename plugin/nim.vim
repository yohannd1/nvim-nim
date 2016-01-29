if exists("b:loaded")
  " finish
else
    function! s:NimsuggestProxy(id, data, event)
        call s:HandleNimsuggestProxy(a:id, a:data, a:event)
    endfunction
endif
let b:loaded = 1
let b:hmatches = []

function! s:HandleNimsuggestProxy(id, data, event)
    if a:event == 'stdout'
        if len(a:data[0]) == 0
        elseif !(a:data[0] =~ "^usage")
            call s:HandleNimsuggest(a:data, s:type)
        endif
    elseif a:event == 'exit'
        if s:type == 'highlight'
            for m in b:hmatches
                call matchdelete(m)
            endfor
            let b:hmatches = []
        endif
    endif
endfunction

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
let s:nimserver = 0
let s:type = ''
let s:findInProject = 1

function! s:JumpToLocation(file, line, col)
    execute ":e " . a:file
    execute ":" . a:line
    execute ":norm " . a:col . "|"
endfunction

function! s:JumpFromQuickfix()
    let [file, location, _] = split(getline(line(".")), "|")
    let [l, c] = split(location, " col ")
    wincmd p
    call s:JumpToLocation(file, l, c)
endfunction

function! s:HandleNimsuggest(data, type)
    if a:type == 'outline'
        for entry in a:data
            if len(entry) == 0
                continue
            endif

            let [_, node, fullname, type, filename, line, column, doc, random] = split(entry, "	")
            let name = join(split(fullname, "\\.")[1:], ".")
            call setqflist([{
                        \ 'filename': filename,
                        \ 'lnum': line,
                        \ 'col': column + 1,
                        \ 'text': node . " : " . name }],
                        \ 'a')
        endfor
        copen
        nnoremap <buffer><silent> <return> :call <SID>JumpFromQuickfix()<cr>

    elseif a:type == 'highlight'
        let highlights = {
                    \ 'skAlias':        ["Type", []],
                    \ 'skConditional':  ["Conditional", []],
                    \ 'skConst':        ["Constant", []],
                    \ 'skConverter':    ["Function", []],
                    \ 'skDynLib':       ["Include", []],
                    \ 'skEnumField':    ["Identifier", []],
                    \ 'skField':        ["Identifier", []],
                    \ 'skForVar':       ["Special", []],
                    \ 'skGenericParam': ["Typedef", []],
                    \ 'skGlobalVar':    ["Constant", []],
                    \ 'skGlobalLet':    ["Constant", []],
                    \ 'skIterator':     ["Keyword", []],
                    \ 'skLabel':        ["Identifier", []],
                    \ 'skLet':          ["Constant", []],
                    \ 'skMacro':        ["Macro", []],
                    \ 'skMethod':       ["Function", []],
                    \ 'skModule':       ["Include", []],
                    \ 'skPackage':      ["Define", []],
                    \ 'skParam':        ["Identifier", []],
                    \ 'skProc':         ["Function", []],
                    \ 'skResult':       ["Keyword", []],
                    \ 'skStub':         ["PreCondit", []],
                    \ 'skTemp':         ["Identifier", []],
                    \ 'skTemplate':     ["PreProc", []],
                    \ 'skType':         ["Type", []],
                    \ 'skUnknown':      ["Error", []],
                    \ 'skVar':          ["Constant", []]
                    \ }

        for line in a:data
            if len(line) == 0
                continue
            endif
            " let [_, type, line, column, size] = split(line, "	")
            let p = split(line, "	")
            call add(highlights[p[1]][1], [p[2] + 0, p[3] + 1, p[4] + 0])
        endfor

        for [k, v] in items(highlights)
            call add(b:hmatches, matchaddpos(v[0], v[1]))
        endfor

    elseif a:type == 'info'
        let [_, ctype, name, type, filename, l, c, doc] = split(a:data[0], "	")
        if type != ""
            echo "Type: " . type
        else
            echo "No information found"
        endif

    elseif a:type == 'def'
        let [_, _, _, _, filename, l, c, _] = split(a:data[0], "	")
        call s:JumpToLocation(filename, l, c + 1)

    elseif a:type == 'use'
        for entry in a:data
            if len(entry) == 0
                continue
            endif

            let [ctype, context, fullname, type, filename, line, column, doc, random] = split(entry, "	")
            if !s:findInProject && filename != expand("%")
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
        nnoremap <buffer><silent> <return> :call <SID>JumpFromQuickfix()<cr>

    else
        echoerr "No support for " . a:type
    endif
endfunction

function! s:Cleanup()
endfunction

" Internal implementation
function! s:AskNimsuggest(command, useV2, useTempFile)
    let s:result = []
    let file = expand("%:p")
    let tempfile = file . ".temp"
    let line = line(".")
    let col = col(".")

    let completion = a:command
    if completion == "info"
        let completion = "def"
    endif

    if a:useTempFile
        call writefile(getline(1, '$'), tempfile)
    endif

    let nimcom = completion . " " . file . (a:useTempFile ? (";" . tempfile) : "") . ":" . line . ":" . col
    let s:type = a:command

    call s:NimStartServer(a:useV2, file)
    call jobsend(s:nimserver, nimcom . "\n") 
endfunction

" Public API
function! s:NotImplementedYet()
  echo "Not implemented yet"
endfunction

function! s:NimJumpToDefinition()
    call s:AskNimsuggest("def", 0, 0)
endfunction

function! s:NimOutline()
    cclose
    call setqflist([])
    call s:AskNimsuggest("outline", 1, 0)
endfunction

function! s:NimUsages(findInProject)
    cclose
    call setqflist([])
    let s:findInProject = a:findInProject
    call s:AskNimsuggest("use", 1, 0)
endfunction

function! s:NimRenameSymbol()
    call s:NotImplementedYet()
endfunction

function! s:NimRenameSymbolProject()
    call s:NotImplementedYet()
endfunction

function! s:NimStartServer(useV2, file)
    if s:nimserver > 0
        call s:NimStopServer()
    endif

    let s:nimserver = jobstart([s:nimsuggest, (a:useV2 ? '--v2' : ''), '--stdin', a:file], {
                \ 'on_stdout': 's:NimsuggestProxy',
                \ 'on_stderr': 's:NimsuggestProxy',
                \ 'on_exit': 's:NimsuggestProxy'
                \ })
endfunction

function! s:NimStatusServer()
    if s:nimserver <= 0
        echo "No nimsuggest server running"
    else
        echo "Nimsuggest running with id: " . s:nimserver
    endif
endfunction

function! s:NimStopServer()
    if s:nimserver > 0
        call jobstop(s:nimserver)
        let s:nimserver = 0
    endif
endfunction

function! s:NimInfo()
    call s:AskNimsuggest("info", 0, 0)
endfunction

function! s:NimDebug()
    echo "Nim tools debugging info"
    echo "------------------------"
    echo "\n"
    echo "-------- Tools ---------"
    echo "Nim:        " . s:nim
    echo "Nimble:     " . s:nimble
    echo "Nimsuggest: " . s:nimsuggest
endfunction

command! NimDefinition          :call s:NimJumpToDefinition()
command! NimInfo                :call s:NimInfo()
command! NimUsages              :call s:NimUsages(0)
command! NimUsagesProject       :call s:NimUsages(1)
command! NimOutline             :call s:NimOutline()
command! NimServerStart         :call s:NimStartServer()
command! NimServerStop          :call s:NimStopServer()
command! NimRenameSymbol        :call s:NimRenameSymbol()
command! NimRenameSymbolProject :call s:NimRenameSymbolProject()
command! NimDebug               :call s:NimDebug()

function! s:HighlightSyntax(useTempFile)
    call s:AskNimsuggest("highlight", 1, a:useTempFile)
endfunction

autocmd! InsertLeave,CursorHold,CursorHoldI,TextChanged,InsertEnter *.nim call s:HighlightSyntax(1)
autocmd! BufReadPost,BufWritePost *.nim call s:HighlightSyntax(0)
