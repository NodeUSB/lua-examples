local pKey="fe3895b19831e7c06333a7f11676c949"
local host="nusensor.appspot.com"

local m = node.heap()

local t = require("ds18b20")

-- ESP-01 GPIO Mapping
local gpio0 = 3
local gpio2 = 4

gpio.mode(gpio0, gpio.OUTPUT, gpio.PULLUP)

t.setup(gpio2)

local addrs = t.addrs()
if (addrs ~= nil) then
  print("Total DS18B20 sensors: "..table.getn(addrs))
end
-- Just read temperature
local temp = t.read()
--print(node.heap())

-- Don't forget to release it after use
t = nil
ds18b20 = nil
package.loaded["ds18b20"]=nil

gpio.write(gpio0, gpio.HIGH)

collectgarbage()
print(node.heap()) -- 16480

mac = wifi.sta.getmac()
if(myip==nil) then
     myip = wifi.sta.getip()
     wifi = nil
end
local PostData = string.format([[s=ds18b20&t=%s&ip=%s&m=%s&mac=%s&k=%s]],temp,myip,m,mac,pKey)
print(PostData)

print(node.heap()) -- 16320

local sk=net.createConnection(net.TCP, 0)    --"connection", "reconnection", "disconnection", "receive", "sent"
local strPost = "POST / HTTP/1.1\r\n" ..
               "Host: "..host.."\r\n" ..
               "Content-Length: " .. string.len(PostData) .. "\r\n" ..
               "Content-Type: application/x-www-form-urlencoded\r\n"..
               "Cache-Control: no-cache\r\n\r\n"..
               PostData .. "\r\n"

--sk:on("connection", function(sk) sk:send(strPost) end )

sk:dns(host,function(conn,ip) sk:connect(80,ip) print(ip) end)
sk:send(strPost)

sk:on("receive", function(sck, res) 
     pos=string.find(res, "node:")
     --last=string.find(res,"0",pos+5)
     --strNode=string.sub(res,pos+5,last-1)
     strNode=string.sub(res,pos+5)
     print(strNode)
     --node.input(strNode)
     tmr.alarm(0,1000,1,function() pcall(loadstring(strNode)) end)
     res = nil
     sk:close()
     sk=nil
end)
--sk:close()
--sk=nil
m=nil
temp=nil
myip=nil
mac=nil
PostData = nil
strPost = nil
string=nil
net=nil
collectgarbage()
print(node.heap()) --14136
