--GPIO, code, bits, pulse Len, protocal, repeat

--Set gpio6 to high, power up 433m module
local gpio12 = 6
gpio.mode(gpio12, gpio.OUTPUT)
gpio.write(gpio12, gpio.HIGH)


tmr.alarm(0,500,0,function()

  rc.send(4,267715,24,185,1,10)

  --rc.send(4,267724,24,185,1,10)

  --rc.send(4,267571,24,185,1,10)

  --rc.send(4,267580,24,185,1,10)

end)
