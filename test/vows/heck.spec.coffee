host = (require '../host')(__filename)
APIeasy = require('api-easy')

heck = APIeasy.describe 'Astrolin'

(heck.use host.name, host.port).setHeader('Content-Type', 'text/html')

  # Connect middleware -- vfs-http-adapter and its heck errorHandler
  .get("/css").expect(200) # no trailing / 302 redirect
  .get("/css/").expect(200) # a valid dir/ 200 json
  .get("/css/screen.css").expect(200) # to get a file
  .head("/css/screen.css").expect(200) # just headers

  # Not Found
  .get("/missing").expect(404)

  # Doubly not allowed methods on non-routes -- whether or not such assets exist
  .post("/anywhere").expect(405)
  .put("/anywhere").expect(405)
  .del("/anywhere").expect(405)
  .put("/robots.txt").expect(405)
  .del("/robots.txt").expect(405)

  .export(module)

