---
title: Interactive colour contrast
---

# Understanding colour contrast interactively

Trying to understand colour contrast just from the formulas is
hard. But trying to create an interactive graph for colour contrast is
also hard. Each of the colours has 3 different inputs plus the
colour contrast itself gives a total of 7 dimensions. It's really hard
to visualize 7 dimensions.

But the colour contrast is basically just the ratio between the
relative luminance of each colour and graphing the relative luminance
only requires 4 dimensions. So the following graph lets you pick a
specific value for one of red, green or blue and then plots the other
two colours and the relative luminance on a 3D graph. When comparing
against black, a higher relative luminance gives a higher colour contrast.
Also, the slope of the surface gives an idea of how much a change in
one colour channel will effect the colour contrast. A steep slope means
a small change will have a comparatively large effect on the final colour
contrast.

The colour values in the plot are reported as numbers between 0 and 1.
Multiply these numbers by 255 to convert them to normal 8-bit values.


<div id="visualization"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.16.1/vis.min.js"></script>
<script type="text/javascript">
  window.onload = function() {setup_relative_luminance('visualization')};
</script>

<div id="controls">
<label for="red">Red</label>
<input type="number" step="0.1" min="0" max="1" value="0" id="red"/>
<button onclick="update_fixed('red', 'red')">Set red</button>
<label for="green">Green</label>
<input type="number" step="0.1" min="0" max="1" value="0" id="green"/>
<button onclick="update_fixed('green', 'green')">Set green</button>
<label for="blue">Blue</label>
<input type="number" step="0.1" min="0" max="1" value="0" id="blue"/>
<button onclick="update_fixed('blue', 'blue')">Set blue</button>
<br>
<button onclick="reset_camera()">Reset camera</button>
</div>
