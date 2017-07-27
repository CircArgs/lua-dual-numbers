local dualnumber={functions={}, __index={type="dualnumber"}}

function dualnumber.functions.__call(self, obj)
  if obj==nil then
    return self.name
  end
  if dualnumber.type(obj)=="dualnumber" then
    return dualnumber.new(self.func(obj.realpart),dualnumber.dualpart(obj*self.deriv(obj.realpart)))
  elseif dualnumber.type(obj)=="number" then
    return self.func(obj)
  else
    error(self.name.." undefined for type "..dualnumber.type(obj))
  end
end

function copy(orig)--utility function for hard copying a table with nonindexed values
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function dualnumber.new(realpart, dualpartlist)--takes a real number and a list of dual parts {x=1,y=5,z=3.14,...}
  if getmetatable(realpart)==dualnumber then
    return realpart
  end
  local realpart =realpart or 0
  local dualpartlist=dualpartlist or {}
  local num={realpart=realpart, dualpart=dualpartlist}
  setmetatable(num,dualnumber)
  return num
end

function dualnumber.type(obj)
  if getmetatable(obj)==dualnumber then
    return "dualnumber"
  else
    return type(obj)
  end
end

function dualnumber.__tostring(obj)
  if dualnumber.type(obj)=="dualnumber" then
    local str=""
    for k,v in pairs(obj.dualpart) do
      str="+"..v..k..str
    end
    str=obj.realpart..str
    return str
  else
    return tostring(obj)
  end
end

function dualnumber.__add(lhs,rhs)
  if dualnumber.type(lhs)=="dualnumber" and dualnumber.type(rhs)=="dualnumber" then
    local realpart=lhs.realpart+rhs.realpart
    local dualpartlist={}
    local rhsduals=copy(rhs.dualpart)
    for kl,vl in pairs(lhs.dualpart) do
      local added=false
      for kr,vr in pairs(rhs.dualpart) do
        if kl==kr then
          dualpartlist[kl]=vl+vr
          rhsduals[kl]=nil
          added=true
          break
        end
      end
      if added==false then
        dualpartlist[kl]=vl
      end
    end
    for k,v in pairs(rhsduals) do
      dualpartlist[k]=v
    end
    return dualnumber.new(realpart,dualpartlist)
  elseif dualnumber.type(lhs)=="number" and dualnumber.type(rhs)=="number" then
    return dualnumber.new(lhs+rhs)
  elseif dualnumber.type(lhs)=="number" and dualnumber.type(rhs)=="dualnumber" then
    return dualnumber.new(lhs+rhs.realpart,rhs.dualpart)
  elseif dualnumber.type(lhs)=="dualnumber" and dualnumber.type(rhs)=="number" then
    return dualnumber.new(rhs+lhs.realpart,lhs.dualpart)
  else
    return error("Incompatible types for '+': lhs of type "..dualnumber.type(lhs)..", rhs of type "..dualnumber.type(rhs))
  end
end

function dualnumber.realpart(obj)
  if dualnumber.type(obj)=="dualnumber" then
    return obj.realpart
  elseif dualnumber.type(obj)=="number" then
    return obj
  else
    error("realpart undefined for type "..dualnumber.type(obj))
  end
end

function dualnumber.dualpart(obj)
  if dualnumber.type(obj)=="dualnumber" then
    return obj.dualpart
  elseif dualnumber.type(obj)=="number" then
    return 0
  else
    error("dualpart undefined for type "..dualnumber.type(obj))
  end
end

function dualnumber.__sub(lhs,rhs)
  if dualnumber.type(lhs)=="dualnumber" and dualnumber.type(rhs)=="dualnumber" then
    return lhs+-1*rhs
  elseif dualnumber.type(lhs)=="number" or dualnumber.type(rhs)=="number" then
    return lhs+-1*rhs
  else
    error("lhs and rhs must be either of type 'number' or 'dualnumber'")
  end
end

function dualnumber.__mul(lhs,rhs)
  if dualnumber.type(lhs)=="dualnumber" and dualnumber.type(rhs)=="dualnumber" then
    local realpart=lhs.realpart*rhs.realpart
    local dualpartlist={}
    local rhsduals=copy(rhs.dualpart)
    for kl,vl in pairs(lhs.dualpart) do
      local added=false
      for kr,vr in pairs(rhs.dualpart) do
        if kl==kr then
          dualpartlist[kl]=rhs.realpart*vl+lhs.realpart*vr
          rhsduals[kl]=nil
          added=true
          break
        end
      end
      if added==false then
        dualpartlist[kl]=rhs.realpart*vl
      end
    end
    for k,v in pairs(rhsduals) do
      dualpartlist[k]=lhs.realpart*v
    end
    return dualnumber.new(realpart,dualpartlist)
  elseif dualnumber.type(lhs)=="number" and dualnumber.type(rhs)=="number" then
    return dualnumber.new(lhs*rhs)
  elseif dualnumber.type(lhs)=="number" and dualnumber.type(rhs)=="dualnumber" then
    local dualpartlist={}
    for k,v in pairs(rhs.dualpart) do
      dualpartlist[k]=lhs*v
    end
    return dualnumber.new(lhs*rhs.realpart,dualpartlist)
  elseif dualnumber.type(lhs)=="dualnumber" and dualnumber.type(rhs)=="number" then
    local dualpartlist={}
    for k,v in pairs(lhs.dualpart) do
      dualpartlist[k]=rhs*v
    end
    return dualnumber.new(rhs*lhs.realpart,dualpartlist)
  else
    return error("Incompatible types for '+': lhs of type "..dualnumber.type(lhs)..", rhs of type "..dualnumber.type(rhs))
  end
