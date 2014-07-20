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
  running = false
  deadline = new Date()
  deadline.setDate(15, 7, 2014)
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
      msg.send "Ok guys, " + nbOfDays + " days, " + nbOfHours + " hours, " + nbOfMinutes + " minutes and " + nbOfSeconds + "seconds left, good luck"
    else
      msg.send "Thesis is over, YIIIIIHHAAAAA!!!"
      clearInterval(deadlineIntervalId)
      running = false

  robot.respond /start thesis countdown/, (msg) ->
    if running
      msg.send "It's already running"
      return

    running = true
    msg.send "Ok, I do that"
    printTimeBeforeDeadline(msg)
    deadlineIntervalId = setInterval() ->
      printTimeBeforeDeadline(msg)
    , dayDurationMilli

  robot.respond /stop thesis countdown/, (msg) ->
    running = false
    clearInterval(deadlineIntervalId)
