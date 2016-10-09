Understanding colour contrast
=============================

The Web Content Accessibility Guidelines (WCAG) 2.0 requires that all text must have 
a sufficiently different colour from the background colour. This is to ensure that everyone
can read the text, even if they are colour blind. The
[WCAG site defines what colour contrast values are required](https://www.w3.org/WAI/WCAG20/quickref/#visual-audio-contrast)
but I've always wondered exactly what those numbers mean. This page tries
to explain that in some detail.

## Colour contrast

First of all, how is colour contrast calculated? 
[Color contrast is defined by WCAG](https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html#contrast-ratiodef) as

<img alt="colour contrast equals L1 plus 0.05 over L2 plus 0.05" src="../images/formula_colour_contrast.png" style="height:3em !important">

where

* `L1` is the relative luminance of the lighter of the two colours, and
* `L2` is the relative luminance of the darker of the two colours
 
We will get to the question, "What is relative luminance?" in a moment but first we want
to understand what this formula means. If we ignore the `+ 0.05` sections, then it's just a
ratio between the relative luminance of each colour. A colour contrast of 2 means
one colour has twice the relative luminance of the other. Coming back to the `+ 0.05`, black
has a relative luminance of zero. You can't divide by zero and if you have two colours 
that are almost but not quite black, one might be three times as bright as the other and they
still look basically the same. So adding 0.05 to both values stabilises the formula
around zero.

## Relative luminance

Now we need to tackle relative luminance. Relative luminance represents how bright a colour
is relative to other colours and there are a few steps in calculating it.
Colours are often represented as three numbers between 0 and 255, one for red, one for green,
and one for blue. While this is relatively convenient for defining colours, it's not so
convenient when doing math with them. So first of all, the colours values are converted to numbers
between 0 and 1 by dividing by 255. 0 means "none of this colour" and 1 means "as much of this
colour as you can".

Now we have our red, green and blue values between 0 and 1, we need to convert them from what's known as
gamma-compressed RGB (or what I'm going to call normal RGB) to linear RGB. 
It's not super important how this is calculated, but the formula is

<img alt="linear RGB formula" src="../images/formula_linear_rbg.png" style="height:5em !important">

where `C` is each of the individual red, green and blue values.
If I just look at that formula, I have no idea what it means. So here's a graph instead.

<canvas id="linear_rbg_chart" width="400px" height="200px"></canvas>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.3.0/Chart.min.js"></script>
<script type="text/javascript">window.onload = function() {setup_linear_rgb('linear_rbg_chart')}</script>

It looks like someone has drawn a line from (0,0) to (1,1) and then just 
tugged it down a bit. Okay. As I said, it's not overly important to understand this formula
to understand colour contrast, but for a detailed explanation, see 
[the wikipedia page for sRGB](https://en.wikipedia.org/wiki/SRGB).

Now we have our linear RGB values, we can calculate the relative luminance as

<img alt="relative luminance equals 0.2126 times R + 0.7152 times G + 0.0722 times B" src="../images/formula_relative_luminance.png" style="height:1em !important">

So the relative luminance is the weighted average of the linear RGB values, with
green having the highest weight, then red, then blue. This is because green light
has the highest contribution to perceived brightness by humans.

Conclusion
----------

The main reason to care about colour contrast is to ensure that the
colours we choose have sufficiently high contrast.
So when trying to increase the colour contrast of a pair of colours,
it's worth noting that:

* Only the brightness of each colour matters, their relative hue does not
* Each of the three colour channels act independently
* Changing the green channel will have the greatest effect, then red, then blue
* Changing a brighter channel will have a greater effect than changing a darker one

References
----------

* WCAG 2.0
    * colour contrast guidelines (<https://www.w3.org/TR/WCAG20/#visual-audio-contrast>)
    * definition of "contrast ratio" (<https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html#contrast-ratiodef>)
    * definition of "relative luminance" (<https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef>)
* Wikipedia 
    * relative luminance (<https://en.wikipedia.org/wiki/Relative_luminance>)
    * sRBG (<https://en.wikipedia.org/wiki/SRGB>)
* Formulas produced by <http://latex2png.com/>