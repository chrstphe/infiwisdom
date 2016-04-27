#!/bin/bash

tail -f /var/log/trainwisdoms.log | sed -ln "s/.*loss = \([0-9.]*\),.*/\1/gp" | ./stream.py 
