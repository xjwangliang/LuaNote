function print_table(my_table)
  if exp then
    error("my_table is nil")
    return  
  end
  --print("start print table")
  for key, var in pairs(my_table) do
    print("<"..  key .. ", " .. tostring(var) .. ">")
  end
end

--打印有序表(key是整数)
function print_table2(my_table)
  if exp then
    error("my_table is nil")
    return  
  end
--  print("my_table:")
  for key, var in ipairs(my_table) do
    print("<"..  key .. ", " .. tostring(var) .. ">")
  end
end

my_table={nil,"a", "b", 1, 'd',{1,2}}

print(#my_table)
print(print_table(my_table)) --nil不打印

--insert
table.insert(my_table, "hello")
table.insert(my_table, 1, "hello")

print(print_table(my_table)) --nil不打印

--remove
table.remove(my_table)
print(print_table(my_table)) --nil不打印

table.remove(my_table, 1)
print(print_table(my_table)) --nil不打印


lines = {first=4, second=2, third=3, program_C = 4, java=5} --无序的

--sort
new_table={}
for key, var in pairs(lines) do
	new_table[#new_table+1] = var
	--print(key, var)
end

table.sort(new_table) --把lines中的key排序
print(print_table(new_table))
print("==========")
--print(print_table2(lines))  --print nothing
print(print_table(lines))        

--sort2
function sortByKey(t, f)
  local new_table={}
	for key, var in pairs(t) do
    new_table[#new_table+1] = key
  end
  table.sort(new_table)
  local i=0
  return function()
    i=i+1
    print("i: " .. i)
    return new_table[i], t[new_table[i]]
  end
end
----把lines中的key排序
for name, line in sortByKey(lines) do
	print(name,line)
end


names = {"Peter", "Paul", "Mary"}
grades = {Mary = 10, Paul = 7, Peter = 8}
function sortbygrade (names, grades)
    table.sort(names, function (n1, n2)
       return grades[n1] > grades[n2]    -- compare the grades
    end)
end

sortbygrade(names,grades)
print("==========sortbygrade==========")
print_table2(names) --names排序，按照grades中的value排序
print("==========sortbygrade==========")

--连接
function reconcat(t,sep)
	if type(t) ~= "table" then
		return t
	end
	local res={}
	for var=1, #t do
	 res[var] = reconcat(t[var],sep)
	end
	return table.concat(res,sep)
end

print(reconcat({{"wang","liang"},"is","a","great",{{"man"}}}," ")) --wang liang is a great man


--闭包，lua和javascript的闭包类似
function newCounter()
     local i = 0
     return function () -- 匿名函数
          i = i + 1
          return i
     end
end
 
c1 = newCounter()
print("闭包------") --在同一个环境
print(c1()) 
print(c1())
print(c1())

c2 = newCounter()
print("闭包------")
print(c2()) 
print(c2())
print(c2())


function Fun1()
     local iVal = 10          -- upvalue
     function InnerFunc1()     -- 内嵌函数
          print(iVal)          --
     end
 
     function InnerFunc2()     -- 内嵌函数
          iVal = iVal + 10
     end
 
     return InnerFunc1, InnerFunc2
end
 
-- 将函数赋值给变量，此时变量a绑定了函数InnerFunc1, b绑定了函数InnerFunc2
local a, b = Fun1()
-- 调用a
a()          -->10
-- 调用b
b()          -->在b函数中修改了upvalue iVal
-- 调用a打印修改后的upvalue
a()          -->20

