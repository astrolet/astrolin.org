# Helpers, i.e. locals for this express.js app.

_ = require 'underscore'

module.exports =

  keys: (a) ->
    _.keys(a)

  cats: ["docs", "source", "issues", "tracker", "package"]

  # = key, false (hides it), or full url
  projects:
    terra:
      docs: false
      tracker: "265847"
    eden:
      tracker: "203533"
    lin:
      issues: true
      tracker: "265847"
    upon:
      issues: true
      tracker: "265847"
    precious:
      issues: true
      tracker: "203533"
    there:
      tracker: "203533"
    sin:
      tracker: "203533"
      package: "gravity"
    pi:
      org: "astropi"
      project: "astropi"
      docs: "https://github.com/astropi/astropi#readme"
      issues: true
      tracker: "265847"
    astrolin:
      issues: true
      tracker: "265847"

  # TODO: w/o a view?
  projectKeys: -> JSON.stringify { projects: _.keys this.projects }

  # Project links
  linkage: (project, details) ->
    if details is undefined
      return { "none such showing yet": "http://github.com/astrolet" }

    # override the organization or project names
    org = details.org ? "astrolet"
    project = details.project if details.project?

    # defaults
    github = "https://github.com/#{org}/"
    ghpages = "http://#{org}.github.com/"
    defaults =
      package: project
      source: project
      issues: "#{project}/issues"
      docs: "#{project}"

    # special case: github issues are usually disabled for now
    # issues can be true (using default url), a custom url, or false by default
    if details.issues?
      if details.issues is true
        delete details.issues
    else
      delete defaults.issues

    details = _.defaults(details, defaults)
    links = {}

    for key in this.cats
      if details[key]? and details[key] isnt false
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

