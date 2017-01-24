The slides use [reveal.js](https://github.com/hakimel/reveal.js).
To present, run

    git clone https://github.com/hakimel/reveal.js.git
    cd reveal.js
    npm install
    ln -sf /path/to/misc/slides/cf.html index.html
    ln -sf /path/to/misc/slides/cf.md cf.md
    npm start

To push to cloud foundry, use the Gruntfile and manifest here and
hard link or copy the slide files.
