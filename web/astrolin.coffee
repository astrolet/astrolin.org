_    = require 'underscore'
util = require 'util'
path = require 'path'
jade = require 'jade'

# Express app
express = require 'express'
app = express.createServer()

# Middleware
ecstatic = require 'ecstatic'

# Development boolean check.
dev = if process.env.NODE_ENV is 'development' then true else false

app.helpers

  keys: (a) ->
    _.keys(a)

  cats: ["docs", "source", "tracker", "package"]

  # = key, false (hides it), or full url
  projects:
    eden:
      tracker: "203533"
    lin:
      tracker: "265847"
    upon:
      tracker: "265847"
    precious:
      tracker: "203533"
    sin:
      tracker: "203533"
      package: "gravity"
    astrolin:
      tracker: "265847"

  # TODO: how to call this w/o a view
  projectKeys: -> JSON.stringify { projects: _.keys this.projects }

  # Project links
  linkage: (project, details) ->
    if details is undefined
      return { "none such showing yet": "http://github.com/astrolet" }

    github = "https://github.com/astrolet/"
    ghpages = "http://astrolet.github.com/"
    defaults =
      package: project
      source: project
      issues: "#{project}/issues"
      docs: "#{project}"
    details = _.defaults(details, defaults)
    links = {}

    for key in this.cats
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

  # Category links across projects (a little bit sloppy, but no big deal)
  catLinks: (category) ->
    links = {}
    for project, details of this.projects
      all = this.linkage(project, details)
      links[project] = all[category] if all[category]?
    links


# Configuration
app.configure ->

  # Path
  app_path = path.normalize __dirname
  app.set 'root', app_path

  # Options
  app.enable 'show exceptions'
  app.use express.logger()

  # Jade templates
  app.set 'views', app_path + '/views'
  app.register '.html', jade
  app.set 'view engine', 'html'
  app.set 'view options', { layout: yes }

  # The /public is ecstatic.
  ecstatic_opts = autoIndex: false
  ecstatic_opts.cache = if dev then false else true
  app.use ecstatic(app_path + '/public', ecstatic_opts)

  # Router after the static assets.
  app.use app.router


# Home page
app.get "/", (req, res, next) ->
  res.render "index", { title: "Welcome" }

# Projects JSON
app.get "/projects", (req, res, next) ->
  res.contentType('application/json')
  res.render("projects", {layout: false})

# Project page
app.get "/to/:project?", (req, res, next) ->
  req.params.project = "lin" unless req.params.project?
  res.render "project", { title: req.params.project
                        , headest: ""
                        , project: req.params.project
                        , forehead: "<br/>" + req.params.project.toUpperCase()
                        }

# Projects per category
app.get "/cat/:category", (req, res, next) ->
  res.render "category", { title: req.params.category
                        , headest: ""
                        , category: req.params.category
                        , forehead: "<br/>" + req.params.category.toLowerCase()
                        }

# Catch and log any exceptions that may bubble to the top.
process.addListener 'uncaughtException', (err) ->
  util.puts "Uncaught Exception: #{err.toString()}"

# Start the server.
port = parseInt(process.env.PORT || process.env.VMC_APP_PORT || process.env.C9_PORT || 8001)
app.listen port, null # app.address().port # null host will accept connections from other instances
console.log "Express been started on :%s", port
