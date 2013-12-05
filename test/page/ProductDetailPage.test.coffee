should = require 'should'

ProductDetailPage = require '../../lib/page/ProductDetailPage'


describe 'ProductDetailPage', ->
  describe 'constructor(...)', ->
    it 'should be done', (done) ->
      productDetailPage = new ProductDetailPage
        url: 'http://www.amazon.com/Skip-Hop-Stroller-Organizer-Black/dp/B00APIN8H4/ref=sr_1_1?s=baby-products&ie=UTF8&qid=1385964606&sr=1-1&keywords=879674012059'
      ,
        (err, productDetail) ->
          should.not.exist err
          should.exist productDetail

          done()

    it 'should be done', (done) ->
      productDetailPage = new ProductDetailPage
        url: 'http://www.amazon.com/Huggies-Simply-Clean-Fragrance-Refill/dp/B007HO4W74/ref=zg_bs_166776011_3'
      ,
        (err, productDetail) ->
          should.not.exist err
          should.exist productDetail

          done()
          