local setmetatable = setmetatable
 
module "safe_set"
 
local function enter(self, func)
  local count = self.count + 1
  self.count = count
  local val = {func, true}
  self[count] = val
  return function()
    val[1] = nil
    val[2] = nil
  end
end
 
local function empty(self)
  return self.count == 0
end
 
local weak_metatable = {__mode = "kv"}
 
function create()
  local que = {}
  que.enter = enter
  que.empty = empty
  que.ref = 0
  que.count = 0
  que.state = setmetatable({}, weak_metatable)
  return que
end
 
local function merge(self)
  local pos = 0
  for i = 1, self.count do
    if not self[i][2] then
      pos = pos + 1
    else
      self[i - pos] = self[i]
    end
  end
  local oldcount = self.count
  self.count = self.count - pos
  for i = oldcount, self.count + 1, -1 do
    self[i] = nil
  end
end
 
local function iter(state)
  local self = state[1]
  local current = state[2] + 1
  while current <= self.count do
    if self[current][2] then
      break
    end
    current = current + 1
  end
  if current <= self.count then
    state[2] = current
    return self[current][1]
  else
    self.ref = self.ref - 1
    if self.ref == 0 then
      merge(self)
    end
  end
end
 
function iterator(self)
  local ref = self.ref + 1
  self.ref = ref
 
  local state = self.state[ref] or {}
  self.state[ref] = state
 
  state[1] = self
  state[2] = 0
 
  return iter, state
end
