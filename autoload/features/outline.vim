if exists("s:loaded")
    finish
endif
let s:loaded = 1


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
    nnoremap <buffer><silent> <return> :call util#JumpFromQuickfix(0)<cr>
    nnoremap <buffer><silent> o :call util#JumpFromQuickfix(1)<cr>
endfunction

function! features#outline#run()
    cclose
    call setqflist([])
    call suggest#New("outline", 1, s:OutlineImpl)
endfunction
