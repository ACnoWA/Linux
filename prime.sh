#!/bin/bash

while true; do
echo -p "Enter num:"
read num
flag=1
for (( i=2; i<num; i++ ))
do
    if (( num%i==0  )); then
        flag=0
        break
    fi
done
if (( $flag )); then
echo "YES"
else
    echo "NO"
fi
done
