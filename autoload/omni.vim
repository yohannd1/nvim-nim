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
                " \ 'kind': a:parsed.kindshort . " » " . a:parsed.type,
endfunction

function! omni#nim(findstart, base)
    if a:findstart && empty(a:base)
        return col('.')
    else

    let file = expand("%:p")
    let tempfile = util#WriteMemfile()
    let l = line(".")
    let c = col(".")

    let query = "sug " . file . ";" . tempfile . ":" . l . ":" . c
    let jobcmdstr = g:nvim_nim_exec_nimsuggest . " --v2 --stdin " . file
    let fullcmd = 'echo -e ' . shellescape(query, 1) . '|' . jobcmdstr
    let completions_raw = split(system(fullcmd), "\n")[4:-2]
    let completions = []

    for line in completions_raw
        call add(completions, omni#item(util#ParseV2(line)))
    endfor

    return {
                \ 'words': completions,
                \ 'refresh': 'always' }
endfunction
