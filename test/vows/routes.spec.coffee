host = (require '../host')(__filename)
assert  = require('assert')
APIeasy = require('api-easy')

astrolin = APIeasy.describe 'Astrolin'

(astrolin.use host.name, host.port).setHeader('Content-Type', 'text/html')

  # Expected routes and more ...
  .get("/").expect(200)
  .get("/cat/source").expect(200) # a category
  .get("/to/astrolin").expect(200) # a project
  .get("/projects")
    .expect(200)
    .expect('should contain projects array', (err, res, body) ->
      assert.isObject results = JSON.parse body
      assert.isArray results.projects
      )
  .get("/health").expect(200)

  .export(module)
