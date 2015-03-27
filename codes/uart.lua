
uart.setup( 0, 9600, 8, 0, 1, 0 )

uart.on("data", "\r",
    function(data)
        print("receive from uart:", data)
        if data=="quit\r" then
            uart.on("data")
    end
end, 0)

uart.write(0,"ready.")