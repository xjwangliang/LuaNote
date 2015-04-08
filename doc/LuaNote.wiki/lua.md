###switch

#####One
---
```
function table.indexOf(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
  return false
end

function table.contains(value, array)
    local index = table.indexOf(array, value, 1)
    if index then
      print("table.contains")
    	return true
    end
    return false
end

function range(value, numberPair)
  local count = #numberPair
  local max = tonumber(numberPair[1])
  local min = tonumber(numberPair[2])
  if tonumber(numberPair[1]) < tonumber(numberPair[2]) then
  	max = tonumber(numberPair[2])
  	min = tonumber(numberPair[1])
  end
  print("range", max, min, value)
  value = tonumber(value)
  if value >= min and value <= max then
  	return true
  end
  return false
end

  
function switch(term, cases)
  assert(type(cases) == "table")
  local casetype, caseparm, casebody
  for i,case in ipairs(cases) do
    assert(type(case) == "table" and #case == 3)
    casetype,caseparm,casebody = case[1],case[2],case[3]
    --print("casetype,caseparm,casebody", casetype,caseparm,casebody)
    assert(type(casetype) == "string" and type(casebody) == "function")
    if
        (casetype == "default")
      or  ((casetype == "eq" or casetype == "") and caseparm == term)
      or  ((casetype == "!eq" or casetype == "!") and not caseparm == term)
      or  (casetype == "in" and table.contains(term, caseparm))
      or  (casetype == "!in" and not table.contains(term, caseparm))
      or  (casetype == "range" and range(term, caseparm))
      or  (casetype == "!range" and not range(term, caseparm))
    then
      return casebody(term)
    else if
        (casetype == "default-fall")
      or  ((casetype == "eq-fall" or casetype == "fall") and caseparm == term)
      or  ((casetype == "!eq-fall" or casetype == "!-fall") and not caseparm == term)
      or  (casetype == "in-fall" and table.contains(term, caseparm))
      or  (casetype == "!in-fall" and not table.contains(term, caseparm))
      or  (casetype == "range-fall" and range(term, caseparm))
      or  (casetype == "!range-fall" and not range(term, caseparm))
    then
      casebody(term)
    end end
  end
end
```
####Usage 
```
local slotname = 5 				--print 'range 5'
--local slotname = "wangliang"	--print 'eq wangliang'
--local slotname = "liang"	    --print 'default equal liang'

switch(string.lower(slotname), {

  {"", "liang", function(_)
    print("default equal", _)
  end },
  
  {"eq", "wangliang", function(_)
    print("eq", _)
  end },
  
  {"range", {1, 10}, function(_)
    print("range", _)
  end },
  
  {"in", {"str","int","agl","cha","lck","con","mhp","mpp"}, function(_)
    print("in", _)
    
  end },
  
  {"default", "", function(_) print("default", _) end} --ie, do nothing
})

```

####Two
___
```
http://lua-users.org/wiki/SwitchObject

local function switch_isofcase(val, values)
  local vt = type(values)
  if vt == 'table' then
    for i, v in ipairs(values) do
      if v == val then return true end
    end
    return false
  end
  if vt == 'function' then
    return values(val)
  end
  return (values == val)
end

local function switch_test(switch, val)
  for i, case in ipairs(switch.cases) do
    if switch_isofcase(val, case.value) then
      if case.func then return case.func(val, case.value) end
      return case.ret
    end
  end
  if switch.default_func then
    return switch.default_func(val, 'default')
  end
  return switch.default_ret
end

local function switch_case(switch, value, fn)
  if type(fn) == 'function' then
    table.insert(switch.cases, {value = value, func = fn})
  else
    table.insert(switch.cases, {value = value, ret = fn})
  end
end

local function switch_default(switch, fn)
  if type(fn) == 'function' then
    switch.default_func = fn
  else
    switch.default_ret = fn
  end
end

function switch()
  local s = {}
  s.cases = {}
  s.test = switch_test
  s.case = switch_case
  s.default = switch_default
  return s
end

--==============================================================================
--- Testing part ---
--==============================================================================

local fn = function(a, b) print(tostring(a) .. ' in ' .. tostring(b)) end
local casefn = function(a)
  if type(a) == 'number' then
    return (a > 10)
  end
end

local s = switch()
s:case(0, fn)
s:case({1,2,3,4}, fn)
s:case(casefn, fn)
s:case({'banana', 'kiwi', 'coconut'}, fn)
s:case({'banana', 'pineapple', 'coconut'}, fn)
s:default(fn)

s:test(0)
s:test(2)
s:test(5)
s:test(15)
s:test('kiwi')
s:test('banana')
s:test('pineapple')
s:test(nil)

--==============================Output================================================
--0 in 0
--2 in table: 0x7fa3da723df0
--5 in default
--15 in function: 0x7fa3da7235f0
--kiwi in table: 0x7fa3da723fd0
--banana in table: 0x7fa3da723fd0
--pineapple in table: 0x7fa3da7240a0
--nil in default

```