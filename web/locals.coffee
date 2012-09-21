# Helpers, i.e. locals for this express.js app.

_ = require 'underscore'

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

  errorHandler: (req, res, err, code) ->
    console.error err.stack || err
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
    message = status + ' ' + (err.stack.message || err.message || err) + "\n"
    res.writeHead status, "Content-Type": "text/plain"
    res.end message
