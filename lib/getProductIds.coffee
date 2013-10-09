async = require 'async'

ProductListPage = require './page/ProductListPage'


#### retrieve product IDs.
module.exports = (options, callback) ->
  return callback new Error 'no options.url'  if not options.url?

  productIds = []

  isLastPage = false
  currentUrl = options.url

  async.until ->
    isLastPage
  ,
    (callback) ->
      productListPage = new ProductListPage
        url: currentUrl
      ,
        (err) ->
          return callback err  if err?

          productIds = productIds.concat productListPage.getProductIds()
          nextPageUrl = productListPage.getNextPageUrl()

          if nextPageUrl?
            currentUrl = nextPageUrl
          else
            isLastPage = true

          callback null
  ,
    (err) ->
      return callback err  if err?

      callback null, productIds
