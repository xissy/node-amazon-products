should = require 'should'

getBestSellerProducts = require '../lib/getBestSellerProducts'


describe 'getBestSellerProducts(...)', ->
  it 'should be done', (done) ->
    getBestSellerProducts
      browseNodeId: '370094011'
    ,
      (err, products) ->
        should.not.exist err
        should.exist products
        products.should.length 100

        done()
