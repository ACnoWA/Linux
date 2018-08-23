#!/bin/bash

dir=0
filenum=0

function getFile(){
    #这样的目录遍历就是在当前目录下，获取的只是相对路径，如果不拼接$1和file，那么工作路径始终是在第一层路径下
    for file in `ls -a $1`; do
        #在判断字符串的时候有个小技巧，就是当字符串为空的时候不好判断
        #所以可以在要判断的字符串前面或后面加任意一个字符，判断的时候当然
        #也要加，在本代码中就是加的x
        #每个目录下都有. 和　..两个无效目录，要排除掉
        if [[ x"$file" != x"." && x"$file" != x".." ]]; then
            if [[ -d "$1/$file" ]]; then
                dir=$[ $dir + 1 ]
                echo "$file"
                getFile "$1/$file"
            else
                filenum=$[ $filenum + 1 ]
                echo $file
            fi
        fi
    done
}

getFile ~
echo $filenum
echo $dir
