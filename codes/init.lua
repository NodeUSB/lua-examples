
tmr.alarm(1,3000,1,function()

  local ip = wifi.sta.getip()
  if(ip==nil) then
       print("Offline")
  else
       require("d").r(ip,wifi.sta.getmac())

       ip=nil
       tmr.stop(1)

       tmr.alarm(0,6000,0,function() dofile("i.lc") end)

       tmr.alarm(2,2000,0,function() d=nil package.loaded["d"]=nil collectgarbage("collect") end)
  end

end)
