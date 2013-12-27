_ = require 'lodash'
urlModule = require 'url'
querystring = require 'querystring'
async = require 'async'
request = require 'request'
cheerio = require 'cheerio'

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
    super @options, (err, $, body) ->
      return callback err  if err?

      shippingMessage = $('#ourprice_shippingmessage').text().replace /^\s+|\s+$/g, ''
      shippingMessage = shippingMessage[2..]  if shippingMessage[0...2] is '& '
      shippingMessage = shippingMessage[0...-8]  if shippingMessage[-8..-1] is ' Details'

      details = {}
      if $('#detail-bullets_feature_div').length > 0
        # http://www.amazon.com/Huggies-Simply-Clean-Fragrance-Refill/dp/B007HO4W74/ref=zg_bs_166776011_3
        $('#detail-bullets_feature_div #detail-bullets table .content li').each ->
          key = @.children('b').eq(0).text().replace(/^\s+|\s+$/g, '')[0..-2]
          value = @.text().replace(/\n/g, '').replace(/^\s+|\s+$/g, '')[key.length+2..].replace(/\(.*\)/g, '').replace(/^\s+|\s+$/g, '')
          return  if key is '' or value is ''
          return  if key in [ 'Average Customer Review', 'Amazon Best Sellers Rank' ]
          
          value = Number value  if key not in [ 'UPC' ] and "#{Number value}" is value
          details[key] = value

        details.UPCs = details.UPC?.split(' ')
        details.UPC = details.UPCs[0]  if details.UPCs?.length > 1

        tellFriendUrl = $('#tell-a-friend').attr 'data-dest'
        details.parentASIN = querystring.parse(urlModule.parse(tellFriendUrl)?.query)?.parentASIN  if tellFriendUrl?
        details.averageCustomerReviewCount = Number $('#detail-bullets_feature_div #detail-bullets table .content li .crAvgStars > a').text().replace /[^0-9\.]+/g, ''
        details.averageCustomerReviewRating = Number $('#detail-bullets_feature_div #detail-bullets table .content li .crAvgStars .swSprite span').text().replace(/[^0-9\.]+/g, '')[0..-2]

        categories = []
        browseNodeIds = []
        $('.zg_hrsr_ladder').each ->
          categoryTree = []
          @.find('a').each ->
            categoryTree.push @.text()
            browseNodeId = urlModule.parse(@.attr('href'))?.path?.split('/')[4]
            if "#{Number browseNodeId}" is browseNodeId
              browseNodeIds.push browseNodeId
          categories.push categoryTree

        details.categories = categories
        details.browseNodeIds = _.uniq browseNodeIds
      else
        # http://www.amazon.com/Skip-Hop-Stroller-Organizer-Black/dp/B00APIN8H4/ref=sr_1_1?s=baby-products&ie=UTF8&qid=1385964606&sr=1-1&keywords=879674012059
        $('#prodDetails .column .content table tr').each ->
          tdTags = @.find('td')
          key = tdTags.eq(0).text().replace /^\s+|\s+$/g, ''
          value = tdTags.eq(1).text().replace(/\(.*\)/g, '').replace /^\s+|\s+$/g, ''
          return  if key is '' or value is ''
          return  if key in [ 'Customer Reviews', 'Best Sellers Rank' ]

          value = Number value  if key not in [ 'UPC' ] and "#{Number value}" is value
          details[key] = value

        details.UPCs = details.UPC?.split(' ')
        details.UPC = details.UPCs[0]  if details.UPCs?.length > 1

        tellFriendUrl = $('#tell-a-friend').attr 'data-dest'
        details.parentASIN = querystring.parse(urlModule.parse(tellFriendUrl)?.query)?.parentASIN  if tellFriendUrl?
        details.averageCustomerReviewCount = Number $('#averageCustomerReviewCount').text().replace /[^0-9\.]+/g, ''
        details.averageCustomerReviewRating = Number $('#averageCustomerReviewRating').text().replace(/[^0-9\.]+/g, '')[0..-2]

        categories = []
        browseNodeIds = []
        $('.zg_hrsr_ladder').each ->
          categoryTree = []
          @.find('a').each ->
            categoryTree.push @.text()
            browseNodeId = urlModule.parse(@.attr('href'))?.path?.split('/')[4]
            if "#{Number browseNodeId}" is browseNodeId
              browseNodeIds.push browseNodeId
          categories.push categoryTree

        details.categories = categories
        details.browseNodeIds = _.uniq browseNodeIds

      features = []
      $('#featurebullets_feature_div #feature-bullets ul li').each ->
        splitedFeatures = @.text().split ';'
        for feature in splitedFeatures
          features.push feature.replace /^\s+|\s+$/g, ''

      imageUrls = []
      $('#altImages .item img').each (index, element) ->
        imageUrl = @.attr('src')
        return  if not imageUrl? or imageUrl?.search(/video/) > -1

        imageUrl = imageUrl.replace /._SS40_/, ''
        imageUrls.push imageUrl

      videoIds = []
      videoStrings = body.match /\"isVideo\":1,\"mediaObjectId\":(.*?)",/g
      if videoStrings?
        for videoString in videoStrings
          videoStringTokens = videoString.split '\"'
          videoIds.push videoStringTokens?[5]  if videoStringTokens?[5]?

      async.map videoIds
      ,
        (videoId, callback) ->
          request
            url: "http://www.amazon.com/gp/mpd/getplaylist-v2/#{videoId}/"
          ,
            (err, videoResp, videoXml) ->
              videoDoc = cheerio.load videoXml
              videos = videoDoc('video').attr 'src'
              callback err, videos
      ,
        (err, videoUrls) ->
          videoUrls = []  if not videoUrls?

          productDetail =
            name: $('#title').text().replace /^\s+|\s+$/g, ''
            brand: $('#brand').text().replace /^\s+|\s+$/g, ''
            salePrice: $('#priceblock_ourprice').text().replace /[^0-9\.]+/g, ''
            shippingMessage: shippingMessage
            availability: $('#availability').text().replace /^\s+|\s+$/g, ''
            features: features
            details: details
            imageUrls: imageUrls
            videoUrls: videoUrls
          
          callback null, productDetail



module.exports = ProductDetailPage
