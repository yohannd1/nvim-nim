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
    call self.handler.run(self)
endfunction

function! suggest#New(command, useV2, handler)
    let result = copy(s:NimSuggest)
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
    let result.job = jobstart([g:nvim_nim_exec_nimsuggest, (a:useV2 ? '--v2' : ''), '--stdin', result.file], result)
    call jobsend(result.job, a:command . " " . result.file . ":" . result.line . ":" . result.col . "\nquit\n") 
    return result
endfunction
