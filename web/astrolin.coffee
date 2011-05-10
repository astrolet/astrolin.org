util = require 'util'
path = require 'path'
jade = require 'jade'
_    = require('massagist')._

# Express app
express = require 'express'
app = express.createServer()

app.helpers

  keys: (a) ->
    _.keys(a)

  # = key, false (hides it), or full url
  projects:
    eden:
      tracker: "203533"
    lin:
      tracker: "265847"
    precious:
      tracker: "203533"
    sin:
      tracker: "203533"
      package: "gravity"


  linkage: (project, details) ->
    if details is undefined
      return { "project's unknown": "/" }

    github = "https://github.com/astrolet/"
    ghpages = "http://astrolet.github.com/"
    defaults =
      package: project
      source: project
      issues: "#{project}/issues"
      docs: "#{project}"
    details = _.defaults(details, defaults)
    links = {}

    for key in ["docs", "source", "tracker", "package"]
      if details[key] isnt false
        if details[key].match /^http/
          links[key] = details[key]
        else
          switch key
            when "package"
              links[key] = "http://search.npmjs.org/#/#{details[key]}"
            when "tracker"
              links[key] = "https://www.pivotaltracker.com/projects/#{details[key]}"
            when "source", "issues"
              links[key] = "#{github}#{details[key]}"
            when "docs"
              links[key] = "#{ghpages}#{details[key]}"
    links

# Configuration
app.configure ->
  node_server = path.normalize __dirname
  app.set 'root', node_server
  app.use express.logger()
  app.use app.router
  app.use express.static(node_server + '/public')
  app.set 'views', node_server + '/views'
  app.register '.html', jade
  app.set 'view engine', 'html'
  app.set 'view options', { layout: yes }
  app.enable 'show exceptions'

# Home page
app.get "/", (req, res, next) ->
  res.render "index", { title: "Welcome" }

# Project page
app.get "/to/:project?", (req, res, next) ->
  req.params.project = "lin" unless req.params.project?
  res.render "project", { title: req.params.project
                        , headest: ""
                        , project: req.params.project
                        , forehead: "<br/>" + req.params.project.toUpperCase()
                        }

# Catch and log any exceptions that may bubble to the top.
process.addListener 'uncaughtException', (err) ->
  util.puts "Uncaught Exception: #{err.toString()}"

# Start the server.
port = parseInt(process.env.C9_PORT || process.env.PORT || 8001)
app.listen port, null # app.address().port # null host will accept connections from other instances
console.log "Express been started on :%s", port
