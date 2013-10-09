should = require 'should'

ProductListPage = require '../../lib/page/ProductListPage'


describe 'ProductListPage', ->
  it 'should be done', (done) ->
    productListPage = new ProductListPage
      url: 'http://www.amazon.com/s/ref=sr_st?bbn=165797011&qid=1381287843&rh=n%3A165796011%2Cn%3A!165797011%2Cn%3A166842011&sort=reviewrank_authority'
    ,
      (err, $) ->
        should.not.exist err
        should.exist $

        nextPageUrl = productListPage.getNextPageUrl()
        should.exist nextPageUrl

        productIds = productListPage.getProductIds()
        should.exist productIds
        productIds.should.length 24

        done()
