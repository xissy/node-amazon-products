should = require 'should'

getProductIds = require '../lib/getProductIds'


describe 'getProductIds(...)', ->
  it 'should be done', (done) ->
    getProductIds
      url: 'http://www.amazon.com/s/ref=sr_pg_2?rh=n%3A165796011%2Cn%3A%21165797011%2Cn%3A166842011&page=220&bbn=165797011&sort=reviewrank_authority&ie=UTF8&qid=1381287847'
    ,
      (err, productIds) ->
        should.not.exist err
        should.exist productIds

        done()
