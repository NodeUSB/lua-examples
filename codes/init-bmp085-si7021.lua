local pKey="xxxxxxxxxx"
local host="nusensor.appspot.com"

local m = node.heap()
--local gpio0 = 3
--local gpio2 = 4
--local gpio4 = 2

local GPIO12 = 6
local GPIO13 = 7
local GPIO14 = 5

--Use GPIO13 to provide power for bmp180, si7021
gpio.mode(GPIO13, gpio.OUTPUT)
gpio.write(GPIO13, gpio.HIGH)

i=0
tmr.alarm(1,5000,1,function()

  local ip = wifi.sta.getip()
  if(ip==nil) then
       print("Offline")
  else
     local si=require("si7021")
     si.init(GPIO14,GPIO12)
     si7021.read(OSS)

     if pcall(function () it=si7021.getTemperature() ih=si7021.getHumidity() end) then
          t = string.format([[%s]],(it/100)):sub(0,5)
          h = string.format([[%s]],(ih/100)):sub(0,5)
     else
          print("Error reading from si7021")
          return
     end

     -- release module
     si = nil
     si7021 = nil
     package.loaded["si7021"]=nil
     --gpio.write(gpio4, gpio.LOW)

     collectgarbage()

     local bmp=require("bmp085")
     bmp.init(GPIO14,GPIO12)

     if pcall(function () tb=bmp.getUT() ap=bmp.getUP() end) then
          sT=string.format([[%s]],tb):sub(0,5)
          sAP=string.format([[%s]],ap):sub(0,5)
          print(sT.."\n"..sAP.."\n")
     else
          print("Error reading from BMP085")
          return
     end

     -- release module
     bmp = nil
     bmp085 = nil
     package.loaded["bmp085"]=nil

     collectgarbage()

     local mac = wifi.sta.getmac()
     local wifi = nil

     local bPostData = string.format([[s=bmp085&t=%s&h=%s&ip=%s&m=%s&mac=%s&k=%s]],sT,sAP,ip,m,mac,pKey)
     local sPostData = string.format([[s=si7021&t=%s&h=%s&ip=%s&m=%s&mac=%s&k=%s]],t,h,ip,m,mac,pKey)

     m=nil
     t=nil
     h=nil
     sT=nil
     sAP=nil
     mac=nil
     pKey = nil
     collectgarbage()
     --print(node.heap())
     print(sPostData)

     local pr = require("postrun")
     pr.post(host,bPostData)
     pr.post(host,sPostData)
     host=nil
     strPost = nil
     pr = nil
     postrun=nil
     package.loaded["postrun"]=nil
     tmr.alarm(2,2000,0,function() collectgarbage() print(node.heap()) end)
  end

  collectgarbage()
  print(i..","..node.heap())
  i = i + 1

end)
