request = require 'request'
cheerio = require 'cheerio'


class Page
  #### default options for load a web-page.
  defaultOptions:
    headers:
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
      'Accept-Language': 'en-US,en;q=0.8'
      'Cache-Control': 'no-cache'
      'Connection': 'keep-alive'
      'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'


  #### load and parse the page.
  # `options` must have `url`.
  constructor: (@options, callback) ->
    return callback new Error 'no url.'  if not options.url?

    for k, v of @defaultOptions
      options[k] = v  if not options[k]?

    request options, (err, response, body) =>
      return callback err  if err?

      if response?.statusCode isnt 200
        return callback new Error "#{response.statusCode} - #{body}"

      @$ = cheerio.load body
      callback null, @$



module.exports = Page
