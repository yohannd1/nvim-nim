# nvim-nim [![Build Status](https://travis-ci.org/baabelfish/nvim-nim.svg?branch=master)](https://travis-ci.org/baabelfish/nvim-nim)
Nim support for Neovim

# TODO
- [x] Add global options for user
- [ ] Indendation

- [ ] Doc
    - [ ] Bindings
    - [ ] Options
    - [ ] Commands
    - [ ] Using with other plugins

- [ ] Syntax
    - [x] Keywords
    - [x] Operator precedence different colors
    - [x] Numbers
    - [x] String
    - [x] Highlight variable names semantically
    - [ ] Multiline comments

- [ ] File based configuration
    - [ ] Read project file
    - [ ] Create project file

- [ ] Compiler support
    - [ ] Make with nim check

- [x] Nimsuggest
    - [x] Usages
    - [x] Jump to definition
    - [x] Show typeinfo
    - [x] Outline
    - [x] Highlight

- [x] Commands
    - [x] NimDefinition
    - [x] NimOutline
    - [x] NimInfo
    - [x] NimUsages
    - [x] NimUsagesProject
    - [x] NimRenameSymbol
    - [ ] NimRenameSymbolProject

- [ ] Misc
    - [ ] Airline integration

- [ ] IDE features
    - [x] Neomake
    - [x] View online documentation
    - [x] Outline with a proper tagbar
    - [ ] Search and view online documentation
    - [ ] Usages with unite
    - [ ] Outline with unite
    - [ ] Parse proc parameter types for parameter completion
    - [ ] When lines are added or removed use cached highlighter results
    - [ ] When editing line, remove highlighter results from that line

    - [ ] Autocompletion
        - [x] Autocompletion with ycm
        - [ ] Auto complete modules
        - [ ] Snippet/documentation support after complete

    - [ ] Debugging
        - [ ] Commands
            - [ ] Run file in debug mode
            - [ ] Step into
            - [ ] Step over
            - [ ] Skip current
            - [ ] Continue
            - [ ] Ignore
            - [ ] Toggle breakpoint (insert breakpoint pragma and conceal it)

        - [ ] While on breakpoint
            - [ ] NimDebuggerEval
            - [ ] NimDebuggerEvalOutput [file]
            - [ ] NimDebuggerSetMaxdisplay
            - [ ] NimDebuggerWhere
            - [ ] NimDebuggerUp
            - [ ] NimDebuggerDown
            - [ ] NimDebuggerStackframe [file]
            - [ ] NimDebuggerCallstack
            - [ ] NimDebuggerListLocals (could be automated into a buffer)
            - [ ] NimDebuggerListGlobals (could be automated into a buffer)

        - [ ] Buffer for listing breakpoints
            - [ ] Enable and disable breakpoints

        - [ ] Watches
            - [ ] Toggle watchpoint (insert watchpoint and conceal it)
            - [ ] Watchpoint buffer with all watches and values

    - [ ] REPL
        - [ ] NimREPL
        - [ ] NimREPLEvalFile
        - [ ] NimREPLSend
        - [ ] NimREPLEvalExpression

- [ ] Utils
    - [x] Parse proc/template/method type information
    - [x] "Haskellify" typesignatures

- [ ] Add tests
    - [x] CI integration
    - [x] Test nimsuggest for surprises

    - [ ] Unit tests
        - [ ] Suggest module
            - [ ] Async
            - [ ] Sync

    - [ ] Integration tests
        - [ ] NimDefinition
        - [ ] NimOutline
        - [ ] NimInfo
        - [ ] NimUsages
        - [ ] NimUsagesProject
        - [ ] NimRenameSymbol
        - [ ] NimRenameSymbolProject


# Roadmap
## v0.1
- Everything works for single file without project dependency

## v0.2
## v0.3


# TASKS
- [x] Sync version communicating with nimsuggest
- [ ] Test dependency versions
- [ ] Add roadmap


# BUGS
- [x] Not all lines are read from stdin for some reason with job-control
