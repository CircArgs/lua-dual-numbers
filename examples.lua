local inspect=require("inspect")--not mine nor a part of the project!!!!! simply a resource to display tables to console for the sake of these examples!!!



local type=require("shape") --overwrite the built-in type function (local scope declaration to this script is very important)
local dn=require("dualnumber")
--local M=require("matrix")
local funcs=dn.functions
--add a new function to use
dn.newfunc("sin", math.sin, math.cos)

--x is a number we can use like any other (with functions of the dualnumber class), dx is a tag to track the first order derivative of a function with respect to x
local x=dn.new(math.pi, {dx=1})

print(type(x)) --using the shape function overwriting the lua type function in the header

--print the value of x and the tagged value of the derivative
local g=funcs.sin
print(g(x))--pretty print of the function evaluation
print(inspect(dn.val(g(x))))--prints the value of g evaluated at x (i.e. sin(pi)=0 depending on the machine what precision will be very close to zero a by product of nothing more than sine not being exact)
print(inspect(dn.grad(g(x))))--prints the gradient of g evaluated at x (i.e. cos(pi)=-1)

--a more complicated (made up & useless) function f(x,y,z)=ln(x)*y+z^2-1/(logistic(x*y*z))
local y=dn.new(1.5,{dy=1})
local z=dn.new(38,{dz=1})

local f=function(x,y,z) return funcs.ln(x)*y+z^2-1/funcs.logistic(x*y*z) end
print(f(x,y,z))--pretty print of the function evaluation
print(inspect(dn.val(f(x,y,z))))--prints the value of f evaluated at (x,y,z)
print(inspect(dn.grad(f(x,y,z))))--prints the gradient of f evaluated at (x,y,z)

print("Feel Free to Check it by hand (or w/ derivative calculater online). No Magic Here!")



