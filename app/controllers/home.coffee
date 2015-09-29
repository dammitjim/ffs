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
      $ = cheerio.load(html)
      author = ''
      title = ''
      if $('.storytext').length > 0
        if $('#profile_top').length > 0
          $('#profile_top').filter ->
            links = $(this).find('a')
            profile = links[0]
            author = profile.children[0].data
            title = $(this).find('b')[0].children[0].data
        $('.storytext').filter ->
          story = htmltotext.fromString($(this).html());
          title = title + " - " + author
          res.set {"Content-Disposition":"attachment; filename=\"" + title + "\""}
          res.send story
      else if $('.storycontent').length > 0
        if $('#content').length > 0
          $('#content div:first-child').filter ->
            links = $(this).find('a')
            profile = links[0]
            author = profile.children[0].data
            title = $(this).find('b')[0].children[0].data
        $('.storycontent').filter ->
          story = htmltotext.fromString($(this).html());
          title = title + " - " + author
          res.set {"Content-Disposition":"attachment; filename=\"" + title + "\""}
          res.send story
      else
        res.render 'index', { error: "Invalid page submitted" }
    else
      res.render 'index', { error: "No page submitted" }
