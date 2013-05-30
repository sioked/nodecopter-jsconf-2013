cv = require "opencv"
arDrone = require "ar-drone"
http = require "http"

client = arDrone.createClient()
client.config "video:video_channel", 3
# client.takeoff()
# client.stop()
# client.land()


lower_threshold = [0,0,200]
upper_threshold = [255,255,255]

pngStream = client.getPngStream()
pngStream.on 'data', (pngBuffer) ->
  # console.log "Got data"
  cv.readImage pngBuffer, (err, img) ->
    img.save "assets/recent.png"
    img.inRange lower_threshold, upper_threshold
    img.save "assets/processed.png"