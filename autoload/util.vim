if exists("s:loaded")
    finish
endif
let s:loaded = 1


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
    execute ":norm " . (a:col - 1) . "|"
endfunction


function! util#JumpFromQuickfix(shouldReturn)
    let [file, location, _] = split(getline(line(".")), "|")
    let [l, c] = split(location, " col ")
    wincmd p
    call s:JumpToLocation(file, l, c)
    if a:shouldReturn
        wincmd p
    endif
endfunction
