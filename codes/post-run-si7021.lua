     local pKey="fe3895b19831e7c06333a7f11676c949"
     local host="nusensor.appspot.com"

     local m = node.heap()
     print(m)

     -- ESP-01 GPIO Mapping
     local gpio0 = 3
     local gpio2 = 4
     
     gpio.mode(gpio0, gpio.OUTPUT, gpio.PULLUP)
     --gpio.mode(gpio2, gpio.OUTPUT, gpio.PULLUP)

     local si=require("si7021")
     si.init(gpio0,gpio2)
     si7021.read(OSS)
     
     if pcall(function () it=si7021.getTemperature() ih=si7021.getHumidity() end) then
          --print("Temperature: "..(t/100).."."..(t%100).." deg C")
          --print("Humidity: "..(h / 100).."."..(h % 100).." %")
          t = string.format([[%s.%s]],(it/100),(it%100))
          h = string.format([[%s.%s]],(ih/100),(ih%100))
          --print((t/100).."\n"..(h/100).."\n")
     else
          print("Error reading from si7021")
          return
     end

     -- release module
     si = nil
     si7021 = nil
     package.loaded["si7021"]=nil

     gpio.write(gpio0, gpio.HIGH)
     
     collectgarbage()
     --print(node.heap()) -- 16480
     
     --PostData = string.format([[k=%s&t=%s&a=%s&ip=%s]],pKey,temp,ap,wifi.sta.getip())
     local myip = wifi.sta.getip()
     local mac = wifi.sta.getmac()
     local wifi = nil
     
     local PostData = string.format([[s=si7021&t=%s&h=%s&ip=%s&m=%s&mac=%s&k=%s]],t,h,myip,m,mac,pKey)
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