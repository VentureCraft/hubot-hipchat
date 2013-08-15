# Description:
#   Messing around with the YouTube API.
#
# Commands:
#   hubot salonstaff revenue - Shows the current months revenue so far

monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
d = new Date();

module.exports = (robot) ->

#  robot.leave (msg) ->
#    msg.send "Bye bye #{msg.message.user.name}, I'll miss you :("

  robot.enter (response) ->
    response.reply "oh hello mister #{response.message.user.mention_name}"
    response.reply "1 " + response.room
    response.reply "2 " + response.message.room
    response.reply "3 " + response.message.user.room
    robot.emit("showRevenue", response)

  robot.respond /(salonstaff)( revenue)/i, (msg) ->
    robot.emit("showRevenue", msg)


  robot.on "showRevenue", (msg) ->
    msg.http("http://www.salonstaff.com.au/panic/profit_graph")
      .get() (err, res, body) ->
        data = JSON.parse(body)
        seqs = data.graph.datasequences

        thisyear = seqs[seqs.length-1]
        thisyear = thisyear.datapoints

        thisyear.forEach (month) ->
          if month.title is monthNames[d.getMonth()]
            msg.reply "$" + month.value + " so far this " + month.title
