#!/bin/bash
if [ "$1" == "new" ]; then
    mkdir char-rnn/data/tea-wisdoms
    cp teawisdoms-orig.txt char-rnn/data/tea-wisdoms/input.txt
    rm char-rnn/data/tea-wisdoms/data.t7 char-rnn/data/tea-wisdoms/vocab.t7
    cv=""
elif [ "$1" == "latest" ]; then
    latest=`grep -o "cv/.*" /var/log/trainwisdoms.log | tail -n 1`
    cv="-init_from $latest"
else
    cv="-init_from $1"
fi

cd char-rnn
nohup th train.lua -data_dir data/tea-wisdoms/ -rnn_size 200 -seq_length 24 -batch_size 1 -train_frac 0.8 -val_frac 0.2 -num_layers 4 -dropout 0.311 -gpuid 1 -max_epochs 10000 $cv > /var/log/trainwisdoms.log &
