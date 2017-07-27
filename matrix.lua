matrix={}

function matrix.new(self, args)
  setmetatable(args, {__index={mat=nil, rows=0, columns=0, ones=false, zeroes=true, random=false, range={0,-1}}})
  --will ignore options if mat is valid matrix (table of tables)
  --doesn't waste resources type checking matrix values
  local mat=args.mat
  local rows=args.rows
  local columns=args.columns
  local ones=args.ones
  local zeroes=args.zeroes
  local random=args.random
  local range=args.range
  if mat==nil and (rows<=0 or columns<0 or rows%~=0 or columns%~=0) then
    error "Must provide either list of lists (NOTE: matrices are not type-checked for validity. Any objects with arithmetic operations will suffice for matrix operations.) or positive integer dimensions."
  elseif mat==nil and rows>0 and columns>0 and rows%=0 and columns%=0 then 
    