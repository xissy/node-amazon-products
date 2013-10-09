should = require 'should'

Page = require '../../lib/page/Page'


describe 'Page', ->
  describe 'constructor(...)', ->
    it 'should be done', (done) ->
      page = new Page
        url: 'http://www.google.com'
      ,
        (err, $) ->
          should.not.exist err
          should.exist $
          done()

    it 'should be `no url.` error', (done) ->
      page = new Page {}, (err, $) ->
        should.exist err
        done()
