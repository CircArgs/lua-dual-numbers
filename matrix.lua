matrix={__index={type="matrix"}}

function matrix.new(args)--class cosntructor
  setmetatable(args, {__index={mat=nil, rows=0, columns=0, fill="zeroes", range={0,-1}}})--default arguments
  --will ignore options if mat is valid matrix (table of tables)
  --doesn't waste resources type checking matrix values
  --if not given a matrix as table of tables, refer to rows, and columns then fill
  --fill is default 0 or 1s or random or user defined function
  --random fill refers to range to see where random numbers can be drawn between
  --rows do not have to be array indexed but columns do
  --rows must all have the same length
  local mat=args.mat
  --begin with checking if a matrix is given
  local temp_length_check=nil
  if type(mat)="table" then
    for k,v in ipairs(mat) do
      if #mat[k]~=temp then
        error("Matrix Construct Error: Row lengths must all be the same.")
      else
        temp=#mat[k]
      end
    end
    setmetatable(mat, matrix)
    return mat
  end
  
  local matrice={}--the actual object to be constructed and returned
  setmetatable(matrice, matrix)
  local rows=args.rows
  local columns=args.columns
  local ones=args.ones
  local fill=args.fill
  local range=args.range
  local value=nil
  if mat==nil and (rows<=0 or columns<0 or rows%~=0 or columns%~=0) then
    error("Matrix Construct Error: Must provide either list of lists (NOTE: matrices are not type-checked for validity. Any objects with arithmetic operations will suffice for matrix operations.) or positive integer dimensions.")
  elseif mat==nil and rows>0 and columns>0 and rows%=0 and columns%=0 then 
    if fill="zeroes" then
      value=function() return 0 end
    elseif fill="ones" then
      value=function() return 1 end
    elseif fill="random" then
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

    
    
    
    
return matrix
  
    