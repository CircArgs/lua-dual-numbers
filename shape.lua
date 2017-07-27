
--shape will be a general type function for everything including custom objects 

local shape={}

local shape_meta={}
function shape_meta.__call(self,obj)
  local try, catch = pcall(function(x) return x.type end, obj)
  local bait, trap = pcall(type, obj)
  if try then
    if trap=="string" then
      return "string"
    else
      return catch
    end
  else
    return trap
  end
end

setmetatable(shape, shape_meta)

return shape