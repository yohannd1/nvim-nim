if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:highlights = -1

let s:UsagesImpl = {}
function! s:UsagesImpl.run(data)
    if s:highlights >= 0
        call matchdelete(s:highlights)
    end
    let s:highlights = -1
    let highlights = []

    if len(a:data.lines) < 1
        echohl Comment | echo "No usages found"
    else
        for line in a:data.lines
            if len(line) == 0
                continue
            endif

            let res = util#ParseV2(line)
            if !s:findInProject && res.file != expand("%:p")
                continue
            endif

            call setqflist([{
                        \ 'filename': res.file,
                        \ 'lnum': res.line,
                        \ 'col': res.col + 1,
                        \ 'text': res.ctype . ": " . res.name . " (" . res.location . ")"}],
                        \ 'a')
            " call add(highlights, [line, column + 1, len(name)])
        endfor

        " let s:highlights = matchaddpos("Search", highlights)

        copen
        nnoremap <buffer><silent> <return> :call util#JumpFromQuickfix(0)<cr>
        nnoremap <buffer><silent> o :call util#JumpFromQuickfix(1)<cr>
    endif
endfunction

let s:UsagesDefinitionImpl = {}
function! s:UsagesDefinitionImpl.run(data)
    " let res = util#ParseV1(a:data.lines[0])
    " call suggest#NewKnown("use", 1, res.file, res.line, res.col + 1, s:UsagesImpl)
    call suggest#New("use", 1, 1, s:UsagesImpl)
endfunction

function! features#usages#run(findInProject)
    cclose
    call setqflist([])
    let s:findInProject = a:findInProject
    call suggest#New("def", 1, 0, s:UsagesDefinitionImpl)
endfunction

