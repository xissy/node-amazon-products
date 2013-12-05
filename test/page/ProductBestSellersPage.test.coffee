should = require 'should'

ProductBestSellersPage = require '../../lib/page/ProductBestSellersPage'


describe 'ProductBestSellersPage', ->
  describe 'constructor(...)', ->
    it 'should be done', (done) ->
      productBestSellersPage = new ProductBestSellersPage
        browseNodeId: '370094011'
        pageNo: 0
        sectionNo: 0
      ,
        (err, products) ->
          should.not.exist err
          should.exist products
          products.should.length 3

          done()

  it 'should be done', (done) ->
    productBestSellersPage = new ProductBestSellersPage
      browseNodeId: '370094011'
      pageNo: 0
      sectionNo: 1
    ,
      (err, products) ->
        should.not.exist err
        should.exist products
        products.should.length 17

        done()
        