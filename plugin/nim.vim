" if exists("s:loaded")
"     finish
" endif
" let s:loaded = 1

let g:nvim_nim_exec_nim        = util#CheckDependency("nim")
let g:nvim_nim_exec_nimble     = util#CheckDependency("nimble")
let g:nvim_nim_exec_nimsuggest = util#CheckDependency("nimsuggest")
let g:nvim_nim_exec_bash       = util#CheckDependency("bash")
