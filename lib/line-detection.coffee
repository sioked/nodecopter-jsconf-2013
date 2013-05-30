cv = require "opencv"
arDrone = require "ar-drone"
http = require "http"
_ = require "underscore"

client = arDrone.createClient()
client.config "video:video_channel", 3
if client.battery < 30
  console.log "LOW BATTERY!!!!!"
  console.log client.battery
client.takeoff()
# client
#   .after 1000, ->
#     @.up(0.35)
#   .after 3000, ->
#     @stop()

targetWidth = 16
targetHeight = 9

lower_threshold = [0,0,200]
upper_threshold = [255,255,255]
prevDirection = "left"

calculateLineRatio = (row) ->
  pos1 = row.indexOf(1)
  pos2 = row.lastIndexOf(1)
  pos = (pos1 + pos2) / 2
  pos = -1 if pos1 is -1
  ratio = pos/(targetWidth-1)


mainLoop = (pngBuffer) ->
  client.stop()
  # console.log "Got data"
  cv.readImage pngBuffer, (err, img) ->
    img.save "assets/recent.png"
    img.inRange lower_threshold, upper_threshold
    img.resize targetWidth, targetHeight
    img.save "assets/processed.png"
    console.log "   "
    rows = []
    for row in [0...targetHeight]
      pixelRow = []
      for pix, i in (img.pixelRow row)
        if i < targetWidth
          val = Math.round(pix/255)
          pixelRow.push val

      rows.push pixelRow

    console.log rows
    firstRatio = calculateLineRatio(rows[0])
    lastRatio = calculateLineRatio(rows[targetHeight-1])
    console.log "Ratio is #{firstRatio}"


    path = firstRatio - lastRatio
    console.log "Path is #{path}"

    if (firstRatio < 0)
      #We're lost, where the fuck are we?
      console.log "WHERE THE FUCK ARE WE?"
      # client.clockwise(0.1)
      if prevDirection is "right"
        client.counterClockwise(0.1)
      if prevDirection is "left"
        client.clockwise(0.1)

    else if (firstRatio > 0) and (lastRatio < 0)
      #Move up a bit- I think we're at the start of the line
      client.front(0.05)

    else if path > 0
      # rotate right
      console.log "ROTATE RIGHT"
      client.clockwise(0.1)
      # client.front(0.05)
      prevDirection = "right"

    else if path < 0
      # rotate left
      console.log "ROTATE LEFT"
      client.counterClockwise(0.1)
      # client.front(0.05)
      prevDirection = "left"

    else if firstRatio < 0.3
      # move left
      console.log "MOVE LEFT"
      client.left(0.02)

    else if firstRatio > 0.7
      console.log "MOVE RIGHT"
      client.right(0.02)

    else if -0.1 < path < 0.1
      console.log "SWEET SPOT!"
      client.front(0.1)

    else
      console.log "Oh noes!"

client.after 1000, ->
  pngStream = client.getPngStream()
  pngStream.on 'data', mainLoop

# client.after 60000, ->
#   @stop()
#   @land()

process.on "SIGINT", ->
  client.stop()
  client.land()
  process.exit(0)