fs = require('fs')
server = require('http').createServer(
  (req, res) ->
    fs.readFile(__dirname + '/public/index.html',
      (err, data) ->
        if (err)
          res.writeHead(500)
          return res.end('Error loading index.html')
        res.writeHead(200)
        res.end(data)
    )
)

io = require('socket.io').listen(server)

server.listen process.env.PORT || 3000, (err) ->
  process.exit(1) if err

  process.setgid(process.env.APP_GROUP) if process.env.APP_GROUP
  process.setuid(process.env.APP_USER) if process.env.APP_USER

  if process.env.APP_USER || process.env.APP_GROUP
    console.log('Dropped privileges.. Current UID: ' + process.getuid() + ' GID: ' + process.getgid())

users_queue = []
current_master = null

controllers = io.of '/controller'

controllers.on 'connection', (socket) ->
  console.log 'controller connected'

clients = io.of '/clients'

clients.on 'connection', (socket) ->
  users_queue.push(socket.id)
  update_queue_statuses()

  socket.on 'disconnect', ->
    current_master = null if current_master == socket.id
    index = users_queue.indexOf(socket.id)
    users_queue.splice(index, 1) if index != -1
    update_queue_statuses()

  socket.on 'tilt', (value) ->
    if current_master == socket.id
      controllers.emit('tilt', value)
  socket.on 'pan', (value) ->
    if current_master == socket.id
      controllers.emit('pan', value)

  socket.emit('msg', 'Connected successfully! Please wait for your turn...')


update_queue_statuses = ->
  for user, i in users_queue
    clients.sockets[user].volatile.emit('queue_status', i + 1, users_queue.length)

change_master = ->
  next_user = users_queue.shift()
  update_queue_statuses()

  if current_master
    clients.sockets[current_master].disconnect()
    current_master = null

  if next_user
    current_master = next_user
    clients.sockets[current_master].emit('start')

setInterval(change_master, 30 * 1000)

