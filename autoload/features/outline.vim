if exists("s:loaded")
    finish
endif
let s:loaded = 1

function! features#outline#renderable(parsed)
    return {
                \ 'line': a:parsed.line,
                \ 'col': a:parsed.col,
                \ 'name': a:parsed.lname,
                \ 'kind': a:parsed.kind }
endfunction

let s:window = -1
let s:goto_table = {}
let s:groups = {}
let s:group_order = ["Types", "Callables", "Constants", "Globals", "Imports"]
let s:symbols = {
            \ 'skProc':         "proc",
            \ 'skTemplate':     "template",
            \ 'skType':         "",
            \ 'skMacro':        "macro",
            \ 'skMethod':       "function",
            \ 'skField':        "field",
            \ 'skAlias':        "alias",
            \ 'skConst':        "constant",
            \ 'skConverter':    "converter",
            \ 'skDynLib':       "dynlib",
            \ 'skEnumField':    "enum",
            \ 'skGlobalVar':    "var",
            \ 'skGlobalLet':    "let",
            \ 'skIterator':     "iterator",
            \ 'skLabel':        "label",
            \ 'skLet':          "constant",
            \ 'skModule':       "module",
            \ 'skPackage':      "package",
            \ }

            " \ 'skField':     "Fields",
let s:group_aliases = {
            \ 'skType':      "Types",
            \ 'skProc':      "Callables",
            \ 'skTemplate':  "Callables",
            \ 'skMacro':     "Callables",
            \ 'skMethod':    "Callables",
            \ 'skConverter': "Callables",
            \ 'skIterator':  "Callables",
            \ 'skConst':     "Constants",
            \ 'skLet':       "Constants",
            \ 'skGlobalVar': "Globals",
            \ 'skGlobalLet': "Globals",
            \ 'skDynLib':    "Imports",
            \ 'skModule':    "Imports",
            \ 'skPackage':   "Imports",
            \ }

function! s:CreateSymbolRow(symbol)
    let result = " » " . a:symbol.name
    if len(s:symbols[a:symbol.kind]) > 0
        let result .= " (" . s:symbols[a:symbol.kind] . ")"
    endif
    return result
endfunction

function! s:ConfigureOutlineBuffer()
    if s:IsOpen()
        return
    endif

    let s:window = winnr()
    vsplit __nim_outline__
    setlocal filetype=nimoutline
    setlocal buftype=nofile
    setlocal nonumber
    setlocal nowrap
    exec "silent vertical resize " . g:nvim_nim_outline_buffer_width
    setlocal wfw
    nnoremap <buffer><silent> <return> :call features#outline#JumpToSymbol(0)<cr>
    nnoremap <buffer><silent> o        :call features#outline#JumpToSymbol(1)<cr>
endfunction

function! features#outline#JumpToSymbol(stay)
    if !s:IsFocused()
        return
    endif

    let l = line(".")
    if !has_key(s:goto_table, l)
        return
    endif

    let [jl, jc] = s:goto_table[l]
    call util#JumpToWindow(s:window, jl, jc)
    normal! ^

    if a:stay
        normal! zt
        wincmd p
    endif
endfunction

function! s:UpdateOutline(groups)
    let s:goto_table = {}
    let s:groups = a:groups
    call s:ConfigureOutlineBuffer()
    call s:RenderOutline()
endfunction

function! s:RenderOutline()
    let wasFocused = s:IsFocused()

    call s:Focus()
    if !s:IsFocused()
        return
    endif

    exec "silent vertical resize " . g:nvim_nim_outline_buffer_width

    let rlines = []

    for groupname in s:group_order
        if len(s:groups[groupname]) == 0
            continue
        endif

        call add(rlines, groupname)

        for symbol in s:groups[groupname]
            let s:goto_table[len(rlines) + 1] = [symbol.line, symbol.col]
            call add(rlines, s:CreateSymbolRow(symbol))
        endfor
        call add(rlines, "")
    endfor

    let idx = 1
    for line in rlines
        call setline(idx, line)
        let idx += 1
    endfor

    exec ":" . len(rlines)
    normal! dG
    if !wasFocused
        wincmd p
    endif
endfunction

function! s:Window()
    return bufwinnr("__nim_outline__")
endfunction

function! s:IsOpen()
    return s:Window() != -1
endfunction

function! s:IsFocused()
    return s:IsOpen() && s:Window() == winnr()
endfunction

function! s:Focus()
    if s:IsOpen()
        exec ":" . s:Window() . "wincmd w"
    endif
endfunction

function! features#outline#render()
    call s:RenderOutline()
endfunction

let s:OutlineImpl = {}
function! s:OutlineImpl.run(data)
    let s:groups = {
                \ "Types":     [],
                \ "Callables": [],
                \ "Fields":    [],
                \ "Constants": [],
                \ "Globals":   [],
                \ "Imports":   [],
                \ }

    for line in a:data.lines
        let p = util#ParseV2(line)
        if has_key(s:group_aliases, p.kind)
            let renderable = features#outline#renderable(p)
            call add(s:groups[s:group_aliases[p.kind]], renderable)
        endif
    endfor

    call s:UpdateOutline(s:groups)
endfunction

function! features#outline#run(isUpdating)
    if !a:isUpdating || s:IsOpen()
        call suggest#New("outline", 0, 1, s:OutlineImpl)
    endif
endfunction

