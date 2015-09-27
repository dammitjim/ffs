express  = require 'express'
request = require 'request'
cheerio = require 'cheerio'
htmltotext = require 'html-to-text'
fs = require 'fs'
router = express.Router()

module.exports = (app) ->
  app.use '/', router

router.get '/', (req, res, next) ->
    res.render 'index'

router.post '/', (req, res, next) ->
  url = req.body.url
  request url, (error, response, html) ->
    if !error
      console.log response
      $ = cheerio.load(html)
      $('.storytext').filter ->
        story = htmltotext.fromString($(this).html());
        res.set {"Content-Disposition":"attachment; filename=\"story.txt\""}
        res.send story
    else
      console.log "something went wrong"
