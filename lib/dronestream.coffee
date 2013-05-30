http = require("http")
dronestream = require("dronestream")

template = '

<!doctype html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <title>Stream as module</title>
    <script src="/dronestream/nodecopter-client.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
    <h1 id="heading">Stream through a normal require("http").createServer</h1>
    <div id="droneStream" style="width: 640px; height: 360px">   </div>

    <script type="text/javascript" charset="utf-8">
        new NodecopterStream(document.getElementById("droneStream"));
    </script>
</body>
</html>

'

server = http.createServer (req, res) ->
  res.writeHead 200, 'Content-Type': 'text/html'
  res.end template

server.listen 1337, "127.0.0.1"

dronestream.listen server