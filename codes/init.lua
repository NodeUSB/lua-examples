i = 0
j = 0

tmr.alarm(1,3000,1,function()

  local ip = wifi.sta.getip()
  if(ip==nil) then
       print("Offline")
       if(j>=20) and (i>100) then
            print("rebooting")
            -- relay on, off
            --node.restart()
       end
       j = j + 1
  else
       j = 0
       dofile("postip.lc")
       
       ip=nil
       tmr.stop(1)

       --dofile("telnet.lua")
       tmr.alarm(0,6000,0,function() dofile("mide.lc") end)

       tmr.alarm(2,1000,0,function() collectgarbage("collect") end)
  end

  --print(i..","..node.heap())
  i = i + 1

end)
