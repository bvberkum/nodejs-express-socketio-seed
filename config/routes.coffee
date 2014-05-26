index = require(__base+'controllers')

applyRoutes = (app, root, controller)->
	for name of controller
		url = [ root, name ].join('/')
		if controller[name].sub
			applyRoutes app, url, controller[name].sub
		for method in ['all', 'get', 'put', 'post', 'options', 'delete']
			cb = controller[name][method]
			if cb
				app[method] url, cb

module.exports = ( app, config ) ->

	# Apply routes for page controllers
	site = require(__base+'controllers/site') app, config
	admin = require(__base+'controllers/admin') app, config

	applyRoutes(app, '', site)
	applyRoutes(app, '', admin)
	app.all '/', index.redirect('/home')

	# Apply routes for socket TODO move to controller
	io = app.get 'socketio'
	io.sockets.on 'connection', (socket) ->
		socket.on 'disconnect', ()->
			console.log 'client disconnected'
		socket.on 'message', (msg)->
			console.log 'message from client: '+msg
			socket.send('hello!')
		socket.emit 'test',
			foo: 'Bar'

	# return seed-data for core module
	name: 'builtin'
	config: config
	menu:
		home: url: '/home', label: 'Home'
		about: url: '/about', label: 'About'
	page:
		title: "Untitled"

