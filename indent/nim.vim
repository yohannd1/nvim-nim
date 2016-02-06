" if exists("b:loaded")
"   finish
" endif
" let b:loaded = 1

setlocal nolisp
setlocal autoindent
setlocal indentkeys=!^F,o,O,<:>,0),0],0},=elif
setlocal indentexpr=NimIndent()

function! Down()
    return indent(prevnonblank(v:lnum - 1)) - &tabstop
endfunction

function! Up()
    return (indent(prevnonblank(v:lnum - 1)) + &tabstop)
endfunction

function! NimIndent()
    let line = getline(v:lnum)
    let prev = prevnonblank(v:lnum - 1)
    let prevempty = getline(v:lnum - 1) =~ '^\s*$'
    let prev2empty = getline(v:lnum - 2) =~ '^\s*$'
    let prevl = getline(prev)

    if prev2empty && prevempty
        return
    endif

    if prevl =~ '\([:=\[({]\|and\|or\|not\|xor\|shl\|shr\|div\|mod\|in\|notin\|is\|isnot\|of\)\s*$'
        return Up()
    endif

    if prevl =~ '\s*\(import\|type\)'
        return Up()
    endif

    if prevl =~ '\s*\(const\|var\|let\)\s*$'
        return Up()
    endif

    if prevl =~ '\(object\|enum\|object\|concept\|tuple\)\s*$'
        return Up()
    endif

    if prevl =~ '^\(const\|var\|let\).*\s*if\s*.*$'
        return Up()
    endif

    if prevl =~ ',\s*$'
        return -1
    endif

    if prevempty && prevl =~ '\s*\(result\|return\|break\|continue\|raise\)'
        return Down()
    endif

    " if prevl =~ '[\])}]\s*$'
    "     return Down()
    " endif

    return -1
endfunction
