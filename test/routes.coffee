APIeasy = require('api-easy')

astrolet = APIeasy.describe('Astrolin');

(astrolet.use "localhost", 8001).setHeader('Content-Type', 'text/html')

  .get("/").expect(200)
  .get("/cat/source").expect(200) # a category
  .get("/to/astrolin").expect(200) # a project

  .export(module)
