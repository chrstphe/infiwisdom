#!/usr/bin/env python3

import sys, time
import plotly.plotly as py
import plotly.tools as tls
from plotly.graph_objs import *

import numpy as np  # 

stream_ids = tls.get_credentials_file()['stream_ids']

stream_id = stream_ids[0]

# Make instance of stream id object 
stream = Stream(
    token=stream_id,  # (!) link stream id to 'token' key
    maxpoints=1800      # (!) keep a max of 80 pts on screen
)

trace1 = Scatter(
    x=[],
    y=[],
    mode='lines+markers',
    stream=stream         # (!) embed stream id, 1 per trace
)

data = Data([trace1])

# Add title to layout object
layout = Layout(title='Time Series')

# Make a figure object
fig = Figure(data=data, layout=layout)

# (@) Send fig to Plotly, initialize streaming plot, open new tab
unique_url = py.plot(fig, filename='loss-stream')

s = py.Stream(stream_id)

# (@) Open the stream
s.open()

for i, line in enumerate(sys.stdin):
    line = float(line.strip())
    s.write(dict(x=i, y=line))
    time.sleep(0.08)
