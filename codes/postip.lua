local localip=wifi.sta.getip()
local mac = wifi.sta.getmac()

host="i.nodeusb.com"

if (localip) then
     --local strPost = "GET /a?ip="..localip.."&mac="..mac.." HTTP/1.1\r\nHost: "..host.."\r\nAccept: */*\r\n\r\n"
     local strPost = "GET /a?ip="..localip.."&mac="..mac.." HTTP/1.1\r\nHost: "..host.."\r\n\r\n"
     --print(strPost)
     
     local sk=net.createConnection(net.TCP, 0)

     sk:on("connection", function(sck) sk:send(strPost) end)

     sk:on("receive", function(sck, res) print(res) res=nil collectgarbage() end)

     sk:dns(host,function(conn,ip) sk:connect(80,ip) print(ip) collectgarbage() end)

     tmr.alarm(5,2000,0,function() sk:close() sk=nil strPost = nil collectgarbage() end)
else
     return
end
