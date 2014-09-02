-- rsync -r -v -p --exclude ".svn" letv/  xiaomi/


local function main()
  print("Hello world");
end


function factor(n)
	if n == 0 then
		return 1;
	else
	 return n * factor(n-1);
	end
end

print(factor(12));
--=========================
--注释
--[[ 
main()
--]]
--print(factor(3))

--=========================
-- type
-- 八大类型：thread/function/table/userdata/string/number/boolean/nil
print("Test type");
print(type(10))   --number
print(type("10")) --string
print(type(1.04)) --number
print(type(d))      --nil(d未定义)
print(type(type(d)))--string(d未定义)
print(type(print))  --function
print(type(false))  --boolean

--=========================
-- 类型赋值
print("-------------")
print(type(var))
var = 10
print(type(var))
var = print;
var(type(var))
var("hello")  

--=========================
-- false和nil为假，其余全部为真(包括空字符串和0)
flag = false
if flag then
	print("flag is true")
else 
	print("flag is false")
end
--=========================
-- 字符串
line = 'one string'
print(line)
line2 = string.gsub(line,"one","another");
print(line2)
print("one line\nanother line\ta tab\ta\\\ta\"")

--=========================
--不会转义（[[包含原始字符串）
page = [[
<html>
    <head>
    <title>New title</title>
    </head>
    <body>
      <a href="www.baidu.com"/>
    </body>
</html>

]]
print(page)

--不会转义（ [===[包含原始字符转，并且可以包含[和]）
expression =  [===[<a href="www.baidu.com"/>\na=b[i]]===]
print(expression)

--数字字符串运算
print("100"+3)
print("2.8" * 3)
print("4e2"+3)

--字符串连接符
print("4e2" .. 3)
print("3.90" .. 3)

num_string = " "
real_num = tonumber(num_string)
print("real_num is",real_num) --nil

num_string = "+10.9"
real_num = tonumber(num_string)
print("real_num is",real_num) --10.9



real_string = tostring(v)
print("real_string is",real_string) --nil

real_string = tostring(19)
print("real_string is",real_string) --19

is_equal = (10 == "10")
print("is equal?",is_equal) --false

is_equal = (tostring(10) == "10")
print("is equal?",is_equal) --true

is_equal = (10 == tonumber("10"))
print("is equal?",is_equal) --true

--数字和字符转换、逻辑判断
a = ("10" .. 0)
is_equal = ("100" == a)
print("is equal?",is_equal) --true

a = (10 .. 0)
is_equal = ("100" == a)
print("is equal?",is_equal) --true

is_equal = (10 == 10.0)
print("is equal?",is_equal) --true

is_equal = (10.12 == 10.1200)
print("is equal?",is_equal) --true

--字符串处理
num_count = #"hello world" --字符串长度
print("num_count is", num_count)

--=========================
-- number（没有整型）
num = 10;
num = 3e2;
print(num)
if num == nil then
	print("num is nil")
else
  print("num is",num) 
end

--=========================
-- FOR循环

--for index=1,select("#", ...) do
--	local temp = select(index, ...)
--	
--end

--for var in list do
--	
--end

--for key, var in ipairs(table) do
--	
--end

for var=1, 10, 2 do
	print(var)
end

for var=1, 10 do
  print(var)
end

--=========================
my_table = {}
my_table[19] = "wangliang"
my_table[19] = 122
my_table[19] = (my_table[19] + 1)
my_table[19] = (my_table[19] .. 1)
my_table["first_key"] ="first_value"
print(my_table["first_key"])  --first_value
print(my_table[19])           --1231
print(my_table[20])           --nil
print(my_table.first_key)     --nil(my_table.19报错)


arr = {}
for var=1, 4 do
	--arr[var] = io.read()
	arr[var] = var
end

for var=1, #arr do
	print(var .. " : " .. arr[var])
end

--数组可以用table来表示，只是用整数作为key就可以了
print(arr[#arr])        --打印最后一个元素
arr[#arr+1] = "new_one" --添加一个新元素到末尾
print(arr[#arr])        --打印最后一个元素

arr["key"] = "value"
-- arr = {1: 1, 2: 2, 3: 3, 4: 4,5: 'new_one', 'key': 'value'}
n = table.maxn(arr) --返回最大正向索引:5
print(n)  

arr[22] = 100
n = table.maxn(arr) --返回最大正向索引:22
print(n)
-- rsync -r -v -p --exclude ".svn" letv/  xiaomi/


local function main()
  print("Hello world");
end


function factor(n)
	if n == 0 then
		return 1;
	else
	 return n * factor(n-1);
	end
end
--=========================
--注释
--[[ 
main()
--]]
--print(factor(3))

--=========================
-- type
print(factor(12));
print(type(10))
print(type("10"))
print(type(1.04))
print(type(type(d)))
print(type(d))
print(type(print))
print(type(false))

--=========================
-- 类型赋值
print("-------------")
print(type(var))
var = 10
print(type(var))
var = print;
var(type(var))
var("hello")  

--=========================
-- 八大类型：thread/function/table/userdata/string/number/boolean/nil
-- false和nil为假，其余全部为真(包括空字符串和0)

--=========================
-- 字符串
line = 'one string'
print(line)
line2 = string.gsub(line,"one","another");
print(line2)
print("one line\nanother line\ta tab\ta\\\ta\"")

--=========================
--不会转义（[[包含原始字符串）
page = [[
<html>
    <head>
    <title>New title</title>
    </head>
    <body>
      <a href="www.baidu.com"/>
    </body>
</html>

]]
print(page)

--不会转义（ [===[包含原始字符转，并且可以包含[和]）
expression =  [===[<a href="www.baidu.com"/>\na=b[i]]===]
print(expression)

--数字字符串运算
print("100"+3)
print("2.8" * 3)
print("4e2"+3)

--字符串连接符
print("4e2" .. 3)
print("3.90" .. 3)

num_string = " "
real_num = tonumber(num_string)
print("real_num is",real_num) --nil

num_string = "+10.9"
real_num = tonumber(num_string)
print("real_num is",real_num) --10.9



real_string = tostring(v)
print("real_string is",real_string) --nil

real_string = tostring(19)
print("real_string is",real_string) --19

is_equal = (10 == "10")
print("is equal?",is_equal) --false

is_equal = (tostring(10) == "10")
print("is equal?",is_equal) --true

is_equal = (10 == tonumber("10"))
print("is equal?",is_equal) --true

--数字和字符转换、逻辑判断
a = ("10" .. 0)
is_equal = ("100" == a)
print("is equal?",is_equal) --true

a = (10 .. 0)
is_equal = ("100" == a)
print("is equal?",is_equal) --true

is_equal = (10 == 10.0)
print("is equal?",is_equal) --true

is_equal = (10.12 == 10.1200)
print("is equal?",is_equal) --true

--字符串处理
num_count = #"hello world" --字符串长度
print("num_count is", num_count)

--=========================
-- number（没有整型）
num = 10;
num = 3e2;
print(num)
if num == nil then
	print("num is nil")
else
  print("num is",num) 
end

--=========================
-- FOR循环

--for index=1,select("#", ...) do
--	local temp = select(index, ...)
--	
--end

--for var in list do
--	
--end

--for key, var in ipairs(table) do
--	
--end

for var=1, 10, 2 do
	print(var)
end

for var=1, 10 do
  print(var)
end

--=========================
my_table = {}
my_table[19] = "wangliang"
my_table[19] = 122
my_table[19] = (my_table[19] + 1)
my_table[19] = (my_table[19] .. 1)
my_table["first_key"] ="first_value"
print(my_table["first_key"])  --first_value
print(my_table[19])           --1231
print(my_table[20])           --nil
print(my_table.first_key)     --nil(my_table.19报错)


arr = {}
for var=1, 4 do
	--arr[var] = io.read()
	arr[var] = var
end

for var=1, #arr do
	print(var .. " : " .. arr[var])
end

--数组可以用table来表示，只是用整数作为key就可以了
print(arr[#arr])        --打印最后一个元素
arr[#arr+1] = "new_one" --添加一个新元素到末尾
print(arr[#arr])        --打印最后一个元素

arr["key"] = "value"
-- arr = {1: 1, 2: 2, 3: 3, 4: 4,5: 'new_one', 'key': 'value'}
n = table.maxn(arr) --返回最大正向索引:5
print(n)  

arr[22] = 100
n = table.maxn(arr) --返回最大正向索引:22
print(n)

arr2 = {x = 10} --等价于
--arr2.x = 10
--arr2["x"] = 10
print(arr2["x"])

i=10
arr3 = {[tostring(i+1)] = "19", [i+0] = "20", [i+1]= "21"}
print(arr3[11])
print(arr3["11"])

-- 问题：数组(table)如何迭代?
