--require "socket"
--
--
--local function receive (connection)
--  connection:timeout(0)   -- do not block
--  local s, status = connection:receive(2^10)
--  if status == "timeout" then
--    coroutine.yield(connection)
--  end
--  return s, status
--end
--
--local function download (host, file)
--  local c = assert(socket.connect(host, 80))
--  local count = 0    -- counts number of bytes read
--  c:send("GET " .. file .. " HTTP/1.0\r\n\r\n")
--  while true do
--    local s, status = receive(c)
--    count = count + string.len(s)
--    if status == "closed" then break end
--  end
--  c:close()
--  print(file, count)
--end
--
--
--
--for n in pairs(_G) do print(n) end

value = loadstring("return " .. "w")()
print(value)
print("==============")

for var in string.gmatch("x.y.z.wangliang", "[%w_]+") do
  print(var)
end
print("==============")
for var,d in string.gmatch("x.y.z.wangliang", "([%w_]+)(.?)") do
  print(var,d)
end

print("==============")
s = "hello world from Lua"
for w in string.gmatch(s, "%a+") do
  print(w)
end
print("==============")

t = {}
s = "from=world, to=Lua"
for k, v in string.gmatch(s, "(%w+)=(%w+)") do
  t[k] = v
  print(k,vq)
end

--==========================
function getfield (f)
  local v = _G    -- start with the table of globals
  for w in string.gmatch(f, "[%w_]+") do
    print(tostring(v), w)
    --assert(v,"v must not be nil")
    if not v then
      break
    end
    v = v[w]
  end
  return v
end

function setfield (f, v)
  local t = _G    -- start with the table of globals
  for w, d in string.gmatch(f, "([%w_]+)(.?)") do
    if d == "." then      -- not last field?
      t[w] = t[w] or {}   -- create table if absent
      t = t[w]            -- get the table
    else                  -- last field
      t[w] = v            -- do the assignment
    end
  end
end

print("x.y.z is " ..  tostring(getfield("wangliang.y.z")))
print("x is " ..  tostring(getfield("x")))
setfield("wangliang.y.z",30)
setfield("wangliang.y.z",nil)
print("x.y.z is " ..  tostring(getfield("wangliang.y.z")))
print("==============")

setfield("wangliang",nil)
for n in pairs(_G) do
  if n == "wangliang" then
    print(n)
  end
end

local stringMeta1 = getmetatable("hello")
local stringMeta2 = getmetatable("world")
print(stringMeta1 == stringMeta2) --true



Set = {}
Set.mt = {}    -- metatable for sets
function Set.new (t)   -- 2nd version
  local set = {}
  setmetatable(set, Set.mt)
  for _, l in ipairs(t) do set[l] = true end
  return set
end

function Set.union (a,b)
  if getmetatable(a) ~= a or getmetatable(b) ~= b then
  	error("attempt to 'add' a non-set value ")
  end
  local res = Set.new{}
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = true end
  return res
end

function Set.intersection (a,b)
  local res = Set.new{}
  for k,v in pairs(a) do
    res[k] = b[k]
    --print("k", k,v, b[k], res[k])
  end
  return res
end

function Set.tostring (set)
  local s = "{"
  local sep = ""
  for e in pairs(set) do
    s = s .. sep .. e 
    sep = ", "
  end
  return s .. "}"
end

function Set.print (s)
  print(Set.tostring(s))
end

Set.mt.__add = Set.union
Set.mt.__mul = Set.intersection

s1 = Set.new{10, 20, 30, 50}
s2 = Set.new{30, 1}
print(getmetatable(s1))          --> table: 00672B60
print(getmetatable(s2))          --> table: 00672B60

s3 = s1 + s2
Set.print(s3)             --> {1, 10, 20, 30, 50}
Set.print((s1 * s2))      --> 



Set.print((s2 + 8))      --> 



    
 
