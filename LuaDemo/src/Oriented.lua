--http://blog.codingnow.com/cloud/LuaTips

Account = {
  balance=0,
  withdraw = function (self, v)
    self.balance = self.balance - v
  end
}

function Account:deposit (v)
  self.balance = self.balance + v
end

Account.deposit(Account, 400.00)
Account:withdraw(100.00)

print("balance is ".. Account.balance)



--创建多个账户
function Account:new (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

--==============================
local a = Account:new{balance = 0}
print("a's balance is " .. a.balance)
a:deposit(100.00)
print("a's balance is " .. a.balance)
getmetatable(a).__index.deposit(a, 100.00)
print("metatable of a is " .. tostring(getmetatable(a)))
print("metatable's __index of a is " .. tostring(getmetatable(a).__index))
print("a's balance is " .. a.balance)

--==============================
local b = Account:new()                  --基于Account的balance创建一个acount
print("b's balance is " .. b.balance)    -->
b.deposit(b, 3099)
print("b's balance is " .. b.balance)    -->
b:withdraw(9111)
print("b's balance is " .. b.balance)    -->
print("a's balance is " .. a.balance)
print("Account's balance is " .. Account.balance)

--==============================

Account = {balance = 0}

function Account:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Account:deposit (v)
  self.balance = self.balance + v
end

function Account:withdraw (v)
  if v > self.balance then error"insufficient funds" end
  self.balance = self.balance - v
end
--SpecialAccount是Account创建出来的对象，继承了Account字段和数据
SpecialAccount = Account:new()

--覆盖了Account的withdraw方法
function SpecialAccount:withdraw (v)
  if v - self.balance >= self:getLimit() then
    error("insufficient funds, limit is " .. self:getLimit())
  end
  self.balance = self.balance - v
end

function SpecialAccount:getLimit ()
  return self.limit or 0
end

--SpecialAccount是Account创建出来的对象，继承了Account字段和数据，new是从Account继承过来的
--并且s继承自SpecialAccount
s = SpecialAccount:new{limit=1000.00}
s:deposit(100.00)
s:withdraw(200.00)
print("s's balance is " .. s.balance)

print("SpecialAccount's balance is " .. SpecialAccount.balance .. " and limit is " .. SpecialAccount:getLimit())
--SpecialAccount:withdraw(100) -> insufficient funds, limit is 0, 调用SpecialAccount的withdraw方法
print("SpecialAccount's balance is " .. SpecialAccount.balance)

--修改s的limit，其他的不变
function s:getLimit ()
  return self.balance * 0.10
end


--封装
function newAccount (initialBalance)
  local self = {
    balance = initialBalance,
    LIM = 10000.00
  }

  local withdraw = function (v)
    self.balance = self.balance - v
  end

  local deposit = function (v)
    self.balance = self.balance + v
  end

  local extra = function ()
    if self.balance > self.LIM then
      return self.balance*0.10
    else
      return 0
    end
  end

  local getBalance = function ()
    return self.balance + extra()
  end

  return {
    withdraw = withdraw,
    deposit = deposit,
    getBalance = getBalance,
  }
end

acc1 = newAccount(100.00)
acc1.withdraw(40.00)
print(acc1.getBalance())     --> 60



--闭包
function newObject (value)
  return function (action, v)
    if action == "get" then return value
    elseif action == "set" then value = v
    else error("invalid action")
    end
  end
end

d = newObject(0)
print(d("get"))    --> 0
d("set", 10)
print(d("get"))    --> 10




-----serialize
function serialize(t)
  local mark={}
  local assign={}
  
  local function ser_table(tbl,parent)
    mark[tbl]=parent
    local tmp={}
    for k,v in pairs(tbl) do
      local key= type(k)=="number" and "["..k.."]" or k
      if type(v)=="table" then
        local dotkey= parent..(type(k)=="number" and key or "."..key)
        if mark[v] then
          table.insert(assign,dotkey.."="..mark[v])
        else
          table.insert(tmp, key.."="..ser_table(v,dotkey))
        end
      else
        table.insert(tmp, key.."="..v)
      end
    end
    return "{"..table.concat(tmp,",").."}"
  end
 
  return "do local ret="..ser_table(t,"ret")..table.concat(assign," ").." return ret end"
end
 
t = { a = 1, b = 2,}
g = { c = 3, d = 4,  t}
t.rt = g
 
print(serialize(t))




local setmetatable = setmetatable
 
--module "safe_set"
 
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


