#!/bin/bash

PARA_CNT=$#
TRASH_DIR=~/.trash

status=0
#标记要删除的文件或目录再输入参数的位置
flag=0

#标记各种选项输入的情况
if [[ $1 = "-r" ]]; then
    status=1
    flag=$[ $flag + 1 ]
elif [[ $1 = "-f" ]]; then
    status=2
    flag=$[ $flag + 1 ]
fi
if [[ $1 = "-r" && $2 = "-f" ]] || [[ $1 = "-f" && $2 = "-r" ]]; then
    status=3
    flag=$[ $flag + 1 ]
fi
  


for i in $@; do
    #rm -r时，且循环输入参数跳过了选项开始读文件或目录
    if [[ $status -eq 1 && $flag -eq 0 ]]; then
        if [[ -e $i ]]; then
            STAMP=`date "+%Y-%m-%d-%T"`
            dirName=`basename $i`
            echo "$i $TRASH_DIR/$fileName.$STAMP" 
            mv $i $TRASH_DIR/$dirName.$STAMP
        else
            echo "rm: 无法删除'$i':　该目录不存在"
        fi
        #当rm -f时
    elif [[ $status -eq 2 && $flag -eq 0 ]]; then
        if [[ -f $i ]]; then
            STAMP=`date "+%Y-%m-%d-%T"`
            fileName=`basename $i`
            echo "$i $TRASH_DIR/$fileName.$STAMP" 
            mv $i $TRASH_DIR/$fileName.$STAMP
        elif [[ -d $i ]]; then
            echo "rm: 无法删除'$i': 是一个目录"
        fi
        #当em -r -f/ rm -f -r时
    elif [[ $status -eq 3 && $flag -eq 0 ]]; then
        if [[ -e $i ]]; then
        STAMP=`date "+%Y-%m-%d-%T"`
        dirName=`basename $i`
        echo "$i $TRASH_DIR/$fileName.$STAMP" 
        mv $i $TRASH_DIR/$dirName.$STAMP
        else
            echo "rm:无法删除'$i':该目录不存在"
        fi
        #当无选项时
    elif [[ $status -eq 0 ]]; then
        if [[ -e $i ]]; then
            if [[ -f $i ]]; then
                STAMP=`date "+%Y-%m-%d-%T"`
                fileName=`basename $i`
                echo "$i $TRASH_DIR/$fileName.$STAMP" 
                mv $i $TRASH_DIR/$fileName.$STAMP
             elif [[ -d $i ]]; then
                echo "rm: 无法删除'$i': 是一个目录"
                fi
        elif [[ $i = "*" ]]; then
            echo $i
        else
                echo "rm:　无法删除'$i':该文件不存在"
        fi
    fi
    flag=$[ $flag - 1 ]
done

