#!/bin/bash
prime=(`seq 1 10005`)

for i in ${!prime[@]}; do
    prime[i]=0
done


for i in {2..10000}
do
    if [[ ${prime[$i]} -eq 0 ]]; then
        prime[0]=$[ ${prime[0]} + 1 ]
        prime[${prime[0]}]=$i
    fi
    for (( j=1; j<=${prime[0]}; j++ ))
    do
        if [[ $[ ${prime[$j]}*$i ] -gt 10001 ]]; then
            break
        fi
        prime[$[ $i * ${prime[$j]} ]]=1
        if [[ $[ $i % ${prime[$j]} ] -eq 0 ]]; then
            break;
        fi
    done
done

echo ${prime[0]}
