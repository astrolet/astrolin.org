util = require 'util'
path = require 'path'
jade = require 'jade'

# Express app
express = require 'express'
app = express()

# Middleware
ecstatic = require 'ecstatic'

# Development boolean check.
dev = if process.env.NODE_ENV is 'development' then true else false

# Paths
app_path = path.normalize __dirname

# The /public is ecstatic.  This `ecstasy` can be invoked explicitly further on.
ecstatic_opts = autoIndex: false
ecstatic_opts.cache = if dev then false else true
ecstasy = ecstatic app_path + '/public', ecstatic_opts

# Astrolet libs, data and helper locals.
theres = require('lin').theres()
app.locals = require './locals'


# Configuration
app.configure ->
  app.set 'root', app_path
  app.enable 'show exceptions'
  app.use express.logger()
  app.use ecstasy

  # Jade templates
  app.set 'views', app_path + '/views'
  app.engine '.jade', jade.__express
  app.set 'view engine', 'jade'

  # Router after any other assets.
  app.use app.router


# Home page
app.get "/", (req, res, next) ->
  res.render "index", title: "Welcome"

# Projects JSON
app.get "/projects", (req, res, next) ->
  res.contentType('application/json')
  res.render "projects", layout: no

# Project page
app.get "/to/:project?", (req, res, next) ->
  req.params.project = "lin" unless req.params.project?
  res.render "project",
    title: req.params.project
    headest: ""
    project: req.params.project
    forehead: "<br/>" + req.params.project.toUpperCase()

# Projects per category
app.get "/cat/:category", (req, res, next) ->
  res.render "category",
    title: req.params.category
    headest: ""
    category: req.params.category
    forehead: "<br/>" + req.params.category.toLowerCase()

# What the ephemeris provides automatically.
# This is about precious / gravity together with there & lin.
app.get "/data", (req, res, next) ->
  res.render "data"
    title: "Ephemeris Data"
    headest: ""
    forehead: "<br/>having"
    theres: theres


# Catch-all: not found
app.get '*', (req, res) ->
  res.statusCode = 404
  req = url: "/codes/404.html"
  ecstasy req, res

# Catch and log any exceptions that may bubble to the top.
process.addListener 'uncaughtException', (err) ->
  util.puts "Uncaught Exception: #{err.toString()}"

# Start the server.
port = parseInt(process.env.PORT || process.env.VMC_APP_PORT || process.env.C9_PORT || 8001)
app.listen port, null # app.address().port # null host will accept connections from other instances
console.log "Express been started on :%s", port
