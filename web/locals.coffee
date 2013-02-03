# Helpers, i.e. the locals for this Express app.

_ = require 'underscore'

# Categories for project links.
categories =
  [ { id: "docs" }
  , { id: "source" }
  , { id: "c9" }
  , { id: "issues" }
  , { id: "tracker" }
  , { id: "package" }
  ]

# Project customization by category plus possibly with some extra configuration.
# Use a key, false to hide something, or full url is ok too.
projects =
  terra:
    docs: false
    tracker: "265847"
    c9: false
  upon:
    issues: true
    tracker: "265847"
  archai:
    issues: true
    tracker: "265847"
  eden:
    tracker: "203533"
  precious:
    issues: true
    tracker: "203533"
  there:
    tracker: "203533"
  sin:
    tracker: "203533"
    package: "gravity"
    c9: false
  pi:
    org: "astropi"
    project: "astropi"
    docs: "https://github.com/astropi/astropi#readme"
    issues: true
    tracker: "265847"
    c9: false
  astrolin:
    issues: true
    tracker: "265847"


# Initialize project links and perhaps a little more.
for project, details of projects

  # override the organization or project names
  org = details.org ? "astrolet"
  proKey = project
  project = details.project if details.project?

  # defaults
  github = "https://github.com/#{org}/"
  ghpages = "http://#{org}.github.com/"
  defaults =
    package: project
    source: project
    c9: project
    issues: "#{project}/issues"
    docs: "#{project}"

  # Special case: GitHub issues are disabled by default -
  # they can be true (using default url), a custom url, or false by default.
  if details.issues?
    if details.issues is true
      delete details.issues
  else
    delete defaults.issues

  details = _.defaults(details, defaults)
  links = {}

  for key in _.pluck categories, "id"
    if details[key]? and details[key] isnt false
      if details[key].match /^http/
        links[key] = details[key]
      else
        switch key
          when "package"
            links[key] = "http://search.npmjs.org/#/#{details[key]}"
          when "tracker"
            links[key] = "https://www.pivotaltracker.com/projects/#{details[key]}"
          when "c9"
            unless details[key] is false
              links[key] = "https://c9.io/astrolet/#{details[key]}"
          when "source", "issues"
            links[key] = "#{github}#{details[key]}"
          when "docs"
            links[key] = "#{ghpages}#{details[key]}"

  projects[proKey].links = links


# Category links across projects.
i=0
for key in _.pluck categories, "id"
  links = {}
  for project in _.keys projects
    all = projects[project].links
    links[project] = all[key] if all[key]?
  categories[i].links = links
  i++


module.exports =

  # Projects:
  prks: _.keys projects

  # Links for a project - basically, its cats.
  linkage: (project) ->
    details = @projects[project]
    if details is undefined
      { "none such showing yet": "http://github.com/astrolet" }
    else
      details.links

  # Categories:
  cats: _.pluck categories, "id"

  # Links per category for all projects that have such.
  linking: (category) -> (_.findWhere categories, id: category).links

