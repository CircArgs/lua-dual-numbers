local type=require("shape")

local matrix={__index={type="matrix"}}

function matrix.__call(self,...)
  assert(args[n]==2 and assert(type(args[1])=="number" and type(args[2])=="number" and math.fmod(args[1])==0 and math.fmod(args[2])==0, "Matrix Indices must be Integers") "More indices given than defined.")
  if self.T==false then
    return self[args[1]][args[2]]
  else
    return self[args[2]][args[1]]
  end
end
  

function matrix.new(t)--class cosntructor
  t.rows=t.rows or t[1]
  t.columns=t.columns or t[2]
  t.fill=t.fill or t[3]
  t.range=t.range or t[4]
  --will ignore options if mat is valid matrix (table of tables)
  --doesn't waste resources type checking matrix values
  --if not given a matrix as table of tables, refer to rows, and columns then fill
  --fill is default 0 or 1s or random or user defined function
  --random fill refers to range to see where random numbers can be drawn between
  --rows and columns have to be array indexed (no check)
  local matrice=t.mat--the actual object to be constructed and returned
  if not(matrice==nil) then
    matrice.T=false
    setmetatable(matrice, matrix)
    --begin with checking if a matrix is given
    local temp_length_check=nil
    if type(matrice)=="table" and #matrice>1 then
      temp_length_check=#matrice[1]
      for k=2,#matrice do
        if not(#matrice[k]==temp) then
          error("Matrix Construct Error: Row lengths must all be the same.")
        else
          temp=#matrice[k]
        end
      end
      return matrice
    end
  else
    matrice={}
    local rows=args.rows
    local columns=args.columns
    local ones=args.ones
    local fill=args.fill
    local range=args.range
    local value=nil
    if mat==nil and (rows<=0 or columns<0 or not(math.fmod(rows)==0) or not(math.fmod(columns)==0)) then
      error("Matrix Construct Error: Must provide either list of lists (NOTE: matrices are not type-checked for validity. Any objects with arithmetic operations will suffice for matrix operations.) or positive integer dimensions.")
    elseif mat==nil and rows>0 and columns>0 and math.fmod(rows)==0 and math.fmod(columns)==0 then 
      if fill=="zeroes" then
        value=function() return 0 end
      elseif fill=="ones" then
        value=function() return 1 end
      elseif fill=="random" then
      fill=math.random(range[1],range[2])
      elseif type(fill)=="function" then
        value=fill
      else
        error("Matrix Construct Error: Invalid fill option specified: "..fill)
      end
        for i=1,rows do
          matrice[i]={}
          for j=1,columns do
            matrice[i][j]=value()
          end
        end
      return matrice
    end
  end
end

function matrix.__index.shape(self)--all matrices have a shape function. using mat.shape(mat) will yield shape
  return {#self, #self[1]}
end
function matrix:shape()--syntactic sugar for the above shape now can be called as mat:shape()
  self.shape(self)
end

function matrix.type(obj)
  return type(obj)
end

function matrix.transpose(self)
  assert(type(mat)=="matrix","Cannot transpose object of type: "..type(mat))
  mat.transpose()
end

function matrix.__index.transpose(self)
    self.T=not(self.T)
end
  --[[
function matrix.__mul(lhs, rhs)
  assert(type(lhs)=="matrix" and type(rhs)=="matrix" and assert(lhs.shape()[2]=rhs.shape()[1], "Matrix product undefined for lhs shape "..lhs.shape()[1].." x "..lhs.shape()[2].." and rhs shape "..rhs.shape()[1].." x "..rhs.shape()[2]), "Matrix product undefined for types lhs,rhs: "..type(lhs)..type(rhs))
  local ret={}
  for 

    ]]
    
    
    
    
    
return matrix
  
    