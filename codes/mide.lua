srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
   local okHeader= "HTTP/1.0 200 OK\r\nAccess-Control-Allow-Origin:*\r\n\r\n"
   local DataToGet = 0
   local sending =false

   function s_output(str)
      if(conn~=nil) then
        if(sending) then
            conn:send(str)
        else
            sending = true
            conn:send(okHeader..str)
        end
      end 
   end
    
  node.output(s_output, 1)

  conn:on("receive",function(conn,payload)
     local pos=string.find(payload,"%c%-%-%-")
     
     _,fstart,fname=string.find(payload,"%>([^?]*)(%-%-%-)%c",pos)

     if pos==nil and fstart==nil then
          --print(payload)
          print("ERR")
          return
     end

     if fname~=nil and string.len(fname)>2 then
          file.open(fname, "w")
          file.write(string.sub(payload,fstart+2))
          file.close()
          print("Saved")
          return
     else
          node.input(string.sub(payload,pos+4))
     end
     --conn:send(okHeader.."OK")

  end)
  conn:on("sent",function(conn) 
    
    sending =false
    node.output(nil)
    conn:close() 
  end)
end)
print("listening, free:", node.heap())
