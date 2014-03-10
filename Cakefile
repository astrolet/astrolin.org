{exec, spawn} = require 'child_process'
{series, parallel} = require 'async'


# Utility functions

pleaseWait = -> console.log "\nThis may take a while...\n"

print = (data) -> console.log data.toString().trim()

handleError = (err) ->
  if err
    console.log "\nUnexpected error!\nHave you done `npm install`?\n"
    console.log err.stack

sh = (command) -> (k) -> exec command, k

# Modified from https://gist.github.com/920698
runCommand = (name, args) ->
    proc = spawn name, args
    proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
    proc.stdout.on 'data', (buffer) -> console.log buffer.toString()
    proc.on 'exit', (status) -> process.exit(1) if status != 0

# shorthand to runCommand with
command = (c, cb) ->
  runCommand "sh", ["-c", c]
  cb

sleep = (secs, cb) ->
  setTimeout cb, secs * 1000


# Check if any node_modules or gems have become outdated.
task 'outdated', "is all up-to-date?", ->
  pleaseWait()
  parallel [
    command "npm outdated"
    command "bundle outdated"
  ], (err) -> throw err if err


# It's the local police at the project's root.
# Catches outdated modules that `cake outdated` doesn't report (major versions).
task 'police', "checks npm package & dependencies with `police -l .`", ->
  command "node_modules/.bin/police -l ."


# Usually follows `cake outdated`.
task 'update', "latest node modules & ruby gems - the lazy way", ->
  pleaseWait()
  parallel [
    command "npm update"
    command "bundle update"
  ], (err) -> throw err if err


# Testing options.
option '-s', '--spec', '\t  `cake test` spec-reporter vows'
option '-v', '--verbose', '\t  `cake test` vows being verbose'
option '-w', '--wait [seconds]', '\t  `cake test` delay running tests'


task 'test', 'test the app, which should be started first', (options) ->

  # options & defaults
  options.env or= 'development'
  options.wait or= 0

  args = [ "test/vows/*.spec.coffee" ]
  args.unshift '--spec'     if options.spec
  args.unshift '--verbose'  if options.verbose

  execute = "NODE_ENV=#{options.env} node_modules/.bin/vows #{args.join ' '}"
  execute += " | bcat" if options.bcat?

  if options.wait > 0
    console.log "Will sleep for #{options.wait} seconds before running the tests.\n"
  # So that the server can take its time to start before the tests are run ...
  sleep options.wait, ->
    command execute


# Build gh-pages almost exactly like https://github.com/josh/nack does
task 'pages', "build pages (i.e. documentation)", ->

  buildMan = (callback) ->
    series [
      (sh "cp README.md doc/index.md")
      (sh 'echo "# UNLICENSE\n## LICENSE\n\n" > doc/UNLICENSE.md' )
      (sh "cat UNLICENSE >> doc/UNLICENSE.md")
      (sh "ronn -stoc -5 doc/*.md")
      (sh "mv doc/*.html pages/")
      (sh "rm doc/index.md")
      (sh "rm doc/UNLICENSE.md")
    ], callback

  series [
    # mkdir pages only if it doesn't exist
    (sh "if [ ! -d pages ] ; then mkdir pages ; fi")
    (sh "rm -rf pages/*")
    buildMan
  ], (err) -> throw err if err


# Push to gh-pages.
task 'pages:publish', "publish the pages - builds them first", ->

  checkoutBranch = (callback) ->
    series [
      (sh "rm -rf pages/")
      (sh "git clone -q -b gh-pages git@github.com:astrolet/astrolin.git pages")
      (sh "rm -rf pages/*")
    ], callback

  publish = (callback) ->
    series [
      (sh "cd pages/ && git add . && git commit -m 'rebuild manual' || true")
      (sh "cd pages/ && git push git@github.com:astrolet/astrolin.git gh-pages")
      (sh "rm -rf pages/")
    ], callback

  series [
    checkoutBranch
    # NOTE: (invoke "pages") # doesn't work here after checkoutBranch
    (sh "cake pages")
    publish
  ], (err) -> throw err if err


# Run the web app with options.
option '-d', '--debug', "\t  just for development: `node-dev --debug`, and start `node-inspector`"
option '-b', '--bcat', "\t  pipe via `bcat` to the browser as if it's the console"
option '-e', '--env [NODE_ENV]', "\t  set the NODE_ENV for `cake run` task (or 'development')"


# Run the servers.
task 'run', "the web / servers", (options) ->
  options.env or= 'development'
  serving = "NODE_ENV=#{options.env}"
  if options.env is 'development'
    serving = "#{serving} node_modules/.bin/node-dev #{('--debug' if options.debug?) or ''} ./server.js"
  else
    serving += " node ./server.js"
  serving += " | bcat" if options.bcat?
  console.log serving
  parallel [
    command serving
  ], (err) -> throw err if err


# Run in development mode.
task 'dev', "web programming / workflow", (options) ->
  commands = [
    invoke 'run'
    command 'node_modules/.bin/node-inspector' if options.debug?
  ]
  parallel commands, (err) -> throw err if err
