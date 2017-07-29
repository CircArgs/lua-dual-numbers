local type=require("shape")
local inspect=require("inspect")

local matrix={__index={type="matrix"}}

--utility functions
function Length(x)
  x=tostring(x)
  return #x
end
function Spaces(n)
  local string=""
  for i=1,n do
    string=string.." "
  end
  return string
end
function VectorProd(lmat,rmat,row,column)
  local left=lmat[row]
  local ret=lmat[row][c]*rmat(column,r)
  for c=2,lmat:shape()[1] do
    for r=2,rmat:shape()[2] do
      ret=ret+lmat(row,c)*rmat(column,r)
    end
  end
  return ret
end
function AssembleColumn(mat,col)
  local ret={}
  for i=1,mat:shape()[1] do
    ret[i]=mat[i][col]
  end
  ret.T=mat.T
  ret.archetype=mat.archetype
  setmetatable(ret,matrix)
  return ret
end

--end utility functions

--begin method definitions
function matrix.__call(self,...)
  local args={...}
  if #args==0 then
    return self
  elseif #args==1 then
    error("Index Error: Need 0 or 2 indices.")
  else
    local row=args[1]
    local column=args[2]
    if type(row)=="string" and type(column)=="string" then
      assert((row=="all" or row=="*") and (column=="all" or column[2]=="*"), "Index Error: Matrix Indices must be Integers, \"all\" or \"*\" ")
      return self
    elseif type(row)=="string" and type(column)=="number" then
      assert((row=="all" or row=="*") and math.fmod(column)==0, "Index Error: Matrix Indices must be Integers, \"all\" or \"*\" ")
      assert(not(column>self:shape()[2]), "Index Error: Index Out Of Bounds.")
      if self.T==true then
        column=row
      end
      return AssembleColumn(self,column)
    elseif type(row)=="number" and type(column)=="string" then
      assert((column=="all" or column=="*") and math.fmod(row)==0, "Index Error: Matrix Indices must be Integers, \"all\" or \"*\" ")
      assert(not(row>self:shape()[1]), "Index Out Of Bounds.")
      if self.T==true then
        row=column
      end
      local ret={self[row]}
      ret.T=self.T
      ret.archetype=self.archetype
      return ret
    else
      assert(math.fmod(column,1)==0 and math.fmod(row,1)==0, "Index Error: Matrix Indices must be Integers.")
      assert(not(row>self:shape()[1] or column>self:shape()[2]), "Index Error: Index Out Of Bounds.")
      if self.T==true then
        row=args[2]
        column=args[1]
      end
      return self[row][column]
    end
  end
end

