# Bitstamp React Pusher (websockets) Orderbook Visualization

Visualizes the Bitstamp BTC/USD Orderbook


#### todo:

sum up all the trades at the same price in the same bar / element

---

# mkv Opal setup (no sprockets, using guard)

A very fast opal setup - includes opal browser - uses guard to automatically compile your .js.ruby files as you save them - has opal and opal-browser vendored already in js files.

Open the project in a webserver:

    python SimpleHTTPServer 3000


then open a browser at:

<http://localhost:3000>


#### Development

install the dependencies

    bundle


launch guard:

    guard


modify app.rb, save and refresh the browser


---

you can also run everything with a simple command (experimental)

    rake

---

#### extra infos:

build a stdlib module

    File.open("math.js", 'w') { |file| file.write(Opal::Builder.build('math')) }

all stdlib modules:

https://github.com/opal/opal/tree/master/stdlib

useful stdlib modules:

- nodejs (file, dir, kernel, io ...)
- js (instanceof, typeof, call ...)
