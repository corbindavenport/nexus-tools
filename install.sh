#!/bin/bash

# check operating system

if [ "$(uname)" == "Darwin" ]; then
    echo "Darwin"       
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Linux"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Cygwin"
fi