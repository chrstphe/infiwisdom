#!/bin/bash
if [ "$1" == "new" ]; then
    mkdir torch-rnn/data/tea-wisdoms
    python torch-rnn/scripts/preprocess.py --input_txt  teawisdoms-orig.txt --output_h5 teawisdoms.h5 --output_json teawisdoms.json --val_frac 0.1 --test_frac 0.01
    cv=""
elif [ "$1" == "latest" ]; then
    latest=`grep -o "cv/.*" /var/log/trainwisdoms.log | tail -n 1`
    cv="-init_from $latest"
else
    cv="-init_from $1"
fi

cd torch-rnn
nohup th train.lua -model_type rnn -input_h5 ../teawisdoms.h5 -input_json ../teawisdoms.json -rnn_size 256 -seq_length 28 -batch_size 1 -num_layers 4 -dropout 0.3 -gpu 1 -max_epochs 10000 $cv > /var/log/trainwisdoms.log &
