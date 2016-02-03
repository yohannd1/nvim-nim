#!/bin/bash

current=$PWD

install_nim() {
    wget "http://nim-lang.org/download/nim-0.13.0.tar.xz" -O nim.tar.xz
    mkdir nim
    tar -xvf nim.tar.xz -C nim --strip-components=1
    cd nim
    ./build.sh
    export PATH=$PATH:$PWD/bin
    cd ..
}

install_nimble() {
    git clone https://github.com/nim-lang/nimble.git
    cd nimble
    git clone -b v0.13.0 --depth 1 https://github.com/nim-lang/nim vendor/nim
    nim c -r src/nimble
    export PATH=$PATH:$PWD/src
    cd ..
}

install_nimsuggest() {
    git clone https://github.com/nim-lang/nimsuggest
    cd nimsuggest
    echo "y" | nimble build
    export PATH=$PATH:$PWD
    cd ..
}

mkdir tmp
cd tmp

echo "Installing nim"
install_nim

echo "Installing nimble"
install_nimble

echo "Installing nimsuggest"
install_nimsuggest

cd ..

echo "================================================================================"

echo -e "\nNim:"
nim --version

echo -e "\nNimble:"
nimble --version

echo -e "\nNimsuggest:"
nimsuggest --version

echo "================================================================================"

echo "Run tests in $PWD"
cd $current/other
nim c tests/nimsuggest/suggestions.nim
nim c tests/edb/edb.nim
