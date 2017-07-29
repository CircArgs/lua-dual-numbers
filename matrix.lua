local type=require("shape")
local inspect=require("inspect")

local matrix={__index={type="matrix"}}

function matrix.__call(self,...)
  local args={...}
  local row=1
  local column=2
  assert(#args==2 and assert(type(args[row])=="number" and type(args[column])=="number" and math.fmod(args[1],1)==0 and math.fmod(args[2],1)==0, "Matrix Indices must be Integers"), "More indices given than defined.")
  if self.T==true then
    row,column=2,1
  end
  assert(not(args[row]>self:force_shape().nrows or args[column]>self:force_shape().ncolumns), "Index Out Of Bounds.")
  if self.T==false then
    return self[args[1]][args[2]]
  else
    return self[args[2]][args[1]]
  end
end
  
function matrix.new(t)--class constructor called with table syntax
  --will ignore options if mat is valid matrix (table of tables)
  --doesn't waste resources type checking matrix values
  --if not given a matrix as table of tables, refer to rows, and columns then fill
  --fill is default 0 or 1s or random or user defined function
  --random fill refers to range to see where random numbers can be drawn between
  --rows and columns have to be array indexed (no check)
  setmetatable(t,{__index={mat=t[1],nrows=t[1], ncolumns=t[2], fill=t[3], range=t[4], check=true}})
  local matrice=t.mat
  if t.check==false then
    setmetatable(matrice, matrix)
    return matrice
  end
  local nrows=t.nrows or 0
  local ncolumns=t.ncolumns or 0
  local fill=t.fill or "zeros"
  local range=t.range or {0,1}
  if not(matrice==nil) and type(matrice)=="table" then
    matrice.T=false
    --begin with checking if a matrix is given
    if #matrice>1 then
      local length_check=#matrice[1]
      for k=2,#matrice do
        if not(#matrice[k]==length_check) then
          error("Matrix Construct Error: Row lengths must all be the same.")
        else
          length_check=#matrice[k]
        end
      end
    end
  else
  --we've determined no table was provided to make a matrix so we'll make on ourselves
  matrice={}
    local value=nil
    if nrows<=0 or ncolumns<0 or not(math.fmod(nrows,1)==0) or not(math.fmod(ncolumns,1)==0) then
      error("Matrix Construct Error: Must provide either list of lists (NOTE: matrices are not type-checked for validity. Any objects with arithmetic operations will suffice for matrix operations.) or positive integer dimensions.")
    elseif nrows>0 and ncolumns>0 and math.fmod(nrows,1)==0 and math.fmod(ncolumns,1)==0 then 
      if fill=="zeros" then
        value=function() return 0 end
      elseif fill=="ones" then
        value=function() return 1 end
      elseif fill=="random" then
        value=function() return (range[1]-range[2])*math.random()+range[2] end
      elseif type(fill)=="function" then
        value=fill
      else
        error("Matrix Construct Error: Invalid fill option specified: "..fill)
      end
        for i=1,nrows do
          matrice[i]={}
          for j=1,ncolumns do
            matrice[i][j]=value()
          end
        end
      
    end
  end
  setmetatable(matrice, matrix)
  return matrice
end

function matrix.__index.shape(self)--all matrices have a shape function. using mat.shape(mat) will yield shape including under transpose
  local row=#self
  local column=#self[1]
  if self.T==true then
    return {column, row, nrows=column, ncolumns=row}
  end
  return {row, column, nrows=row, ncolumns=column}
end


function matrix:shape()--syntactic sugar for the above shape now can be called as mat:shape()
  self.shape(self)
end

function matrix.__index.force_shape(self)--all matrices have a shape function. using mat.force_shape(mat) will yield shape of the original (untransposed matrix)
  return {#self, #self[1], nrows=#self, ncolumns=#self[1]}
end

function matrix:force_shape()--syntactic sugar for the above force_shape now can be called as mat:force_shape()
  self.force_shape(self)
end

function matrix.type(obj)
  return type(obj)
end

function matrix:transpose()
  self.transpose()
end

function matrix.__index.transpose(self)
    assert(type(self)=="matrix","Cannot transpose object of type: "..type(mat))
    self.T=not(self.T)
end

function matrix:force_transpose()
  self.transpose()
end

function matrix.__index.force_transpose(self)
  --allocates a new matrix with the originals' transposed
  --NOTE: if the orignal is soft transposed i.e. T=true then the hard transpose will be a hard copy of the orginial 
  assert(type(self)=="matrix","Cannot transpose object of type: "..type(mat))
  assert(type(self)=="matrix","Cannot transpose object of type: "..type(mat))
  local nrows=self:shape().nrows
  local ncolumns=self:shape().ncolumns
  local new_mat={}
  for r=1,nrows do
    new_mat[r]={}
    for c=1, ncolumns do
      new_mat[r][c]=self(r,c)
    end
  end
  return new_mat
end

function matrix.__tostring(self)
  function Length(x)
    x=""..x
    return #x
  end
  function Spaces(n)
    local string=""
    for i=1,n do
      string=string.." "
    end
    return string
  end
  local max=0
  local string=""
  local nrows=self:shape().nrows
  local ncolumns=self:shape().ncolumns
  for i=1,nrows do
    for j=1,ncolumns do
      local temp=Length(self(i,j))
      if max<temp then
        max=temp
      end
    end
  end
  for r=1,nrows do
    string=string.."\n"
    for c=1,ncolumns do
      string=string..self(r,c)..Spaces(max-Length(self(r,c))).." "
    end
  end
  return string.."\n"
end
--[[
function matrix.__mul(lhs, rhs)
  assert(type(lhs)=="matrix" and type(rhs)=="matrix" and assert(lhs.shape()[2]=rhs.shape()[1], "Matrix product undefined for lhs shape "..lhs:shape()[1].." x "..lhs:shape()[2].." and rhs shape "..rhs:shape()[1].." x "..rhs:shape()[2]), "Matrix product undefined for types lhs,rhs: "..type(lhs)..type(rhs))
  local ret={}
  for 


    
    
    --]]
    
    
return matrix
  
    