--local bul=bullet.new()
--bul.setPower(3)
--print(bul.getPower())


require "safe_set"
 
s = safe_set.create()
del = s:enter(function() print("test") end)
s:enter(function() print("good") end)

s:enter(function() del(); print("enter del()") end)
 
for f in safe_set.iterator(s) do
  f()
  print("execute f()")
end

del()

t = {}
m = {a = 10}
print(type(setmetatable(t,m)) , tostring(t), tostring(m),  tostring(setmetatable(t,m)))

local function create()
  local arg_table = {}
  local function dispatcher (...)
    local tbl = arg_table
    local n = select ("#",...)
    local last_match
    for i = 1,n do
      local t = type(select(i,...))
      local n = tbl[t]
      last_match = tbl["..."] or last_match
      if not n then
        return last_match (...)
      end
      tbl = n
    end
    return (tbl["__end"] or tbl["..."])(...)
  end
  local function register(desc,func)
    local tbl = arg_table
    for _,v in ipairs(desc) do
      if v=="..." then
        assert(not tbl["..."])
        tbl["..."] = func
        return
      end
 
      local n = tbl[v]
      if not n then
        n = {}
        tbl[v]=n
      end
      tbl = n
    end
    tbl["__end"] = func
  end
  return dispatcher, register, arg_table
end
 
local all={}
 
local function register(env,desc,name)
  local func = desc[#desc]
  assert(type(func)=="function")
  desc[#desc] = nil
 
  local func_table
  if all[env] then
    func_table = all[env]
  else
    func_table = {}
    all[env] = func_table
  end
 
  if env[name] then
    assert(func_table[name])
  else
    env[name],func_table[name] = create()
  end
 
  func_table[name](desc,func)
end
 
define = setmetatable({},{
  __index = function (t,k)
    local function reg (desc)
      register(getfenv(2),desc,k)
    end
    t[k] = reg
    return reg
  end
})
define.test {
  "number",
  function(n)
    print("number",n)
  end
}
define.test {
  "string",
  "number",
  function(s,n)
    print("string number",s,n)
  end
}
 
define.test {
  "number",
  "...",
  function(n,...)
    print("number ...",n,...)
  end
}
 
define.test {
  "...",
  function(...)
    print("default",...)
  end
}
 
test(1)
test("hello",2)
test("hello","world")
test(1,"hello")