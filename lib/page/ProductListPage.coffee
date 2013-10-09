urlModule = require 'url'

Page = require './Page'


class ProductListPage extends Page
  #### default options for load a product list page.
  defaultOptions:
    headers:
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
      'Accept-Language': 'en-US,en;q=0.8'
      'Cache-Control': 'no-cache'
      'Connection': 'keep-alive'
      # especially, it's for a desktop page, not mobile.
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36'


  #### get next page url from the product list page document.
  getNextPageUrl: ->
    pageLinkTags = @$('#pagnNextLink')

    if pageLinkTags.length is 0
      nextUrl = null
    else
      nextTag = pageLinkTags.eq(0)
      nextUrl = nextTag.attr 'href'
      nextUrl = urlModule.resolve @options.url, nextUrl

    nextUrl


  #### get product id array in the product list page.
  getProductIds: ->
    productIds = []

    productTags = @$('.prod')
    productTags.each (index, element) ->
      productIds.push @attr 'name'

    productIds



module.exports = ProductListPage
