-- ***************************************************************************
-- filecopy module for ESP8266 with nodeMCU
--
-- Written by Mike Wen
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

local moduleName = ...
local M = {}
_G[moduleName] = M

function M.copy(org, dest)
     --o = file.open(org,"r")
     --d = file.open(dest,"w")

     local lines = ""
     
     file.open(org,"r")
     while true do
          line = file.readline()
          if(line==nil) then
               break
          else
               --lines = lines..line.."\n"
               lines = lines..line
          end
     end
     file.close()

     file.open(dest,"w")
     file.writeline(lines)
     file.close()
end

function M.show(dest)

     --local lines = nil
     file.open(dest,"r")
     while true do
          line = file.readline()
          if(line==nil) then
               break
          else
               print(line)
          end
     end
     file.close()
end

return M
