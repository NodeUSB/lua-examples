     local pKey="fe3895b19831e7c06333a7f11676c949"
     local host="nusensor.appspot.com"

     local m = node.heap()
     print(m)

     -- ESP-01 GPIO Mapping
     local gpio0 = 3
     local gpio2 = 4

     local bmp=require("bmp085")
     bmp.init(3,4)

     if pcall(function () t=bmp.getUT() ap=bmp.getUP() end) then
          print(t.."\n"..ap.."\n")
     else
          print("Error reading from BMP085")
          return
     end

     -- release module
     bmp = nil
     bmp085 = nil
     package.loaded["bmp085"]=nil

     collectgarbage()
     --print(node.heap()) -- 16480
     
     --PostData = string.format([[k=%s&t=%s&a=%s&ip=%s]],pKey,temp,ap,wifi.sta.getip())
     local myip = wifi.sta.getip()
     local mac = wifi.sta.getmac()
     local wifi = nil
     
     local PostData = string.format([[s=bmp085&t=%s&h=%s&ip=%s&m=%s&mac=%s&k=%s]],t,ap,myip,m,mac,pKey)
     m=nil
     t=nil
     h=nil
     myip=nil
     mac=nil
     --PostData = nil
     pKey = nil
     --host=nil
     collectgarbage()
     --print(node.heap())

     print(PostData)
     local pr = require("postrun")
     pr.post(host,PostData)
     host=nil
     strPost = nil
     pr = nil
     postrun=nil
     package.loaded["postrun"]=nil
     tmr.alarm(2,2000,0,function() collectgarbage() print(node.heap()) end)
     