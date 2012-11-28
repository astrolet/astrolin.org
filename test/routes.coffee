assert  = require('assert')
APIeasy = require('api-easy')

astrolin = APIeasy.describe 'Astrolin'

(astrolin.use "localhost", 8001).setHeader('Content-Type', 'application/json')

  # Expected and missing routes
  .get("/").expect(200)
  .get("/cat/source").expect(200) # a category
  .get("/to/astrolin").expect(200) # a project
  .get("/projects")
    .expect(200)
    .expect('should contain projects array', (err, res, body) ->
      assert.isObject results = JSON.parse body
      assert.isArray results.projects
      )
  .get("/data").expect(200)
  .get("/missing").expect(404)

  # Connect middleware -- vfs-http-adapter and its heck errorHandler
  .get("/css").expect(200) # no trailing / 302 redirect
  .get("/css/").expect(200) # a valid dir/ 200 json
  .get("/css/screen.css").expect(200) # to get a file
  .head("/css/screen.css").expect(200) # just headers

  # Doubly not allowed methods on non-routes -- whether or not such assets exist
  .post("/anywhere").expect(405)
  .put("/anywhere").expect(405)
  .del("/anywhere").expect(405)
  .put("/robots.txt").expect(405)
  .del("/robots.txt").expect(405)

  .export(module)
