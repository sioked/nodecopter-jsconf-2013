cv = require "opencv"

lower_threshold = [0,0,200]
upper_threshold = [255,255,255]
targetWidth = 8
targetHeight = 5

cv.readImage '../assets/1.png', (err, img) ->
  img.inRange lower_threshold, upper_threshold
  # img.save "../assets/1_updated.png"
  console.log "Number of channels: "
  console.log img.channels()
  img.resize targetWidth, targetHeight
  img.save "../assets/1_updated.png"

  console.log "Split"
  console.log img.split()
  console.log img

  for row in [0...img.height()]
    line = img.pixelRow(row)
    # .map (val) ->
    #   v = Math.round(val)
    #   if v == 0
    #     return 0
    #   if v > 1
    #     return 1
    #   return -1
    console.log line.length
    console.log line.join(",")

  console.log img.get(0,0)

  console.log img.get(0,6)
