#!/bin/bash

for i in `seq $1 $2`; do
    ping -c 2 -W 1 192.168.1.$i 2>&1 >/dev/null
    if [[ $? -eq 0 ]]; then
        echo "192.168.1.$i"
    fi
done

