# Description:
#   Messing around with the YouTube API.
#
# Commands:
#   hubot salonstaff revenue - Shows the current months revenue so far

monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
d = new Date();

module.exports = (robot) ->

  robot.respond /.*/i, (msg) ->
    msg.send msg

  robot.respond /(salonstaff)( revenue)/i, (msg) ->
    msg.http("http://www.salonstaff.com.au/panic/profit_graph")
      .get() (err, res, body) ->
        data = JSON.parse(body)
        seqs = data.graph.datasequences

        thisyear = seqs[seqs.length-1]
        thisyear = thisyear.datapoints

        thisyear.forEach (month) ->
          if month.title is monthNames[d.getMonth()]
            msg.send "$" + month.value