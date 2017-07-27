
--shape will be a general type function for all new 

types={require("dualnumber")}

function shape(obj)
  local test=nil
  for i=1,#types do
    try, catch=pcall(types[i].type, obj)
    if try then
      return catch
    else
      return error("Type Error: undefined type")
    end
  end
end


--example (uncomment)
--[[x=types[1].new(1,{["dx"]=1})
print(shape(x))]]
