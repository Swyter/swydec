local bit=require("bit")
local opc=require("op")
swydec = {}

function printflags(o)
  local bor,band,bxor=bit.bor,bit.band,bit.bxor
  local abs,flag=math.abs,""
  
  local          neg=0x80000000
  local this_or_next=0x40000000
 
 if abs(band(o,neg))==neg then
  flag="neg|"..flag
  o=abs(bxor(o,neg))
 end
 
 if abs(band(o,this_or_next))==this_or_next then
  flag="this_or_next|"..flag
  o=abs(bxor(o,this_or_next))
 end
  
 local final=flag..opc[o] or o
 
 final=final:gsub("neg|ge","lt")
 final=final:gsub("neg|eq","neq")
 final=final:gsub("neg|gt","le")
 
 return final
end

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
      local params=""
      
      if param_no > 0 then
        for ll=1, param_no do
          params=params..", "..opcode_arr[gg+1+ll]
        end
      end
        
      if opcode==3 or opcode==5 then wh=wh-2
     end
     
      local opcode_t=opc[opcode] or printflags(opcode)
      out:write((" "):rep(wh).."("..opcode_t..(params)..")\n")

      if opcode==4 or opcode==6 or opcode==7 or opcode==11 or opcode==12 or opcode==5 then wh=wh+2
     end
      
      gg=gg+2+param_no
    end
  end
 
 end
 
 out:close()