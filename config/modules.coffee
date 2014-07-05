path = require 'path'
util = require 'util'
fs = require 'fs'
_ = require 'underscore'


class Component
	# Object to hold paths and loaded controllers
	constructor: (opts) ->
		{@name, @config, @menu, @url} = opts
	configure: (root) ->
		@viewPath = path.join root, 'views'
		@modelPath = path.join root, 'models'
		@controllerPath = path.join root, 'controllers'

class Module extends Component
	constructor: (@name, @config) ->
	configure: (extroot) ->
		@moduleRoot = path.join extroot, @name
		super @moduleRoot
	load: (app) ->
		@handlers = _.extend(
			# load module controller
			require( @controllerPath )(app, @)
			# extend with convenience function
			redirect: (path) ->
				(req, res) ->
					res.redirect(path)
		)
		# initialize route config for this module
		@routes = require('./routes.'+@name)(app, @)

classes = [0, Module]

getModClass = (name, config)->
	v = config.version || 1
	classes[v]

must_exist = (path) ->
	if not path or not fs.existsSync(path)
		console.error(util.format("Path does not exist: %s", path))
		process.exit(1)

module.exports = (app, core) ->

	# expose core module to Jade via Express
	core = new Component core
	core.configure(core.config.root)
	app.set 'appcore', core

	must_exist(core.config.root)

	modules = []
	extroot = path.join core.config.root, 'app', 'ext'
	must_exist(extroot)
	fs.readdir extroot, (files, dirs) ->
		for name in dirs
			# TODO load module config
			ModClass = getModClass( name, core.config )
			module = new ModClass( name, core.config )
			module.configure extroot
			module.load app 
			modules.push module

	app.set 'appmodules', modules

	return modules



