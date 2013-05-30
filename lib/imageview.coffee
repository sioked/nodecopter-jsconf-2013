fs = require 'fs'
http = require("http")
# dronestream = require("dronestream")

template = '

<!doctype html>
<html>
<head>

</head>
<body>
    
    <img id="recent" src=""/>
    <img id="processed" src=""/>

    <script type="text/javascript" charset="utf-8">
        setInterval(function() {
            document.getElementById("recent").src = "/recent.png?r="+Math.random();
            document.getElementById("processed").src = "/processed.png?r="+Math.random();
        }, 500);
    </script>
</body>
</html>

'

server = http.createServer (req, res) ->

  if req.url.match '/recent.png'
    res.writeHead 200, 'Content-Type': 'image/png'
    fs.createReadStream('assets/recent.png').pipe res

  else if req.url.match '/processed.png'
    res.writeHead 200, 'Content-Type': 'image/png'
    fs.createReadStream('assets/processed.png').pipe res
  
  else
    res.writeHead 200, 'Content-Type': 'text/html'
    res.end template

server.listen 1337, "127.0.0.1"