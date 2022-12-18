#!/bin/fish

set LIB_PATH "/var/lib/"
set BIN_PATH "/usr/local/bin/"

touch install-config
echo "lib-path=$LIB_PATH" >> install-config
mkdir $LIB_PATH/todo-rkt

raco exe -l --vv "todo.rkt"
mv todo $BIN_PATH

rm install-config