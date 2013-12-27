Page = require './Page'


class ProductBestSellersPage extends Page
  #### default options for load a product detail page.
  defaultOptions:
    headers:
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
      'Accept-Language': 'en-US,en;q=0.8'
      'Cache-Control': 'no-cache'
      'Connection': 'keep-alive'
      # especially, it's for a desktop page, not mobile.
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36'


  constructor: (@options, callback) ->
    return callback new Error 'invalid browseNodeId'  if not @options.browseNodeId?
    return callback new Error 'invalid pageNo'  if not @options.pageNo?
    return callback new Error 'invalid sectionNo'  if not @options.sectionNo?

    typeParam = 'zgbs'
    switch @options.type
      when 'topRated' then typeParam = 'top-rated'

    @options.url = "http://www.amazon.com/gp/#{typeParam}/baby-products/#{@options.browseNodeId}/ref=?_encoding=UTF8&pg=#{@options.pageNo + 1}&ajax=1"
    @options.url += '&isAboveTheFold=0'  if @options.sectionNo > 0

    super @options, (err, $, body) ->
      return callback err  if err?

      products = []
      $('.zg_itemImmersion').each ->
        products.push
          name: @.find('.zg_title').text()?.replace /^\s+|\s+$/g, ''
          url: @.find('.zg_title a').attr('href')?.replace /^\s+|\s+$/g, ''
          imageUrl: @.find('.zg_image .zg_itemImageImmersion a img').attr 'src'
          salePrice: Number @.find('.zg_price .price').text().replace /[^0-9\.]+/g, ''
          details:
            ASIN: @.find('.zg_title a').attr('href')?.replace(/^\s+|\s+$/g, '').split('/')[5]
            averageCustomerReviewCount: Number @.find('.zg_reviews .crAvgStars > a').text().replace /[^0-9\.]+/g, ''
            averageCustomerReviewRating: Number @.find('.zg_reviews .crAvgStars span a .swSprite').text().replace(/[^0-9\.]+/g, '')[0..-2]

      callback null, products



module.exports = ProductBestSellersPage
