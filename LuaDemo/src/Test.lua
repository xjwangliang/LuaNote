--function fwrite(fmt,...)
--  print(arg.n)
--   return io.write(string.format(fmt,unpack({...})))
--end
--s,e = string.find("dubowen","bowe")
--print(fwrite(1,s,e))


--============================================================
--局部变量测试
--============================================================
function test_func()
  local a
  local f =  function ()
    a = a + 1
    return a
  end
  a = 10 --a要么为全局变量，要么先声明
  return f
end

testFunc = test_func()
print(testFunc())
print(testFunc())


--function myFunc()
--	print("execute outer myFunc")
--end
function test_func2()
  local myFunc
  local f =  function ()
    myFunc()
  end
  --myFunc要想被f访问到，要么声明成全局（可在函数外声明，也可以赋值给一个全局变量）
  --要么是局部的，但是不必须先声明
  myFunc = function ()
    print("execute myFunc")
  end
  return f
end

local testFunc2 = test_func2()
testFunc2()

--============================================================
--变长参数
--============================================================
--使用变长参数完成对nunmber列表求和
local function my_sum(...)
  local sum = 0
  for i,v in ipairs(...) do
    sum = sum + v
  end
  return sum
end

print(my_sum{1,1,2,nil,6,8}) -->11   说明nil后面的6,8都没有遍历到


--如果变长参数中故意传入nil
--那么就要使用select函数来访问变长参数列表了.
--select得以参数如果传入的是整数n, 返回的是第i个元素开始到最后一个元素结束的列表
--如果传入的是"#",则返回参数列表的总长度
print("=============")
function my_sum2(...)
  local sum = 0
  local arg
  for i=1,select('#',...) do

    --从输出结果可见,select(i,...)  返回的是第i个元素开始到最后一个元素结束的列表
    --print(select(i,...))    -->2 4   6   nil 5   8
    arg = select(i,...) --返回多个数
    if arg then         --只取第一个返回值
      sum = sum + arg
    end

  end
  return sum
end
print(my_sum2(2,4,6,nil,5,8)) -->25   说明nil后边的值都遍历到了


local tinsert = table.insert
local function my_append(x, ...)
        local t = {...}
        tinsert(t, x)
        return unpack(t)
end

local function my_append2(x, arg1, ...)
      print("my_append2",x,arg1)
        if arg1 == nil then
                return x
        else
                return arg1, my_append2(x, ...)
        end
end

local function my_print(...)
  --  ...:wangliang arg:table: 0x7fd943e14c30 type(...): string type(arg):table
  print("...:" .. tostring(...) .. " arg:" .. tostring(arg) .. " type(...): " .. type(...) .. " type(arg):" ..type(arg))
  --#arg:0 #...:9
  print("#arg:" .. (#arg) .. " #...:" ..(#...) )
  
  --print(unpack(arg))
--  print(arg[-1],arg[-2])
  print("------arg不知道是啥玩意-----")
  for i,v in pairs(arg) do
    print(i,v)
--    -1  io.stdout:setvbuf('no')
--    -3  jnlua
--    -2  -e
--    0 /Users/wangliang/adtworkspace/LuaDemo/src/Test.lua
  end
  print("-----------")
  print(tostring(...))            --取第一个
  print(...)                      --取所有
  print("参数的个数是:" .. #{...})  --#{...}表示参数的个数
  print("pre", ...)               --pre wangliang liang hello 12
  print(... , "post")             --wangliang post
  print(my_append2("post",...))   --wangliang liang hello 12  post
  print(my_append("post",...))    --wangliang liang hello 12  post
end

my_print("wangliang","liang", "hello",12)

print("==============")
local arr = {n=10;1,2}
print(#arr) --2
print("==============")



--============================================================
--链表
--============================================================
--table 特性
-- 使用table生成正序和倒序的链表

-- 使用table生成链表

local list = nil
local file = io.open("/Users/wangliang/adtworkspace/LuaDemo/src/readme","r")  -->打开本本件
print("file" , file)
local last = nil
--将本文件按行顺序读入list中
local lineCount=0
for line in file:lines() do
  lineCount = lineCount + 1
  local current = {next = nil, value = line}
  -- last must not be a local var
  if last then
  	last.next = current
  else
  	last = current
  end
  list = list or last
  last = current
  print(lineCount .. " " .. line .. " " .. "" .. tostring(list) .. " " .. tostring(list.next) .. " " ..tostring(last))
end
file:close()  -- 关闭文件

print(list)
--print(list.next)
--print(list.next.next)
-- 输出list
local l = list
while l do
  print(l.value)
  l = l.next
end

local path = "/Users/wangliang/adtworkspace/LuaDemo/src/readme"
---- 以下是按行倒序的方法
print("以下是按行倒序输出文件：\n")
local file = io.open(path,"r") -->打开本本件

list = nil  --清空list之前的内容

for line in file:lines() do
  list = {next = list, value = line}
end

file:close()  -- 关闭文件
-- 输出list
local l = list
while l do
  print(l.value)
  l = l.next
end


MyObject = {}

function MyObject:new (o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyObject:method1()
  print("method1 self is " .. tostring(self) .. " " .. tostring(MyObject))
  self:method2()
end 


function MyObject:method2()
  print("method2 self is " .. tostring(self) .. " " .. tostring(MyObject))
end 

SelfObject = {a = 10}
print("SelfObject is " .. tostring(SelfObject))
--MyObject.method1(SelfObject)

--MyObjectNew继承自MyObject
local MyObjectNew = MyObject:new()
print("MyObjectNew is " .. tostring(MyObjectNew))
MyObjectNew:method1()



