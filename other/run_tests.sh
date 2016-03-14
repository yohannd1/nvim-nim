#!/bin/bash

# Intall plugins
mkdir plugins
git clone https://github.com/baabelfish/vader.vim plugins/vader.vim
git clone https://github.com/baabelfish/nvim-nim plugins/nvim-nim

# Run tests
nvim -u rc.vim -c 'Vader! tests/**/*.vader'
err=$?
if [ "$err" != "0" ]; then
    cat report.log
    exit 1
fi
