" if exists("b:loaded")
"     finish
" endif
let b:loaded = 1

setlocal formatoptions-=t formatoptions+=l
setlocal comments=s1:#[,mb:#,ex:]#,:#
setlocal commentstring=#\ %s
setlocal expandtab
setlocal omnifunc=omni#nim

command! NimDefinition          :call features#definition#run()
command! NimInfo                :call features#info#run()
command! NimUsages              :call features#usages#run(0)
command! NimUsagesProject       :call features#usages#run(1)
command! NimRenameSymbol        :call features#rename#run(0)
command! NimRenameSymbolProject :call features#rename#run(1)
command! NimDebug               :call features#debug#run()
command! NimOutline             :call features#outline#run()

command! NimEdb             :call features#debugger#run()
command! NimEdbStop         :call features#debugger#stop()
command! NimEdbContinue     :call features#debugger#continue()
command! NimEdbStepInto     :call features#debugger#stepinto()
command! NimEdbStepOver     :call features#debugger#stepover()
command! NimEdbSkipCurrent  :call features#debugger#skipcurrent()
command! NimEdbIgonore      :call features#debugger#ignore()
command! NimEdbContinue     :call features#debugger#continue()
command! NimEdbToggleBP     :call features#debugger#togglebp()

nnoremap <buffer> <c-]> :NimDefinition<cr>
nnoremap <buffer> gd :NimDefinition<cr>
nnoremap <buffer> gt :NimInfo<cr>
nnoremap <buffer> gT :NimInfoVerbose<cr>

autocmd! CursorHold,InsertLeave,TextChanged,InsertEnter *.nim call highlighter#guard()
autocmd! BufReadPost,BufWritePost *.nim call highlighter#guard()
" autocmd! BufWinEnter quickfix let g:qfix_win = bufnr("$")
" autocmd! BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | call features#usages#clear_matches() | unlet! g:qfix_win | endif

call highlighter#guard()
