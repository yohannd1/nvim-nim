#!/bin/bash

# Intall plugins
if [[ ! -d plugins ]]; then
    mkdir plugins
    git clone https://github.com/baabelfish/vader.vim plugins/vader.vim
fi

# Run tests
# Running test
nvim -u rc.vim -c 'Vader! tests/**/*.vader'
# nvim -u rc.vim -c 'Vader! tests/**/*.vader' > /dev/null
err=$?
if [ "$err" != "0" ]; then
    cat report.log
    exit 1
else
    echo ""
    echo "Great success!"
fi
