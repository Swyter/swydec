local bit=require("bit")
local opc=require("op")
local ffi=require("ffi")
local x = os.clock()
swydec = {}


 -- print(1224979098644774924LL,1224979098644774912LL)
 -- print(ffi.new("int64_t",1224979098644774924)-1224979098644774912LL)
  
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
  
 local final=flag..(opc[o] or o)
 
 final=final:gsub("neg|ge","lt")
 final=final:gsub("neg|eq","neq")
 final=final:gsub("neg|gt","le")
 
 return final
end
function printparam(p)
  local bor,band,bxor,lshift=bit.bor,bit.band,bit.bxor,bit.lshift
  local abs,flag=math.abs,""
  local op_bits = 24 + 32
  
  local  reg=72057594037927936 --lshift(1, op_bits)
  local  var=lshift(2, op_bits) --144115188075855872
  local  qst=lshift(7, op_bits) --504403158265495552
  local lvar=1100000000000000   --1224979098644774912 --lshift(17,op_bits)
  local qstr=lshift(22,op_bits) --1585267068834414592
 
 function dolong(a,b)
  print(string.format("local tty=%sLL-%sLL",a,b))
  print(tty)
 end
  
  --print(string.format("0x1100000000000000 \n0x%x",lvar))
  --print(p)
  --print(bit.tobit(p))
  
  local gg=""
  local head=tostring(p):sub(1,5)
  
      if head=="14411" then
    gg="'$gvar_"..(p:sub(-6)-("144115188075855872"):sub(-6)).."'"--.."'||"..p
  elseif head=="50440" then
    gg="'quest_"..(p:sub(-6)-("504403158265495552"):sub(-6)).."'"--.."'||"..p
  elseif head=="12249" then
    gg="':lvar_"..(p:sub(-6)-("1224979098644774912"):sub(-6)).."'"--.."'||"..p
  elseif head=="15852" then
    gg="'@qstr_"..(p:sub(-6)-("1585267068834414592"):sub(-6)).."'"--.."'||"..p
  else
    gg=p
  end
  
  return gg
  
  --for t=1,20,10 do
  --string.sub(-2,-2)
  --  band(,0x1100000000000000)
  --end
  
 --    if abs(band(p,reg))==reg then
 -- p="reg"..abs(bxor(p,reg))
 --elseif abs(band(p,var))==var then
 --  p="_var_"..abs(bxor(p,var))
 --  print(p,"..")
 --elseif abs(band(p,lvar))==lvar then
 --  p="_lvar_"..abs(bxor(p,lvar))
 --  print(p,"..")
 --end
  
 -- return (abs(tonumber(p))-1224979098644774912)
end
local filename = {"R:\\Juegos\\swconquest\\modules\\swconquest\\scripts.txt",
                  "R:\\Juegos\\swconquest\\modules\\native\\scripts.txt",
                  "R:\\Juegos\\WB\\Modules\\DawnOfMan_Beta\\scripts.txt"}

local out = io.open("scripts.py","w")
local s,raw=0,{}
for l in io.lines(filename[1]) do
  s=s+1
  raw[s]={}
  for w in l:gmatch("%S+") do table.insert(raw[s], w) end
end

 if raw[1][3] == "1" then -->for file
  local sc = tonumber(raw[2][1])
  
  for i=3,sc*2+1,2 do -->for script
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
      local bignum=72057594037927936
        for ll=1, param_no do
          local param=opcode_arr[gg+1+ll]
          params=params..", "..( tonumber(param)>=bignum and printparam(param) or param )
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
 print(os.clock()-x.."s")