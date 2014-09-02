--数组
a = {}
for var=-5, 5 do
	a[var]=10
end

print(a)

--矩阵
function print_matrix(mt)
  len = #mt
  for line=1, len do
    print("[" .. table.concat(mt[line],",") .. "]")
  end
end

mt={}
N=3;M=3
for i=1, N do
	mt[i]={}
	for j=1, M do
		mt[i][j] = i*j
	end
end

print_matrix(mt)


--Queue

function print_list(list)
	for key, var in pairs(list) do
		print("<" .. key .. ", " ..  var ..  ">")
	end
	
--	for var in list do
--		print(var)
--	end
end

My_Queue={}               
function My_Queue.new()
  return {first=0, last=-1} --first,last表示queue的首尾索引
end

function My_Queue.push_first(list, value)
  local firstIndex = list.first-1
  list.first = firstIndex
  list[firstIndex] = value
end

function My_Queue.push_last(queue, value)
	local lastIndex = queue.last + 1
	queue.last = lastIndex
	queue[lastIndex] = value
end

function My_Queue.pop_last(queue)
  local lastIndex = queue.last
  if lastIndex < queue.first then
  	error("queue is empty")
  end
  local lastValue = queue[lastIndex]
  queue[lastIndex] = nil
  queue.last = lastIndex - 1
  return lastValue
end


function My_Queue.pop_first(queue)
  local firstIndex = queue.first
  if firstIndex > queue.first then
    error("queue is empty")
  end
  local firstValue = queue[firstIndex]
  queue[firstIndex] = nil
  queue.first = firstIndex + 1
  return firstValue
end


list = My_Queue.new()
--print_list(list)
My_Queue.push_first(list,10)
My_Queue.push_first(list,20)
My_Queue.push_first(list,30)
My_Queue.push_last(list,-10)
My_Queue.push_last(list,-20)
My_Queue.push_last(list,-30)
print_list(list)

--<-1, 10>
--<-3, 30>
--<1, -20>
--<2, -30>
--<0, -10>
--<-2, 20>
--<first, -3>
--<last, 2>
print("-------print queue-------")
My_Queue.pop_first(list)
My_Queue.pop_last(list)
print_list(list)
  

function all_words()
	local line = io.read()
	local position = 1
	
	return function ()  --返回一个函数
		while line do
      local s, e = string.find(line,"%w+",position)
      if s then
      	position = e + 1
      	mysubtring = string.sub(line,s,e)
      	print("mysubtring: " .. mysubtring .. " for line: " ..line)
      	return mysubtring
      else 
      	line = io.read()
      	position = 1
      end
    end
    return nil
	end
end

--or line == nil
function all_words2(f)
  for line in io.lines() do
    --print("line is " .. line)
    if line == "" then
    	print("line is empty")
    	return;
    end
  	for word in string.gmatch(line,"%w+") do
  	   f(word)
  	end
  end
end

--for w in all_words() do --执行一个闭包多次
--	print(w)
--	if w == "exit" then
--		break
--	end
--end

-- ================usage 1================
--all_words2(print)

-- ================usage 2================
--local count = 0
--all_words2(function (w)
--	if "hello" == w then
--		count = count + 1
--		print(">> count is " .. count)
--	end
--end)
--print("count is " .. count)


--set
reserved = {
  ["while"] = true,     ["end"] = true,
  ["function"] = true,  ["local"] = true,
}
    
function values(t)
  local i = 0
  return function() i=i+1;return t[i] end
end

local words = {"while", "wangliang", "positive", "zhi", "local", "function"} 
for w in values(words) do
  if reserved[w] then
    -- `w' is a reserved word
    print("'" .. w .. "' is a(n) reserved word" )
  end
end


function create_reserved_set(list)
	local set = {}
	for _, var in ipairs(list) do
		set[var]  = true
	end
	return set
end

print("--------------" )
local reserved = create_reserved_set({"while", "function"})
for w in values(words) do
  if reserved[w] then
    -- `w' is a reserved word
    print("'" .. w .. "' is a(n) reserved word" )
  end
end


--for w in all_words() do
--  if reserved[w] then
--  -- `w' is a reserved word
--  end
--end


--bag
function insert(bag, element)
	bag[element] = (bag[element] or 0) + 1
end

function remove(bag, element)
  local count = bag[element]
  bag[element] = ((count and count > 1) and count - 1) or nil
end

--String Buffer
------------------实现方式1------------------------
local t = {}
for line in io.lines() do
  if "exit" == line then
    break
  end
  table.insert(t, line)
end
table.insert(t, "") --最后插入空串
--t[#t+1]=""        ----最后插入空串
local s = table.concat(t, "\n")
--以上两行等价于
--s = table.concat(t, "\n") .. "\n"
print("s is " .. s)
------------------------------------------  
    
function newStack ()
  return {""}   -- starts with an empty string
end

function addString (stack, s)
  --table.insert(stack, s)    -- push 's' into the the stack
  stack[#stack+1] = s
  --for i=table.getn(stack)-1, 1, -1 do
  for i=#stack-1, 1, -1 do
    --if string.len(stack[i]) > string.len(stack[i+1]) then
    if #stack[i] > #stack[i+1] then
      break
    end
    --stack[i] = stack[i] .. table.remove(stack)
    stack[i] = stack[i] .. stack[i+1]
    stack[i+1] = nil
  end
end

local test_string = {"a" , "b", "wangliang", "hello world"}
local s2 = newStack()
--for line in io.lines() do
for line in values(test_string) do
  addString(s2, line .. "\n")
end
print("--------------------")
print("s2 is " .. tostring(table.concat(s2)))    
print("--------------------")
--List
list=nil

list = {next = list, value = 10} --add first
list = {next = list, value = 20} --add first

--function add_last(list, last_value)
--  local last = { next=nil,  value = last_value}
--  --print(list, last_value)
--  list.next = last
--end
--
--function add_first(list, first_value)
--  --local first = { next=list,  value = first_value}
--  --list = first
--  list.next=list
--  list.value=first_value
--end

print("--------list---------")
local my_list = list
while my_list do
  print(my_list.value)
  my_list = my_list.next
end


local my_list2 = list --copy一份list
while my_list2 do
  print(my_list2.value)
  my_list2 = my_list2.next
end

--错误
--local my_list3 = list
--add_first(my_list3,100)
----add_first(my_list3,200)
--
--print("--------list---------")
--while my_list3 do
--  print(my_list3.value)
--  my_list3 = my_list3.next
--end