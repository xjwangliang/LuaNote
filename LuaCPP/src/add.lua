-- add two numbers
-- 调用luaL_dofile()就是执行脚本。因为在本文中我们只定义了一个函数，故只需简单地调用luaL_dofile()函数就能执行add函数
function add ( x, y )
  return x + y
end