end

function dualnumber.__pow(obj,power)--straight forward (perhaps naive) implementation of power for dual numbers
  if dualnumber.type(power)~="number" then
    error("power must be of type 'number' and be a nonnegative integer")
  elseif power<0 or power%1~=0 then
    error("power must be nonnegative and an integer")
  end
  if dualnumber.type(obj)=="dualnumber" then
    if power==0 then
      return dualnumber.new(1)
    else
      local accum=obj
      for i=1,power-1 do
        accum=accum*obj
      end
      return accum
    end
  elseif dualnumber.type(obj)=="number" then
    return obj^power
  else
    return error("Incompatible type for base of '^': object must be of type 'number' or 'dualnumber'")
  end
end

function dualnumber.conjugate(obj)
  if dualnumber.type(obj)=="dualnumber" then
    local dualpartlist={}
    for k,v in pairs(obj.dualpart) do
      dualpartlist[k]=-1*v
    end
    return dualnumber.new(obj.realpart,dualpartlist)
  elseif dualnumber.type(obj)=="number" then
    return obj
  else
    error("conjugate undefined for type "..dualnumber.type(obj))
  end
end

function dualnumber.__div(lhs,rhs)--lhs is the dividend while rhs is the divisor
  if (dualnumber.type(lhs)=="dualnumber" or dualnumber.type(lhs)=="number") and dualnumber.type(rhs)=="dualnumber" then
    local rhsconjugate=dualnumber.conjugate(rhs)
    return (lhs*rhsconjugate)/(dualnumber.realpart(rhs*rhsconjugate))
  elseif dualnumber.type(lhs)=="number" and dualnumber.type(rhs)=="number" then
    return dualnumber.new(lhs/rhs)
  elseif dualnumber.type(lhs)=="dualnumber" and dualnumber.type(rhs)=="number" then
    return lhs*(1/rhs)
  else
    return error("Incompatible types for '/': dividend of type "..dualnumber.type(lhs)..", divisor of type "..dualnumber.type(rhs))
  end
end

function dualnumber.newfunction(fun)--a new function ('fun') must be of the form {function defined on real numbers (can include dual number functions i.e. functions in dualnumber.functions), first derivative of the function (in terms of functions already in dualnumber.function or primitive binary operators +,-,*,/)}
end

function dualnumber.grad(obj)
  return dualnumber.dualpart(obj)
end

function dualnumber.val(obj)
  return dualnumber.realpart(obj)
end

function dualnumber.newfunc(name,func,deriv)
  if func==nil or name==nil then
    error("Must provide a function name and at least the function (should derivative be ommitted it will be computed numerically.)")
  end
  deriv=deriv or function(x) return (func(x+1e-10)-func(x-1e-10))/2e-10 end
  dualnumber.functions[name]={func=func,deriv=deriv,name=name}
  setmetatable(dualnumber.functions[name],dualnumber.functions)
end


dualnumber.newfunc("ln", math.log, function(x) return 1/x end)
dualnumber.newfunc("logistic", function(x) return 1/(math.exp(-x)+1) end, function(x) local temp=math.exp(x) return temp/(1+temp)^2 end)
dualnumber.newfunc("relu", function(x) return math.max(0,x) end, function(x) return math.min(math.max(0,x),1) end)
dualnumber.newfunc("gaussian", function(x) return math.exp(-x*x)/math.sqrt(math.pi*2) end, function(x) return -math.sqrt(2/math.pi)*x*math.exp(-x*x) end)
dualnumber.newfunc("Id", function(x) return x end, function(x) return 1 end)
dualnumber.newfunc("softplus", function(x) return math.log(1+math.exp(x)) end, dualnumber.functions.logistic)
dualnumber.newfunc("simplified_logistic",function(x) return math.min(math.max(0,x+2),4)/4 end, function(x) if x<=-2 or x>=2 then return 0 else return .25 end end)
dualnumber.newfunc("Step", function(x) if x<0 then return 0 else return 1 end end, function(x) return 0 end)
dualnumber.newfunc("Square", function(x) return x*x end, function(x) return 2*x end)


return dualnumber