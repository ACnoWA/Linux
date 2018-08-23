#!/bin/bash

max_len=0
ans=a
travel=no

#read -p "Enter the path:" path
#echo $path

function search() {
    #输入参数为目录
    if [[ -d $1 ]]; then
        #注意这个遍历目录的方式，$1/*这样就让每一层的文件都具备了全路径
        for sub_file in $1/*; do
            #该目录下还是目录时，递归
            if [[ -d $sub_file ]]; then
                echo $sub_file
                search $sub_file
            elif [[ -f $sub_file ]]; then
                echo $sub_file
                words=`cat $sub_file`
                for i in $words; do
                    length=${#i}
                    if [[ $length -gt $max_len ]]; then
                        max_len=$length
                        ans=$i
                        travel=$sub_file
                    fi
                done
   
            fi
        done
    #输入参数为文件时
    elif [[ -f $1 ]]; then
        words=`cat $1`
        for i in $words; do
            length=${#i}
            if [[ $length -gt $max_len ]]; then
                max_len=$length
                ans=$i
                travel=$1
            fi
        done
    else
        echo "您的输入有误，命令终止！"
        return
    fi
}



search $1
#echo $path
#search ~/shell
echo $max_len
echo $ans
echo $travel

