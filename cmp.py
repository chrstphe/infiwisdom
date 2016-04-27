#!/usr/bin/env python

import sys, re, string

def removepunctuation(word):
    pattern = re.compile('[^\w| ]+')
    return(pattern.sub('', word))

def linefilter(l):
    line = removepunctuation(l)
    return(line)

with open('char-rnn/data/tea-wisdoms/input.txt', 'r') as c:
    wisdoms = list(map(linefilter, c))

with open('allwords', 'r') as c:
    words = list(map(linefilter, c))

def allwords(l):
    return(all([x.lower() in words for x in line.split()]))

for l in sys.stdin:
    line = linefilter(l)
    if len(line) >0 and (line not in wisdoms) and allwords(line) and line[0].isupper():
        sys.stdout.write(l)
