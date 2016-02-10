scriptencoding utf-8


if exists("s:loaded")
    finish
endif
let s:loaded = 1

function! omni#item(parsed)
    return {
                \ 'word': a:parsed.lname,
                \ 'kind': a:parsed.kindshort . " » " . util#SignatureStr(a:parsed.type),
                \ 'info': a:parsed.doc,
                \ 'menu': a:parsed.module,
                \ }
endfunction

function! omni#item_module(name, file, type)
    return {
                \ 'word': a:name,
                \ 'kind': a:type,
                \ 'info': a:file,
                \ 'menu': "module",
                \ }
endfunction

function! omni#nimsuggest(file, l, c)
    let completions = []
    let tempfile = util#WriteMemfile()

    let query = "sug " . a:file . ";" . tempfile . ":" . a:l . ":" . a:c
    let jobcmdstr = g:nvim_nim_exec_nimsuggest . " --v2 --stdin " . a:file
    let fullcmd = 'echo -e ' . shellescape(query, 1) . '|' . jobcmdstr
    let completions_raw = util#FilterCompletions(split(system(fullcmd), "\n"))

    for line in completions_raw
        call add(completions, omni#item(util#ParseV2(line)))
    endfor

    return completions
endfunction

function! omni#modulesuggest(file, l, c)
    let modules = modules#FindGlobalImports()
    let completions = []
    for module in sort(keys(modules))
        call add(completions, omni#item_module(module, modules[module], "G"))
    endfor
    return completions
endfunction

function! omni#nim(findstart, base)
    if a:findstart && empty(a:base)
        return col('.')
    endif

    let completions = []
    let file = expand("%:p")
    let l = line(".")
    let c = col(".")

    let [istart, iend] = modules#ImportLineRange()
    if istart != 0 && istart <= l && l < iend
        let completions = omni#modulesuggest(file, l, c)
    else
        let completions = omni#nimsuggest(file, l, c)
    endif

    return {
                \ 'words': completions,
                \ 'refresh': 'always' }
endfunction
