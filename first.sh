#!/bin/bash

echo "hello word"
echo "第一个参数$1"
echo "第二个参数$2"
echo "参数个数$#"
echo "所有参数$*"
echo "$@"
echo "$0"

for i in "$*";do
    echo $i
done

for i in "$@";do
    echo $i
done
