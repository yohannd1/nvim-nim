if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:findInProject = 1

" NimSuggest
let s:NimSuggest = {}

function! s:NimSuggest.on_stdout(job, chunk)
    if len(a:chunk[0]) != 0 && !(a:chunk[0] =~ "^usage")
        call extend(self.lines, a:chunk)
    endif
endfunction

function! s:NimSuggest.on_stderr()
endfunction

function! s:NimSuggest.on_exit()
    if len(self.lines) > 0
        call self.handler.run(self)
    else
        " Clear cli
        echo "" 
    endif
endfunction

function! suggest#NewKnown(command, useV2, file, line, col, handler)
    let result = copy(s:NimSuggest)
    let result.lines = []
    let result.file = a:file
    let result.tempfile = result.file . ".temp"
    let result.line = a:line
    let result.col = a:col
    let result.handler = a:handler
    " if a:useTempFile
    "     call writefile(getline(1, '$'), result.tempfile)
    " endif
    " let nimcom = completion . " " . file . (a:useTempFile ? (";" . result.tempfile) : "") . ":" . line . ":" . col

    let jobcmd = [g:nvim_nim_exec_nimsuggest, (a:useV2 ? '--v2' : ''), '--stdin', result.file]
    let jobcmdstr = g:nvim_nim_exec_nimsuggest . " " . (a:useV2 ? '--v2' : '') . " " . '--stdin' . " " . result.file
    let jobstdin = a:command . " " . result.file . ":" . result.line . ":" . result.col

    if !g:nvim_nim_enable_async || !has("nvim")
        let fullcmd = 'echo -e ' . shellescape(jobstdin, 1) . '|' . jobcmdstr
        let result.lines = split(system(fullcmd), "\n")[4:-2]
        call a:handler.run(result)
    else
        call util#StartQuery()
        let result.job = jobstart([g:nvim_nim_exec_nimsuggest, (a:useV2 ? '--v2' : ''), '--stdin', result.file], result)
        call jobsend(result.job, jobcmd)
    endif
    return result
endfunction


function! suggest#New(command, useV2, handler)
    return suggest#NewKnown(a:command, a:useV2, expand("%:p"), line("."), col("."), a:handler)
endfunction