function matrix.new(t)--class constructor called with table syntax
  --will ignore noncheck options if mat is valid matrix (table of tables)
  --doesn't waste resources type checking matrix values (unless check_values=true)
  --ensures uniform row length by default (unless check_lengths=false)
  --if not given a matrix as table of tables, refer to rows, and columns then fill
  --fill is default 0 or 1s or random or user defined function
  --fill can be defined so that its values depend on the row and column it is placing the value at (see matrix.id for example)
  --random fill refers to range to see where random numbers can be drawn between
  --rows and columns have to be array indexed (no check)
  --NOTE: Check lengths is irrelevant if no matrix is provided
  --One can type check an existing matrix simply by setting mat=the_matrix_to_check and check_values=true
  setmetatable(t,{__index={mat=t[1],nrows=t[1], ncolumns=t[2], fill=t[3], range=t[4], check_lengths=true,check_values=false}})
  local matrice=t.mat
  local nrows=t.nrows or 0
  local ncolumns=t.ncolumns or 0
  local fill=t.fill or "zeros"
  local range=t.range or {0,1}
  if not(matrice==nil) and (type(matrice)=="table" or type(matrice)=="matrix") then--given matrix must be table of tables
    assert(matrice[1] and matrice[1][1],"Matrix Construct Error: Cannot make empty matrix.")
    if t.check_lengths==false and t.check_values==false then --here we just check the check options and construct the matrix accordingly
      setmetatable(matrice, matrix)
      return matrice
    elseif t.check_lengths==true and t.check_values==false then
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
    elseif t.check_lengths==true and t.check_values==true then
      local length_check=#matrice[1]
      matrice.archetype=type(matrice[1][1])
      for i=1, #matrice do
        if not(#matrice[i]==length_check) then
          error("Matrix Construct Error: Row lengths must all be the same (check_lengths=true by default).")
        else
          length_check=#matrice[k]
        end
        for k=2,#matrice[i] do
          assert(type(matrice[i][k])==matrice.archetype,"Matrix Construct Error: Matrix not of uniform type (check_values=true).")	
        end
      end
    else--else just check values
      matrice.archetype=type(matrice[1][1])
      for i=1, #matrice do
        for k=2,#matrice[i] do
          assert(type(matrice[i][k])==matrice.archetype,"Matrix Construct Error: Matrix not of uniform type (check_values=true).")
        end
      end
    end
  else--we've determined no table was provided to make a matrix so we'll make on ourselves
    assert(nrows>0 and ncolumns>0 and math.fmod(nrows,1)==0 and math.fmod(ncolumns,1)==0,"Matrix Construct Error: Must provide either list of lists (see check options for additional error checking) or positive integer dimensions.")
    matrice={}
    local value=nil
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
    if check_values==true then
      matrice.archetype=type(value(i,j))
      local temp=nil
      for i=1,nrows do
        matrice[i]={}
        for j=1,ncolumns do
          temp=value(i,j)
          assert(type(temp)==matrice.archetype,"Matrix not of uniform type (check_values=true).")
          matrice[i][j]=temp
        end
      end
    else
      for i=1,nrows do
        matrice[i]={}
        for j=1,ncolumns do
          matrice[i][j]=value(i,j)
        end
      end
    end
  end  
  setmetatable(matrice, matrix)
  matrice.T=matrice.T or false --if checking an existing matrix want to preserve transpose data
  return matrice
end

function matrix.id(n, mul_id, add_id )--makes n dimensional identity matrix. Can enter multiplicative identity (analog to 1) and additive id (analog to 0) of specific object class
  local add_id=add_id or 0
  local mul_id=mul_id or 1
  assert(type(n)=="number" and math.fmod(n)==0, "n must be an Integer")
  assert((type(mul_id)=="number" or (getmetatable(mul_id) and getmetatable(mul_id).__add and getmetatable(mul_id).__mul)) and (type(add_id)=="number" or (getmetatable(add_id) and getmetatable(add_id).__add and getmetatable(add_id).__mul)), "Invalid option for add_id or mul_id.")
  local fill=function(r,c)
    if r==c then
      return mul_id
    else
      return add_id
    end
  end
  return matrix.new{nrows=n,ncolumns=n, fill=fill}
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

function matrix.__tostring(mat)
  local max=0
  local string=""
  local nrows=mat:shape()[1]
  local ncolumns=mat:shape()[2]
  for i=1,nrows do  
    for j=1,ncolumns do
      local temp=Length(mat(i,j))
      if max<temp then
        max=temp
      end
    end
  end
  for r=1,nrows do
    string=string.."\n"
    for c=1,ncolumns do
      string=string..mat(r,c)..Spaces(max-Length(mat(r,c))).." "
    end
  end
  return string.."\n"
end



function matrix.__mul(lhs, rhs,...)--does not check compatability between two matrices, only ATTEMPTS to between matrix and non-matrix
  local ret={}
  if type(lhs)==type(rhs) then
    for row=1,lhs:shape()[1] do
      for column=1,rhs:shape()[2] do
        ret[row][column]=VectorProd(lhs,rhs,row,column)--utility function above
      end
    end
  elseif not(type(rhs)=="matrix") then
    for r=1,lhs:shape()[1] do
      for c=1,lhs:shape()[2] do
        local did_error, result=pcall(function() return lhs(r,c)*rhs end)
        if did_error then
          error("Incompatible types: at least one pair from lhs of type matrix and rhs of type ".. type(rhs).." were incompatible.\n"..result)
        else
          ret[r][c]=result
        end
      end
    end
  else
    for r=1,rhs:shape()[1] do
      for c=1,rhs:shape()[2] do
        local did_error, result=pcall(function() return lhs*rhs(r,c) end)
        if did_error then
          error("Incompatible types: at least one pair from lhs of type "..type(lhs).." and rhs of type matrix  were incompatible.\n"..result)
        else
          ret[r][c]=result
        end
      end
    end
  end
  return matrix.new{ret, check_values=false, check_lengths=false}
end
  
return matrix