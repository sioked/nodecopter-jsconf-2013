cv = require "opencv"

lower_threshold = [0,0,200]
upper_threshold = [255,255,255]

cv.readImage '../assets/1.png', (err, img) ->
  img.inRange lower_threshold, upper_threshold
  img.save "../assets/1_updated.png"