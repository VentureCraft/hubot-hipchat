# Description:
#   Messing around with the YouTube API.
#
# Commands:
#   revenue? - Shows the current months revenue so far

monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
d = new Date();

welcome_messages = [
  "oh hello mister",
  "glad you could join us",
  "well it if isn't"
  "sup",
  "hey",
  "welcome back",
  "hows tricks"
  "hey everyone... look... it's"
]

module.exports = (robot) ->

#  robot.leave (msg) ->
#    msg.send "Bye bye #{msg.message.user.name}, I'll miss you :("

## Send digest directly to person who joined with revenue and welcome them to the room
#  robot.enter (response) ->
#    if response.message.user.mention_name is "betty"
#      return
#    randIndex = Math.floor((Math.random()*welcome_messages.length)+1)
#    robot.messageRoom(response.message.room, "#{welcome_messages[randIndex - 1]} #{response.message.user.mention_name}")
#    if response.message.room is "51042_salon_staff@conf.hipchat.com"
#      robot.emit("showRevenue", response)
#      robot.pm(response.message.user, "oh hello mister #{response.message.user.mention_name}")

  robot.hear /(revenue\?)/i, (msg) ->
    robot.emit("showRevenue", msg)

  robot.hear /(thanks betty\)/i, (msg) ->
    msg.send("you're welcome")

  robot.on "showRevenue", (msg) ->
    msg.http("http://www.salonstaff.com.au/panic/profit_graph")
      .get() (err, res, body) ->
        data = JSON.parse(body)
        seqs = data.graph.datasequences

        thisyear = seqs[seqs.length-1]
        thisyear = thisyear.datapoints

        thisyear.forEach (month) ->
          if month.title is monthNames[d.getMonth()]
            robot.pm(msg.message.user, "$" + month.value + " so far this " + month.title)
