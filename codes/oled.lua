
--gpio4 is 2
gpio.mode(2, gpio.OUTPUT, gpio.PULLUP)
gpio.write(2, gpio.HIGH)

function init_i2c_display()
     sda = 3 --GPIO0
     scl = 4 --GPIO2
     sla = 0x3c
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(sla)
end

function drawNode()
    disp:setScale2x2()
     disp:setFont(u8g.font_6x10)
     disp:drawStr( 0+0, 8+0, "NodeUSB is")
     disp:drawStr( 0+0, 25+0, "awesome!")
end

function test()
    disp:firstPage()
    repeat
      drawNode(draw_state)
    until disp:nextPage() == false
end

init_i2c_display()
test()
