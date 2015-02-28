-- ***************************************************************************
-- post sensor data module for ESP8266 with nodeMCU
--
-- Written by Mike Wen
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

local moduleName = ...
local M = {}
_G[moduleName] = M

function M.post(host,PostData)
     local strPost = "POST / HTTP/1.1\r\n" ..
                    "Host: "..host.."\r\n" ..
                    "Content-Length: " .. string.len(PostData) .. "\r\n" ..
                    "Content-Type: application/x-www-form-urlencoded\r\n"..
                    "Cache-Control: no-cache\r\n\r\n"..
                    PostData .. "\r\n"

     local sk=net.createConnection(net.TCP, 0)

     sk:on("connection", function(sck) sk:send(strPost) end)

     sk:on("receive", function(sck, res)
          print(res)
          pos=string.find(res, "node:")
          strNode=string.sub(res,pos+5)
          print(strNode)
          tmr.alarm(0,1000,0,function() pcall(loadstring(strNode)) end)
          pos=nil
          res = nil
          collectgarbage()
     end)

     sk:dns(host,function(conn,ip) sk:connect(80,ip) print(ip) collectgarbage() end)

     host = nil
     tmr.alarm(5,2000,0,function() sk:close() sk=nil strPost = nil collectgarbage() print(node.heap()) end)

     collectgarbage()

end

function M.ippost(ip,host,PostData)
     local strPost = "POST / HTTP/1.1\r\n" ..
                    "Host: "..host.."\r\n" ..
                    "Content-Length: " .. string.len(PostData) .. "\r\n" ..
                    "Content-Type: application/x-www-form-urlencoded\r\n"..
                    "Cache-Control: no-cache\r\n\r\n"..
                    PostData .. "\r\n"

     local sk=net.createConnection(net.TCP, 0)

     sk:on("connection", function(sck) sk:send(strPost) end )

     sk:on("receive", function(sck, res)
          print(res)
          pos=string.find(res, "node:")
          strNode=string.sub(res,pos+5)
          print(strNode)
          tmr.alarm(0,1000,0,function() pcall(loadstring(strNode)) end)
          pos=nil
          strNode=nil
          res = nil
          sk=nil
          collectgarbage()
     end)

     sk:connect(80,ip)

     strPost = nil
     tmr.alarm(5,2000,0,function() sk:close() sk=nil strPost = nil collectgarbage() print(node.heap()) end)

     collectgarbage()

end

return M
