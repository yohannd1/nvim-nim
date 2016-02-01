if exists("s:loaded")
    finish
endif
let s:loaded = 1


let s:findInProject = 1
let s:NimSuggestServer = {}
function! s:NimSuggestServer.on_stdout(job, chunk)
    " echoerr join(a:chunk, "\n")
endfunction
function! s:NimSuggestServer.on_stderr(job, chunk)
    " echoerr join(a:chunk, "\n")
endfunction
function! s:NimSuggestServer.on_exit()
    " call jobstop(self.job_server)
endfunction



" NimSuggest
let s:NimSuggest = {}

function! s:NimSuggest.on_stdout(job, chunk)
    call extend(self.lines, a:chunk)
endfunction

function! s:NimSuggest.on_stderr(job, chunk)
endfunction

function! s:NimSuggest.on_exit()
    if self.isAsync
        let self.lines = self.lines[5:-1]
    else
        let self.lines = self.lines[4:-1]
    endif

    if len(self.lines) > 0
        call self.handler.run(self)
    else
        echo ""
    endif
endfunction

function! suggest#NewKnown(command, sync, useV2, file, line, col, handler)
    let result = copy(s:NimSuggest)
    let result.lines = []
    let result.file = a:file
    let result.tempfile = result.file . ".temp"
    let result.line = a:line
    let result.col = a:col
    let result.handler = a:handler
    let result.isAsync = has("nvim") && !a:sync && g:nvim_nim_enable_async

    " if a:useTempFile
    "     call writefile(getline(1, '$'), result.tempfile)
    " endif
    " let nimcom = completion . " " . file . (a:useTempFile ? (";" . result.tempfile) : "") . ":" . line . ":" . col

    let query = a:command . " " . result.file . ":" . result.line . ":" . result.col

    if !result.isAsync
        let jobcmdstr = g:nvim_nim_exec_nimsuggest . " " . (a:useV2 ? '--v2' : '') . " " . '--stdin' . " " . result.file
        let fullcmd = 'echo -e ' . shellescape(query, 1) . '|' . jobcmdstr
        let result.lines = split(system(fullcmd), "\n")[4:-2]
        call a:handler.run(result)
    else
        call util#StartQuery()
        let result.job_server = jobstart([g:nvim_nim_exec_nimsuggest, '--port:5999', '--address:localhost', (a:useV2 ? '--v2' : ''), result.file], s:NimSuggestServer)
        if result.job_server < 1
            echoerr "Unable to start server"
        else
            " FIXME: Telnet is not possibly the best way to communicate :S
            let result.job_suggest = jobstart(['telnet', 'localhost', '5999'], result)
            call jobsend(result.job_suggest, query . "\n")
        endif
    endif
    return result
endfunction


function! suggest#New(command, sync, useV2, handler)
    return suggest#NewKnown(a:command, a:sync, a:useV2, expand("%:p"), line("."), col("."), a:handler)
endfunction
