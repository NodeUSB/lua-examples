
-- set the color of one LED on GPIO 2 to red
ws2812.write(4, string.char(0, 255, 0))
-- set the color of 10 LEDs on GPIO 0 to blue
ws2812.write(3, string.char(0, 0, 255):rep(10))
-- first LED green, second LED white
ws2812.write(4, string.char(255, 0, 0, 255, 255, 255))
