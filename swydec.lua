local bit=require("bit")
swydec = {}

local filename = "R:\\Juegos\\swconquest\\modules\\swconquest\\scripts.txt"
local out = io.open("scripts.py","w")
local s,raw=0,{}
for l in io.lines(filename) do
  s=s+1
  raw[s]={}
  for w in l:gmatch("%S+") do table.insert(raw[s], w) end
end

 if raw[1][3] == "1" then -->for file
  local sc = tonumber(raw[2][1])
  
  for i=3,sc*2+1,2 do -->for script
    --print(raw[i][1])
    out:write(raw[i][1].."=>\n")

    local opcode_arr=raw[i+1]
    local op = tonumber(opcode_arr[1])
    local gg = 2
    local wh = 4
    for y=1,op do -->for opcode
      local   opcode=tonumber(opcode_arr[gg])
      local param_no=tonumber(opcode_arr[gg+1])
      
      if param_no > 0 then
      local params=""
        for ll=1, param_no do
          params=params..", "..opcode_arr[gg+1+ll]
        end
      else
      local params=false
      end
        
      if opcode==3 or opcode==5 then wh=wh-2
     end
        
      out:write((" "):rep(wh).."("..opcode..(not params and params or "" )..")\n")

      if opcode==4 or opcode==6 or opcode==7 or opcode==11 or opcode==12 or opcode==5 then wh=wh+2
     end
      
      gg=gg+2+param_no
    end
  end
 
 end
out:close()