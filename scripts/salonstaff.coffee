# Description:
#   Messing around with the YouTube API.
#
# Commands:
#   hubot salonstaff revenue - Shows the current months revenue so far
module.exports = (robot) ->
  robot.respond /(salonstaff)( revenue)/i, (msg) ->
    msg.http("http://www.salonstaff.com.au/panic/profit_graph")
      .get() (err, res, body) ->
        data = JSON.parse(body)
        seqs = data.graph.datasequences

        thisyear = seqs[seqs.length-1]
        thisyear = thisyear.datapoints

        thismonth = thisyear[thisyear.length-1]

        msg.send thismonth.value
