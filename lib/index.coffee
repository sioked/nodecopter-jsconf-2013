drone = require "ar-drone"
client = drone.createClient()

client.takeoff()
client
  .after 5000, ->
    @.clockwise 0.5
  .after 3000, ->
    @.stop()
    @.land()