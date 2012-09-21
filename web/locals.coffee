# Helpers, i.e. locals for this express.js app.

_ = require 'underscore'

# These are only used by the `errorHandler`, so far.
ErrorPage = require 'error-page'
fs = require 'fs'
plates = require 'plates'


module.exports =

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
    there:
      tracker: "203533"
    sin:
      tracker: "203533"
      package: "gravity"
    astrolin:
      tracker: "265847"

  # TODO: w/o a view?
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

  # Pass to `vfs-http-handler` or call directly.
  errorHandler: (req, res, err, code) ->
    console.error err.stack || err

    # An `error-page` handler, because `templar` wasn't working.
    errorTemplate = (req, res, data) ->
      template = if 400 <= data.code < 500 then "4xx" else "5xx"
      template = __dirname + "/public/codes/" + template + ".html"

      fs.readFile template, (err, plate) ->
        if err
          # Error page not found.
          data.furtherError = err
          res.writeHead 500, "Content-Type": "text/html"
          res.end JSON.stringify data
        else
          # Using plates to serve the html.
          # So that the pages can say more about what went wrong.
          res.writeHead status, "Content-Type": "text/html"
          res.end plates.bind plate.toString(), data

    # The `error-page` module options.
    errorOptions =
      debug: true
      "*": errorTemplate

    # The status code and error message.
    message = err.stack.message || err.message || err
    if code then status = code
    else switch err.code
      when "EBADREQUEST"
        status = 400
      when "EACCESS"
        status = 403
      when "ENOENT"
        status = 404
      when "ENOTREADY"
        status = 503
      when "EISDIR"
        # Directories must end with a '/'.
        return res.redirect req.url + '/'
      else status = 500

    # Handle the error.
    res.error = new ErrorPage req, res, errorOptions
    res.error status, message

