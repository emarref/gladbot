# Description
#   Find when the next Basketball game is.
#
# Dependencies:
#   "cheerio": "https://github.com/cheeriojs/cheerio"
#
# Configuration:
#   BASKETBALL_URL
#   BASKETBALL_TEAM_NAME
#
# Commands:
#   hubot when is the next basketball game? - retrieves the date and time of the next game
#
# Notes:
#   None
#
# Author:
#   jinthagerman

Cheerio = require 'cheerio'
Entities = require('html-entities').AllHtmlEntities;

URL = process.env.BASKETBALL_URL
teamName = process.env.BASKETBALL_TEAM_NAME

module.exports = (robot) ->

  robot.respond /when( i|')s basketball/i, (msg) ->
    msg.http(URL)
    .get() (err, res, body) ->
      $ = Cheerio.load body

      return if findGameTime msg, $, 'away-team-name'
      return if findGameTime msg, $, 'home-team-name'

      msg.send 'No game found'

findGameTime = (msg, $, className) ->
  found = false

  # Find divs with className
  $("div[class=#{ className }]").each (i, elem) ->

    # Get text within a tag
    name = $(this).find('a').text()

    return unless name is teamName

    # Look for ancestor with fixturerow as class
    fixtureRow = $(this).closest 'div[class*=fixturerow]'
    return unless fixtureRow?

    # Find match-time div
    matchTime = fixtureRow.find 'div[class=match-time]'
    return unless matchTime?

    entities = new Entities();
    # Post search results
    msg.send 'Next game is at ' + entities.decode(matchTime.html())
    found = true
    return false # Break each loop early

  return found
