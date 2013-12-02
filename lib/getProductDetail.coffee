
ProductDetailPage = require './page/ProductDetailPage'


module.exports = (options, callback) ->
  return callback new Error 'no options.url'  if not options.url?

  productDetailPage = new ProductDetailPage options, callback
