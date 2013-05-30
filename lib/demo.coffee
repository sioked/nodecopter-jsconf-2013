arDrone = require "ar-drone"
http = require "http"

client = arDrone.createClient()

client.takeoff()

client
  # .after 5000, ->
  #   @clockwise 0.2
  # .after 3000, ->
  #   @stop()
  .after 3000, ->
    @front 0.1
  .after 7000, ->
    @stop()
  # .after 3000, ->
  #   @counterClockwise 0.2
  .after 3000, ->
    @stop()
  .after 10000, ->  
    @land()

client.on 'navdata', (data) ->
  console.log data.visionDetect

pngStream = client.getPngStream()

server = http.createServer()