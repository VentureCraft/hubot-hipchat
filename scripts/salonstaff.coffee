# Description:
#   Messing around with the YouTube API.
#
# Commands:
#   revenue? - Shows the current months revenue so far
#   xero overdue - Sync overdue invoices with seek
#   cm sync - Syncs the campaign monitor salon owners list
#   seek sync - Sync jobs with seek
#   zendesk sync - Syncs new zendesk accounts
#   intercom sync - Syncs all users with intercom

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

youre_welcome_messages = [
  "that's ok",
  "pfffft, it was nothing",
  "my pleasure",
  "no, thank you",
  "boobs",
  "get back to work",
  "all in a days work",
  "damn right"
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


  robot.hear "seek sync", (msg) ->
    msg.send("Syncing seek jobs...")
    msg.http("http://www.salonstaff.com.au/cron/seek/fastlane").get() (err, res, body) ->
      msg.send('Sync complete')

  robot.hear "xero overdue", (msg) ->
    msg.send("Finding overdue invoices from xero...")
    msg.http("http://www.salonstaff.com.au/cron/xerocron/findoverdue").get() (err, res, body) ->
      msg.send('Overdue invoices updated')

  robot.hear "cm sync", (msg) ->
    msg.send("Syncing campaign monitor salon owners list...")
    msg.http("http://www.salonstaff.com.au/cron/cron/update_campaign_monitor").get() (err, res, body) ->
      msg.send('Sync complete')

  robot.hear "intercom sync", (msg) ->
    msg.send("Syncing intercom...")
    msg.http("http://www.salonstaff.com.au/cron/cron/update_intercom").get() (err, res, body) ->
      msg.send('Sync complete')

  robot.hear "zendesk sync", (msg) ->
    msg.send("Sycing accounts with zendesk...")
    msg.http("http://www.salonstaff.com.au/cron/zendeskcron/synk").get() (err, res, body) ->
      msg.send('Sync complete')




  robot.hear /(revenue\?)/i, (msg) ->
    robot.emit("showRevenue", msg)


  robot.hear /(thanks betty)/i, (msg) ->
    randIndex = Math.floor((Math.random()*welcome_messages.length)+1)
    msg.send "#{youre_welcome_messages[randIndex - 1]} #{msg.message.user.mention_name}"


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
