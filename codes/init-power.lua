
local pKey="xxxxxxxxxxxxxxxxxxx"  --replace with Access token
local host="asnodes.appspot.com"

local pr = require("postrun")

i = 0
j = 0

tmr.alarm(1,8000,1,function()

  local ip = wifi.sta.getip()
  if(ip==nil) then
       print("Down")
       if(j>=3) and (i>4) then
            print("Reset")
            node.restart()
       end
       j = j + 1
  else
       j = 0
       --connected to WiFi, send sensor data, then run code from server
     local m = node.heap()
     local mac = wifi.sta.getmac()

      --server can return lua code to turn off LED, etc
     local sPostData = string.format([[a=led&ip=%s&m=%s&mac=%s&at=%s]],ip,m,mac,pKey)

     print(sPostData)
     pr.post(host,sPostData)

  end

  print(i..","..node.heap())
  i = i + 1

end)
