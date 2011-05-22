APIeasy = require('api-easy')
assert = require('assert')

astrolet = APIeasy.describe('Astrolin');

(astrolet.use "localhost", 8001).setHeader('Content-Type', 'application/json')

  .get("/").expect(200)
  .get("/cat/source").expect(200) # a category
  .get("/to/astrolin").expect(200) # a project
  .get("/projects")
    .expect(200)
    .expect('should contain projects array', (err, res, body) ->
      assert.isObject results = JSON.parse body
      assert.isArray results.projects
      )

  .export(module)
