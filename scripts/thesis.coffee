# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

module.exports = (robot) ->
  deadlineIntervalId = null
  deadline = new Date()
  deadline.setDate(18)
  deadline.setMonth(7)
  deadline.setFullYear(2014)
  deadline.setUTCHours(14)
  deadline.setMinutes(0)
  dayDurationMilli = 24 * 3600 * 1000
  hourDurationMilli = 3600 * 1000
  minuteDurationMilli = 60 * 1000

  printTimeBeforeDeadline = (msg) ->
    now = new Date()
    durationBeforeDeadline = deadline.getTime() - now.getTime()
    if durationBeforeDeadline > 0
      nbOfDays = durationBeforeDeadline / dayDurationMilli
      nbOfHours = (durationBeforeDeadline % dayDurationMilli) / hourDurationMilli
      nbOfMinutes = (durationBeforeDeadline % hourDurationMilli) / minuteDurationMilli
      nbOfSeconds = (durationBeforeDeadline % minuteDurationMilli) / 1000
      msg.send("Ok guys, " + (nbOfDays | 0) + " days, " + (nbOfHours | 0) + " hours, " + (nbOfMinutes | 0) + " minutes and " + (nbOfSeconds | 0) + " seconds left, good luck")
    else
      msg.send "Thesis is over, YIIIIIHHAAAAA!!!"
      clearInterval(deadlineIntervalId)
      deadlineIntervalId = null

  robot.respond /start thesis countdown/, (msg) ->
    if deadlineIntervalId != null
      msg.send "It's already running"
      return

    msg.send "Ok, I do that"
    printTimeBeforeDeadline(msg)
    deadlineIntervalId = setInterval() ->
      printTimeBeforeDeadline(msg)
    , dayDurationMilli

  robot.respond /stop thesis countdown/, (msg) ->
    msg.send "Ok, I stop that"
    clearInterval(deadlineIntervalId)
    deadlineIntervalId = null

  robot.respond /how much time for our thesis\?/, (msg) ->
    printTimeBeforeDeadline(msg)
