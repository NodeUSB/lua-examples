-- Use bmp180, si7021 with NodeUSB, connect to USB connector with GND, goio13, gpio12, gpio14
local gpio0 = 3
local gpio2 = 4
local gpio4 = 2
--local gpio12 = 6
local GPIO12 = 6
local GPIO13 = 7
local GPIO14 = 5

--Use GPIO13 to provide power for bmp180, si7021
gpio.mode(GPIO13, gpio.OUTPUT)
gpio.write(GPIO13, gpio.HIGH)

local bmp=require("bmp085")
bmp.init(GPIO14,GPIO12)

if pcall(function () tb=bmp.getUT() ap=bmp.getUP() end) then
--if pcall(function () tb=bmp.getUT() ap=bmp.getUP_raw() end) then
  sT=string.format([[%s]],tb):sub(0,5)
  sAP=string.format([[%s]],ap):sub(0,5)
  print("Temperature\n"..sT.."\nPressure\n"..sAP)
else
  print("Error reading from BMP085")
end

-- release module
bmp = nil
bmp085 = nil
package.loaded["bmp085"]=nil

collectgarbage()

local si=require("si7021")
--si.init(6,7)
si.init(GPIO14,GPIO12)
si7021.read(OSS)

if pcall(function () it=si7021.getTemperature() ih=si7021.getHumidity() end) then
  t = string.format([[%s]],(it/100)):sub(0,5)
  h = string.format([[%s]],(ih/100)):sub(0,5)
  print("T\n"..t.."\nH\n"..h)
else
  print("Error from si7021")
  return
end

-- release module
si = nil
si7021 = nil
package.loaded["si7021"]=nil

collectgarbage()
