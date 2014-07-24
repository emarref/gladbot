# Description
#   Find when the next Basketball game is.
#
# Dependencies:
#   "cheerio": "https://github.com/cheeriojs/cheerio"
#
# Configuration:
#   BASKETBALL_TEAM_HOME_URL
#   BASKETBALL_TEAM_NAME
#
# Commands:
#   hubot when is basketball? - retrieves the date and time of the next game
#
# Notes:
#   None
#
# Author:
#   emarref

http = require 'http'
cheerio = require 'cheerio'
util = require 'util'

module.exports = (robot) ->

  teamName = process.env.BASKETBALL_TEAM_NAME
  homeUrl  = process.env.BASKETBALL_TEAM_HOME_URL

  getPage = (msg, callback) ->
    msg.http(homeUrl).get() (err, res, body) ->
      callback cheerio.load(body);

  robot.respond /last b(asket)?ball game/i, (msg) ->
    getPage msg, ($) ->
      resultRows = $('td.resultrow', '#teamhome-last5-wrap')
      winnerRow  = $('td.winner', '#teamhome-last5-wrap')
      date       = resultRows.eq(0).text().trim()
      opponent   = resultRows.eq(2).text().trim()
      score1     = resultRows.eq(3).text().trim()
      score2     = resultRows.eq(5).text().trim()
      winLose    = if winnerRow.text() == 'W' then 'won' else 'lost'
      msg.send "#{teamName} #{winLose} #{score1}-#{score2} against #{opponent} on #{date} #{homeUrl}"
