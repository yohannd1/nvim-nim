# nvim-nim [![Build Status](https://travis-ci.org/baabelfish/nvim-nim.svg?branch=master)](https://travis-ci.org/baabelfish/nvim-nim)
Nim support for vim and advanced support for neovim. Still in heavy development.


## Features

- Asynchronous
- Syntax highlighting
    - Normal vim highlight
    - More intelligent highlight with nimsuggest (**experimental**)
    - Semantic highlighting for specified nim symbol kinds (**experimental**)
- Indentation
- Error checking
    - Using ``:make``
    - [Neomake](https://github.com/benekastah/neomake)
- Project navigation with nimsuggest
    - Jump to definition
    - Get symbol information (type, module, file, signature, etc...)
    - Find usages (file and/or project)
- Autocompletion
    - Nimsuggest omnicompletion (still *sync*, deoplete/ycm incoming...)
    - Autocomplete module names (**experimental**)
- IDE like stuff
    - Jump to documentation in web
    - Refactoring
        - Rename symbol in file or project
    - Outline listing all symbols in the module (like tagbar)
        - Jump to outline symbol with unite (**experimental**)
- REPL (**experimental**)
    - Open repl
    - Send current buffer
    - Send selection


## Dependencies
- Neovim (tested with 1.2)
- Vim (TODO)
- Optional: [vim-operator-user](https://github.com/kana/vim-operator-user) for defining routine text object


## Screenshots

![Syntax highlighting](https://raw.githubusercontent.com/baabelfish/nvim-nim/master/misc/screenshots/syntaxhl.png)
![Autocomplete](https://raw.githubusercontent.com/baabelfish/nvim-nim/master/misc/screenshots/autocomplete.png)
![Definition](https://raw.githubusercontent.com/baabelfish/nvim-nim/master/misc/screenshots/definition.png)
![Usages](https://raw.githubusercontent.com/baabelfish/nvim-nim/master/misc/screenshots/usages.png)


## Planned features

- Debugger support
- Async autocomplete with deoplete (maybe a seperate plugin)
