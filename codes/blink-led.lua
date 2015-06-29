
--local gpio0 = 3
--local gpio2 = 4
local gpio4 = 2
local ledPin = 2

--gpio.mode(gpio0, gpio.OUTPUT)
gpio.mode(ledPin, gpio.OUTPUT)

lighton=0
tmr.alarm(0,1000,1,function()
if lighton==0 then
    lighton=1
    --gpio.write(gpio0, gpio.LOW)
    gpio.write(ledPin, gpio.HIGH)
else
    lighton=0
    --gpio.write(gpio0, gpio.HIGH)
    gpio.write(ledPin, gpio.LOW)
end
end)

print("Blinking")

-- tmr.stop(0)
