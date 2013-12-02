urlModule = require 'url'

Page = require './Page'


class ProductDetailPage extends Page
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
    super @options, (err, $) ->
      return callback err  if err?

      shippingMessage = $('#ourprice_shippingmessage').text().replace /^\s+|\s+$/g, ''
      shippingMessage = shippingMessage[2..]  if shippingMessage[0...2] is '& '
      shippingMessage = shippingMessage[0...-8]  if shippingMessage[-8..-1] is ' Details'

      technicalDetails = {}
      $('#prodDetails .container .content table tr').each ->
        tdTags = @.find('td')
        key = tdTags.eq(0).text().replace /^\s+|\s+$/g, ''
        value = tdTags.eq(1).text().replace /^\s+|\s+$/g, ''
        return  if key is '' or value is ''

        value = Number value  if "#{Number value}" is value
        technicalDetails[key] = value

      productDetail =
        name: $('#title').text().replace /^\s+|\s+$/g, ''
        brand: $('#brand').text().replace /^\s+|\s+$/g, ''
        salePrice: $('#priceblock_ourprice').text().replace /[^0-9\.]+/g, ''
        shippingMessage: shippingMessage
        availability: $('#availability').text().replace /^\s+|\s+$/g, ''
        technicalDetails: technicalDetails
      
      callback null, productDetail



module.exports = ProductDetailPage
