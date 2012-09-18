assert  = require('assert')
APIeasy = require('api-easy')

astrolin = APIeasy.describe 'Astrolin'

(astrolin.use "localhost", 8001).setHeader('Content-Type', 'application/json')

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
  .put("/anywhere").expect(405)
  .post("/anywhere").expect(405)
  #TODO: delete method, api-easy doesn't have yet
  #.get("/css/").expect(200) # vfs-served directory json (can't be tested yet)
  .head("/css/screen.css").expect(200)
  .get("/css/screen.css").expect(200)

  .export(module)
