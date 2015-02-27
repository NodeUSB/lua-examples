
local gpio0 = 3
local gpio2 = 4

gpio.mode(gpio0, gpio.OUTPUT)

lighton=0
tmr.alarm(0,1000,1,function()
if lighton==0 then 
    lighton=1 
    gpio.write(gpio0, gpio.HIGH)
    -- 512/1024, 50% duty cycle
else 
    lighton=0 
    gpio.write(gpio0, gpio.LOW)
end 
end)

print("Blinking")

--tmr.stop(0)
