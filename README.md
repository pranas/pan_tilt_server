Pan & Tilt Server
================================

This code is part of my internet controlled pan and tilt system project.

It is a very simple [node.js](http://nodejs.org) server for my internet controlled pan and tilt system. It enables near real time low latency control of remote device by using WebSocket connections with web clients and [Pan & Tilt Controller](https://github.com/Pranas/pan_tilt_controller). All visitors are queued. Every 30 seconds next visitor is given a turn to control pan and tilt system.

It's written in [CoffeeScript](http://coffeescript.org/) and depends on [Socket.IO](http://socket.io/) library.

## Prerequisites

You need to have node.js (0.8.x) and npm (1.1.x) installed on your system. Use your package manager to install them. Some node.js packages already include npm and you don't need to install it separately.

## Run

Install dependencies:

    $ npm install

Start the server:

    $ ./node_modules/coffee-script/bin/coffee server.coffee

Open your web browser at [http://localhost:3000](http://localhost:3000)
