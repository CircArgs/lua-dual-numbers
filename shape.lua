
--shape will be a general type function for everything including custom objects 

shape={}

function shape.shape(obj)
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


return shape