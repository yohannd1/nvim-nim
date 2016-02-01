# nvim-nim [![Build Status](https://travis-ci.org/baabelfish/nvim-nim.svg?branch=master)](https://travis-ci.org/baabelfish/nvim-nim)
Nim support for Neovim

# TODO
- [x] Add global options for user
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
    - [ ] Multiline comments
    - [ ] Highlight variable names semantically
- [ ] Indendation
- [ ] Compiler support
    - [x] Omnicomplete
    - [ ] Make for errors
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
- [ ] IDE features
    - [x] Neomake
    - [x] Autocompletion with ycm
    - [ ] Search and view online documentation
    - [ ] Usages with unite
    - [ ] Outline with unite
    - [ ] Outline with a proper tagbar
    - [ ] Auto complete modules
    - [ ] Parse proc parameter types for parameter completion
    - [ ] REPL interaction
    - [ ] Airline integration
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


# TASKS
- [x] Sync version communicating with nimsuggest
- [ ] Test dependency versions
- [ ] Add roadmap


# BUGS
- [x] Not all lines are read from stdin for some reason with job-control
