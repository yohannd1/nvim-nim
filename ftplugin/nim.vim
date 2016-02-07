if exists("b:loaded")
    finish
endif
let b:loaded = 1

setlocal iskeyword=a-z,A-Z,48-57,128-255,_
setlocal formatoptions-=t formatoptions+=l
setlocal comments=s1:#[,mb:#,ex:]#,:#,:##
setlocal commentstring=#\ %s
setlocal expandtab
setlocal omnifunc=omni#nim
setlocal makeprg=nim\ c\ --compileOnly\ --verbosity:0\ --colors:off\ %
setlocal errorformat=
            \%-GHint:\ %m,
            \%A%f(%l\\,\ %c)\ Hint:\ %m,
            \%E%f(%l\\,\ %c)\ Error:\ %m,
            \%W%f(%l\\,\ %c)\ Warning:\ %m

command! NimDefinition          :call features#definition#run()
command! NimInfo                :call features#info#run()
command! NimWeb                 :call features#info#web()
command! NimUsages              :call features#usages#run(0)
command! NimUsagesProject       :call features#usages#run(1)
command! NimRenameSymbol        :call features#rename#run(0)
command! NimRenameSymbolProject :call features#rename#run(1)
command! NimDebug               :call features#debug#run()
command! NimOutline             :call features#outline#run(0)

command! NimEdb                 :call features#debugger#run()
command! NimEdbStop             :call features#debugger#stop()
command! NimEdbContinue         :call features#debugger#continue()
command! NimEdbStepInto         :call features#debugger#stepinto()
command! NimEdbStepOver         :call features#debugger#stepover()
command! NimEdbSkipCurrent      :call features#debugger#skipcurrent()
command! NimEdbIgonore          :call features#debugger#ignore()
command! NimEdbContinue         :call features#debugger#continue()
command! NimEdbToggleBP         :call features#debugger#togglebp()

command! NimREPL                :call features#repl#start()
command! NimREPLEvalFile        :call features#repl#send(getline(0, line("$")))
command! -range NimREPLEval     :call features#repl#send(getline(getpos("'<")[1], getpos("'>")[1]))

nnoremap <buffer> <c-]> :NimDefinition<cr>
nnoremap <buffer> gd    :NimDefinition<cr>
nnoremap <buffer> gt    :NimInfo<cr>
nnoremap <buffer> gT    :NimWeb<cr>

onoremap <silent>af :<C-U>call util#SelectNimProc(0)<CR>
onoremap <silent>if :<C-U>call util#SelectNimProc(1)<CR>
vnoremap <silent>af :<C-U>call util#SelectNimProc(0)<CR><Esc>gv
vnoremap <silent>if :<C-U>call util#SelectNimProc(1)<CR><Esc>gv

autocmd! BufReadPost,BufWritePost,CursorHold,InsertLeave,TextChanged,InsertEnter *.nim call highlighter#guard()
autocmd! BufWinEnter,BufWritePost,FileWritePost *.nim call features#outline#run(1)
autocmd! VimResized,WinEnter * call features#outline#render()
call highlighter#guard()
