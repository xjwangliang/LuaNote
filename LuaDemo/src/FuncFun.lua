--===================================
function derivative(f, delta)
	delta = delta or 1e-4
	return function (x)
	 return (f(x+delta) - f(x)) / delta;
	end
end
f= math.sin
d = derivative(f,0.000001)
print(d(math.pi/2))

print(math.sin(math.pi/2))


--===================================
--use function as member
Lib={}
Lib.add = function (x, y)
	return x+y
end

Lib.sub = function (x, y)
  return x - y
end

--another way
Lib={
  add = function (x ,y) return x + y end,
  sub = function (x ,y) return x - y end
}



local fact
fact = function (n)
	if n == 0 then
		return 1;
	end
	return n * fact(n-1)
end

--error
--local fact2 = function (n)
--  if n == 0 then
--    return 1;
--  end
--  return n * fact2(n-1)
--end

print(fact(10))


--===================================

function values(t)
	local i = 0
	return function() i=i+1;return t[i] end
end

arr= {12, 9, 23, 13}
for var in values(arr) do
	print(var)
end
--等价于
print("-------------")
iter = values(arr) --返回一个function
while true do
	local item = iter()
	if item == nil then
		break
	end
	print(item)
end

--===================================
myvar = 10
local myvar = 100
function add_Var()
  myvar = myvar + 1	--myvar = 101，操作的是局部变量
end
add_Var()
print(myvar)


--local n = io.read("*number")
--assert使用
--local n = assert(io.read("*number"),"invalid number")

local status, err = pcall(function ()
	error({code1 = 400})
end)
print("status is " .. tostring(status))
print("error code is " .. err.code1)

local status2, err2 = pcall(function ()
  --error({code1 = 400})
  return "hello"
end)
print("status is " .. tostring(status2))
print("error code is " .. err2)

--error("no .....")

--assert(load(ld,source,mode,env),message)

co = coroutine.create(function (a, b, c)
  print("yield result",coroutine.yield(a+b, b+c)) --yield result  1 2 3(返回的是resume提供的参数)
  print(a, b, c)
end
)

print("coroutine", coroutine.resume(co,1,2,3)) --true 3 5(返回3,5是resume遇到yield了，返回后者的参数列表)
print("coroutine", coroutine.resume(co,1,2,3)) --打印a, b, c的值，然后打印resume的返回值true

--生产者消费者
function receive (prod)
  local status, value = coroutine.resume(prod)
  return value
end

function send (x)
  coroutine.yield(x)
end

function producer ()
  return coroutine.create(function ()
    while true do
      local x = io.read()     -- produce new value
      send(x)
    end
  end)
end

function filter (prod)
  return coroutine.create(function ()
    local line = 1
    while true do
      local x = receive(prod)   -- get new value,并且让producer继续执行
      x = string.format("%5d %s", line, x)
      send(x)      -- send it to consumer
      line = line + 1
    end
  end)
end

function consumer (prod)
  while true do
    local x = receive(prod)   -- get new value
    io.write(x, "\n")          -- consume new value
  end
end

--consumer(filter(producer()))

--n:数组中前n个元素.数组中前n个元素的排列
function permgen (a, n)
  if n == 0 then
    printResult(a)
  else
    for i=1,n do

      -- put i-th element as the last one
      a[n], a[i] = a[i], a[n]

      -- generate all permutations of the other elements
      permgen(a, n - 1)

      -- restore i-th element
      a[n], a[i] = a[i], a[n]

    end
  end
end

function printResult (a)
  for i,v in ipairs(a) do
    io.write(v, " ")
  end
  io.write("\n")
end

permgen ({1,2,3,4}, 3)



function permgen (a, n)
  if n == 0 then
    coroutine.yield(a)
  else
    for i=1,n do

      -- put i-th element as the last one
      a[n], a[i] = a[i], a[n]

      -- generate all permutations of the other elements
      permgen(a, n - 1)

      -- restore i-th element
      a[n], a[i] = a[i], a[n]

    end
  end
end

function perm (a)
  local n = #a
  local co = coroutine.create(function () permgen(a, n) end)
  return function ()   -- iterator
    local code, res = coroutine.resume(co)
    return res
  end
end
--perm也可以这么写
function perm2 (a)
  return coroutine.wrap(function () permgen(a, n) end) --返回一个类似上面的迭代器的函数，但是这个迭代器函数执行不返回code，而是直接返回结果（没有错误的情况下，有则报错）
end

for p in perm{"a", "b", "c"} do
  --for p in perm({"a", "b", "c"}) do
  printResult(p)
end
