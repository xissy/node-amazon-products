async = require 'async'

ProductBestSellersPage = require './page/ProductBestSellersPage'


#### retrieve best seller products.
module.exports = (options, callback) ->
  return callback new Error 'no options.categoryId'  if not options?.categoryId?

  pageNos = [0...5]
  sectionNos = [0...2]

  async.map pageNos
  ,
    (pageNo, callback) ->
      async.map sectionNos
      ,
        (sectionNo, callback) ->
          productBestSellersPage = ProductBestSellersPage
            categoryId: options.categoryId
            pageNo: pageNo
            sectionNo: sectionNo
          ,
            callback
      ,
        (err, sections) ->
          return callback err  if err?

          products = []
          for section in sections
            products = products.concat section

          callback null, products
  ,
    (err, pages) ->
      return callback err  if err?

      products = []
      for page in pages
        products = products.concat page

      callback null, products
