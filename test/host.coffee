path = require 'path'

hosts =
  development:
    name: process.env.IP or "localhost"
    port: process.env.PORT or 8001
  production:
    name: "astrolin.org"
    port: 80

# TODO: more input options, with a hash?
# TODO: this could take test-debug option - to console.log stuff in kiss-style.
# NOTE: do pass __filename to file -- not sure if caller's filename can be got?
module.exports = (file = undefined, env = process.env.NODE_ENV || 'development') ->
  host = hosts[env]

  # TODO: see if the caller's __filename can be verified, actually somehow got.
  ext = path.extname file
  if file?
    host.base = path.basename file, "#{ext}"
  else
    host.base = "{coffee}"

  # TODO: add immediate preceding directory as context, instead of __dirname,
  # just keep it short / readable.
  # NOTE: Test context shouldn't be assumed in the future,
  # is Running broad enough - literally can apply to any {coffee} assumption?
  console.log "Testing http://#{host.name}:#{host.port} with #{host.base}"

  host

