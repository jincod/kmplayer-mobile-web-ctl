express = require 'express'
bodyParser = require 'body-parser'
net = require "net"

sockets = []
app = express()

app.use express.static("public")
app.use(bodyParser.urlencoded())
app.use(bodyParser.json())

app.post '/api', (req, res) ->
  sendCommand req.body.command
  res.end 'ok'

server = net.createServer (socket) ->
    sockets.push socket
    socket.on 'end', () ->
      sockets.splice(sockets.indexOf(socket), 1)
  .listen process.env.LIRCPORT || 8765

process.on 'SIGTERM', () ->
  server.close()

sendCommand = (command) ->
	for socket in sockets
		socket.write "0000000000eab154 00 #{command} myremote"

app.listen process.env.PORT || 38476