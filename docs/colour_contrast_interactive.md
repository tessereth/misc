---
title: Interactive colour contrast
---

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
