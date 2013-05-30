cv = require "opencv"
arDrone = require "ar-drone"
http = require "http"

client = arDrone.createClient()
client.config "video:video_channel", 3
client.takeoff()
client.stop()
client.land()
targetWidth = 16
targetHeight = 9

lower_threshold = [0,0,200]
upper_threshold = [255,255,255]

pngStream = client.getPngStream()
pngStream.on 'data', (pngBuffer) ->
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
        pixelRow.push pix if i < targetWidth
      rows.push pixelRow

    if rows[0][0] is 255
      # go left
      client.stop()
      client.counterClockwise(0.1)

    if rows[0][targetWidth] is 255
      # go right
      client.stop()
      client.counterClockwise(0.1)

    if rows[0][Math.round(targetWidth/2)] is 255
      client.stop()
      client.front(0.1)
