if exists("s:loaded")
    finish
endif
let s:loaded = 1

let s:RenameImpl = {}


function! s:RenameImpl.run(data)
    if len(a:data.lines) == 1
        return
    endif

    let oldName = split(split(util#FirstNonEmpty(a:data.lines), "	")[2], "\\.")[-1]
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


function! features#rename#run(inProject)
    let s:findInProject = a:inProject
    call suggest#New("use", 1, 1, s:RenameImpl)
endfunction

