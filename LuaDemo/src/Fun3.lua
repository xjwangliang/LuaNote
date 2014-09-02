arr={10, 89, 11,12}
for key, var in ipairs(arr) do
	print(key, var)
end

function find_max(arr)
  local max_index = #arr
  local max = arr[max_index]
  for key, var in ipairs(arr) do
    if var > max then
    	max = var; max_index = key
    end
  end
  return max_index, max
end


function print_table(my_table)
  if exp then
    error("my_table is nil")
    return	
  end
  print("my_table:")
	for key, var in pairs(my_table) do
		print("<"..  key .. ", " .. tostring(var) .. ">")
	end
end
print("find max(index, max_value) for arr:", find_max(arr))

test_value, index, max_value = 100, find_max(arr)
print("find max(index, max_value) for arr:", test_value, index, max_value)


function fun0()
end

function fun1()
  return "wang"
end

function fun2()
  return "a", "b"
end


print(fun0()) --print nothing
print(fun1()) --wang
print(fun2()) --a b

test_table = { fun1(), fun2(), fun0(),"test"}

print_table(test_table)
--print：（没有打印nil）
--<1, wang>
--<2, a>
--<4, test>

print(test_table[1]) --wang
print(test_table[2]) --a,不是a,b
print(test_table[3]) --nil 

n = table.maxn(test_table) --返回最大正向索引:5
print(n)


