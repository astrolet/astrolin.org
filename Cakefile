require.paths.unshift "#{__dirname}/node_modules"

{exec, spawn} = require 'child_process'
{series, parallel} = require 'async'


print = (data) -> console.log data.toString().trim()

handleError = (err) ->
  if err
    console.log "\n\033[1;36m=>\033[1;37m Remember you need to `npm install` the package.json devDependencies and also `bundle install`.\033[0;37m\n"
    console.log err.stack

sh = (command) -> (k) -> exec command, k

# Modified from https://gist.github.com/920698
runCommand = (name, args) ->
    proc = spawn name, args
    proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
    proc.stdout.on 'data', (buffer) -> console.log buffer.toString()
    proc.on 'exit', (status) -> process.exit(1) if status != 0


option '-s', '--spec', 'Use Vows spec mode'
option '-v', '--verbose', 'Verbose vows when necessary'

task 'test', 'Test the app', (options) ->

  args = []
  args.unshift '--spec'     if options.spec
  args.unshift '--verbose'  if options.verbose

  vows = spawn 'vows', args
  vows.stdout.on 'data', print
  vows.stderr.on 'data', print


# Build gh-pages almost exactly like https://github.com/josh/nack does
task 'pages', "Build pages", ->

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
    (sh "if [ ! -d pages ] ; then mkdir pages ; fi") # mkdir pages only if it doesn't exist
    (sh "rm -rf pages/*")
    buildMan
  ], (err) -> throw err if err


task 'pages:publish', "Publish pages", ->

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
    (sh "cake pages") # NOTE: (invoke "pages") # doesn't work here after checkoutBranch
    publish
  ], (err) -> throw err if err
