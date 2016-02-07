#!/bin/bash
export NVIM_LISTEN_ADDRESS="/tmp/nvim"
nvim --headless&
nvimpid=$!
sleep 2
sh -c "py.test -v tests/vim/**.py"
haderr=$?
sleep 1
kill $nvimpid
wait
exit $haderr
