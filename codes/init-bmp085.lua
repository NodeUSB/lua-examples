

local pKey="xxxxxxxx"
local host="nusensor.appspot.com"
-- Use bmp180 with NodeUSB, connect to USB connector with GND, goio13, gpio12, gpio14
local gpio0 = 3
local gpio2 = 4
local gpio4 = 2
--local gpio12 = 6
local GPIO12 = 6
local GPIO13 = 7
local GPIO14 = 5

--Use GPIO13 to provide power for bmp180, si7021
gpio.mode(GPIO13, gpio.OUTPUT)
gpio.write(GPIO13, gpio.HIGH)

--i = 0
j = 0

tmr.alarm(1,5000,1,function()
     collectgarbage()

     ip = wifi.sta.getip()
     if(ip==nil) then
          print("WiFi down")
          j = j + 1
     else
          j = 0

          local m = node.heap()
          print(m)

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

          local PostData = string.format([[s=bmp085&t=%s&h=%s&ip=%s&m=%s&mac=%s&k=%s]],sT,sAP,ip,m,mac,pKey)
          print(PostData)
          m=nil
          sT=nil
          sAP=nil
          --myip=nil
          mac=nil
          --PostData = nil
          collectgarbage()
          print(node.heap())

          local pr = require("postrun")
          pr.post(host,PostData)
          --pr = nil
          --postrun=nil
          --package.loaded["postrun"]=nil
          tmr.alarm(2,3000,0,function() pr=nil postrun=nil package.loaded["postrun"]=nil collectgarbage() print(node.heap()) end)

     end

     collectgarbage()
     print(node.heap())
     --print(i..","..node.heap())
     --i = i + 1
end)
