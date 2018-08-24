#!/bin/bash
#将配置文件中的变量加载到脚本中，让变量可用
source /home/acnowa/backup_data/.backup.rc

TIME_NOW=`date +"%Y-%m-%d_%H-%M"`

if [[ ! -d $tar_dir ]]; then
    echo -e "$TIME_NOW    \033[31m [ERROR]\033[0m    The $tar_dir is not exist" >> $log
    exit
fi

for i in ` echo $backup_path | tr ":" "\n"`; do
    if [[ ! -d $i ]]; then
        echo -e "$TIME_NOW    \033[31m [ERROR] \033[0m The $i is not exist" >> $log
    fi
    #将开头的/去除
    pre_name=`echo $i | cut -d '/' -f 2- | tr "/" "-"`
    target="${pre_name}_${TIME_NOW}.tar.gz"
    echo ${tar_dir}/${target}
    tar -czPf "${tar_dir}/${target}" $i
    if [[ $? -eq 0 ]]; then
        size=`du -m ${tar_dir}/${target} | cut -f 1`
        echo "$TIME_NOW    backup $i --> $target + ${size}M" >> $log 
    else
        echo -e "$TIME_NOW    \033 [30m [ERROE] \003[0m   Something have been wrong!" >> $log
    fi
done

Del_list=`find $tar_dir -name "*.tar.gz" -mtime +3`

for i in $Del_list; do
    size=`du -m $i | cut -f 1`
    rm -f $i
    echo "$TIME_NOW delete $i --> remove -${size}M" >> $log
done
