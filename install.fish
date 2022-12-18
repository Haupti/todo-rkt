#!/bin/fish

set LIB_PATH $HOME
set BIN_PATH "/usr/local/bin"

mkdir $LIB_PATH/todo-rkt

raco exe -l --vv "todo.rkt"

cp todo $BIN_PATH
