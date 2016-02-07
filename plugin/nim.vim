if exists("s:loaded")
    finish
endif
let s:loaded = 1


function! CheckDependency(command)
    if !executable(a:command)
        echoerr "Not found: " . a:command
        finish
    endif
    return exepath(a:command)
endfunction


" FIXME
function! FindNimbleModulesPath()
    return "~/.nimble/pkgs/"
endfunction


" FIXME
function! FindNimModulesPath()
    return "/usr/lib/nim/"
endfunction


let g:nvim_nim_exec_nim        = CheckDependency("nim")
let g:nvim_nim_exec_nimble     = CheckDependency("nimble")
let g:nvim_nim_exec_nimsuggest = CheckDependency("nimsuggest")
let g:nvim_nim_exec_bash       = CheckDependency("bash")
let g:nvim_nim_deps_nim        = FindNimModulesPath()
let g:nvim_nim_deps_nimble     = FindNimbleModulesPath()

let g:nvim_nim_highlighter_enable     = 1

let g:nvim_nim_highlighter_enable     = 1
let g:nvim_nim_highlighter_semantic   = 1
let g:nvim_nim_enable_async           = 1
let g:nvim_nim_highlight_builtin      = 1
let g:nvim_nim_highlight_use_unite    = 0

let g:nvim_nim_outline_buffer         = 1
let g:nvim_nim_outline_buffer_width   = 30

let g:nvim_nim_highlighter_semantics  = ["skConst", "skForVar", "skGlobalVar", "skGlobalLet", "skLet", "skModule", "skParam", "skTemp", "skVar"]
