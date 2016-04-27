#!/bin/bash

function getwisdoms {
    echo "-----------------------------------------"
    echo "New checkpoint"
    echo $(date)
    echo $(echo "$latest" | grep -o "\d\.\d*" | tail -n 1)
    echo "-----------------------------------------"
    th sample.lua $latest -gpuid 2 -temperature 1.1 -seed `echo $RANDOM % 123 + 1 | bc` | sed '$ d' | sed '1,/-------/d' | sort | uniq | ./cmp.py | tee -a ../teawisdom-new.txt
}
cd char-rnn
latest=`grep -o "cv/.*" /var/log/trainwisdoms.log | tail -n 1`

getwisdoms
while [ 1 == 1 ]; do
    if [ "$1" == "stream" ]; then
       getwisdoms 
   else
        new=`grep -o "cv/.*" /var/log/trainwisdoms.log | tail -n 1`
        if [ $latest != $new ]; then
            latest=$new
            getwisdoms
            sleep 60
        fi
    fi
done
