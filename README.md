# nvim-nim [![Build Status](https://travis-ci.org/baabelfish/nvim-nim.svg?branch=master)](https://travis-ci.org/baabelfish/nvim-nim)
Nim support for vim and advanced support for neovim.

DON'T INSTALL YET, STILL UNDER VERY HEAVY DEVELOPMENT.

## Features
- Syntax highlighting
    - Normal vim highlight
    - More intelligent highlight with nimsuggest
    - Semantic highlighting for specified nim symbol kinds
- Indentation
- Error checking
    - Using ``:make``
    - Neomake
- Project navigation with nimsuggest
    - Jump to definition
    - Get symbol information (type, module, file, signature, etc...)
    - Find usages (file and/or project)
- Autocompletion
    - Nimsuggest autocompletion
    - Autocomplete module names
- IDE like stuff
    - Outline listing all symbols in the module (like tagbar)
    - Jump to documentation in web
    - Refactoring
        - Rename symbol in file or project
- REPL
    - Open repl
    - Send current buffer
    - Send selection

![something](https://raw.githubusercontent.com/baabelfish/nvim-nim/master/other/pic1.png)


## Planned features
- Debugger support
- All features will work asynchronously
