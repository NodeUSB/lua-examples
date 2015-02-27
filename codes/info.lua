majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
print("NodeMCU "..majorVer.."."..minorVer.."."..devVer)

print("chipid:"..chipid
print("flashsize:"..flashsize)

local myip = wifi.sta.getip()
local mac = wifi.sta.getmac()

print(myip)
print(mac)

print("V:"..node.readvdd33())
