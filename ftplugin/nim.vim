
command! NimDefinition          :call features#definition#run()
command! NimInfo                :call features#info#run()
command! NimUsages              :call features#usages#run(0)
command! NimUsagesProject       :call features#usages#run(1)
command! NimRenameSymbol        :call features#rename#run(0)
command! NimRenameSymbolProject :call features#rename#run(1)
command! NimDebug               :call features#debug#run()
command! NimOutline             :call features#outline#run()

nnoremap <buffer> <c-]> :NimDefinition<cr>
nnoremap <buffer> gd :NimDefinition<cr>
nnoremap <buffer> gt :NimInfo<cr>

autocmd! CursorHold,InsertLeave,TextChanged,InsertEnter *.nim call highlighter#guard()
autocmd! BufReadPost,BufWritePost *.nim call highlighter#guard()

call highlighter#guard()
