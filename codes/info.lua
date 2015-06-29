local myip = wifi.sta.getip()
local mac = wifi.sta.getmac()

print(myip)
print(mac)
print(node.heap())

majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
print("NodeMCU "..majorVer.."."..minorVer.."."..devVer)

print("chipid:"..chipid)

print("flashsize:"..flashsize)

--print("V:"..node.readvdd33())

collectgarbage("collect")
