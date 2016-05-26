#!/bin/bash
if [ "$1" == "stream" ]; then
    write="| ../cmp.py | tee -a ../teawisdom-new.txt"
else
    write=""
fi

function getwisdoms {
    echo "-----------------------------------------"
    echo "New checkpoint"
    echo $(date)
    echo "$latest"
    echo "-----------------------------------------"
    th sample.lua -checkpoint $latest -gpu 2 -temperature 1.01 | sort | uniq $write
}
cd torch-rnn
latest=( $(ls -tr cv/*t7) )
latest=${latest[-1]}
getwisdoms
while [ 1 == 1 ]; do
    if [ "$1" == "stream" ]; then
       getwisdoms 
   else
	new=( $(ls -tr cv/*t7) )
	new=${new[-1]}
        if [ $latest != $new ]; then
            sleep 60
            latest=$new
            getwisdoms
        fi
    fi
done
