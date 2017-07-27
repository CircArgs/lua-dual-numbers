local dn=require("dualnumber")

local s=require("shape")


x=dn.new(1,{dx=1})
print(s.shape(3))
print(s.shape("hello"))
print(s.shape(x))