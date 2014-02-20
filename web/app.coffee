util = require 'util'
path = require 'path'
heck = require 'heck'
merge = require 'deepmerge'

# Express app
express = require 'express'
app = express()

# Development boolean check.
dev = if process.env.NODE_ENV is 'development' then true else false

# Paths
app_path = path.normalize __dirname

# Astrolet libs, data and helper locals.
theres = require('archai').theres()
app.locals = merge require('./locals'), app.locals
app.locals.pretty = true if dev


# Routing with Flatiron's Director.
director = require 'director'
router = new director.http.Router
  "/": get: -> @res.render "index"
    title: "Welcome" # Home page
    forehead: undefined # cached otherwise

# Projects JSON
router.get "/projects", ->
  @res.contentType('application/json')
  @res.render "projects", layout: no

# Project page
router.param 'project', /\/?(\w*)/
router.get "/to:project", (prj) ->
  prj = "astrolin" if prj is ''
  @res.render "project",
    title: prj
    headest: ""
    project: prj
    forehead: "<br/>" + prj.toUpperCase()

# Projects per category
router.get "/cat/:category", (cat) ->
  @res.render "category",
    title: cat
    headest: ""
    category: cat
    forehead: "<br/>" + cat.toLowerCase()

# What the ephemeris provides automatically.
# This is about precious / gravity together with there & lin.
router.get "/data", ->
  @res.render "data"
    title: "Ephemeris Data"
    headest: ""
    forehead: "<br/>having"
    theres: theres

# Observability status from http://vimeo.com/52714202
router.get "/health", ->
  @res.send
    of: @res.locals.headHost
    as: @res.locals.theme
    on: (new Date)
    pid: process.pid
    uptime: process.uptime() # in seconds
    memory: process.memoryUsage() # in bytes
    versions: process.versions
    platform: process.platform
    processor: process.arch


# Configuration
app.configure ->
  app.set 'root', app_path
  app.enable 'show exceptions'

  # Jade templates
  app.set 'views', app_path + '/views'
  app.engine 'jade', require('jade').__express
  app.set 'view engine', 'jade'

  # Middlewares
  app.use express.logger()

  # Enable host-specific variations of pages, app details, etc.
  # So far 'astrolin.org' and 'astropi.org' for a view `theme`.
  app.use (req, res, next) ->
    res.locals.headHost = req.headers.host.split(':')[0].toString()
    res.locals.headHost = process.env.HOST_APP if dev and process.env.HOST_APP?
    res.locals.theme = 'lin'
    res.locals.other = 'pi'
    if res.locals.headHost is 'astropi.org'
      [res.locals.theme, res.locals.other] = [res.locals.other, res.locals.theme]
    res.locals.otherURL = "astro#{res.locals.other}.org"
    next()

  # Some heck configuration options for custom errors.
  app.use heck.connect
    platesDir: app_path + "/public"
    templates:
      "4xx": "/codes/4xx.html"
      "5xx": "/codes/5xx.html"
    debugClass: "debug-hand"
    debugLess:
      classes: [ "code-wit textual code-vspace", "code-pic code-vspace" ]

  # Routing...
  app.use (req, res, next) ->
    router.dispatch req, res, (err) ->
      if err
        if req.method is 'GET' or req.method is 'HEAD'
          next()
        else
          heck.handler req, res, "
Route '#{req.url}' not found, the '#{req.method}' method not allowed further.",
            405

  # Cloud9's vfs for static files
  vfs = require('vfs-local') root: "#{app_path}/public"
  app.use require('vfs-http-adapter') '/', vfs,
    readOnly: true
    errorHandler: heck.handler


# Catch and log any exceptions that may bubble to the top.
process.addListener 'uncaughtException', (err) ->
  util.puts "Uncaught Exception: #{err.toString()}"

# Start the server.
port = parseInt(process.env.PORT || 8001)
host = process.env.IP || '127.0.0.1' # heroku config:add IP=0.0.0.0
app.listen port, host
console.log "Astrolin has started on http://#{host}:#{port}"
