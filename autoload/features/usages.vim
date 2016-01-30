if exists("s:loaded")
    finish
endif
let s:loaded = 1


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
    nnoremap <buffer><silent> <return> :call util#JumpFromQuickfix(0)<cr>
    nnoremap <buffer><silent> o :call util#JumpFromQuickfix(1)<cr>
endfunction


function! features#usages#run(findInProject)
    cclose
    call setqflist([])
    let s:findInProject = a:findInProject
    call suggest#New("use", 1, s:UsagesImpl)
endfunction



