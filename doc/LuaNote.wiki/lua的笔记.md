###__call
```
local a = {}
function a:Func()
   print("simonw")
end
c = {}
c.__call = function(t, ...)
   print("Start")
   t.Func()
   print("End")
end
setmetatable(a, c)
a()
```
结果： 

```
Start
simonw
End
```

https://github.com/kikito/tween.lua/blob/master/tween.lua#L339
https://github.com/kikito/middleclass/blob/master/middleclass.lua#L64

--a.Func()



###__newindex

```
--索引和值会设置到指定的表:
other = {}
t = setmetatable({}, { __newindex = other })
 --t里没有foo，查看__newindex，并把foo=3传给了other，并没有给t里的foo赋值
t.foo = 3
print(other.foo) -- 结果为3
print(t.foo)  -- 结果为nil

other.bar=10
t.bar=20
print(other.bar) -- 20
print(t.bar)     -- nil
```

结果

```
3
nil
20
nil
```

```
--当在t里创建新的索引时,如果值是number，这个值会平方，否则什么也不做

t = setmetatable({}, {
  __newindex = function(t, key, value)
    if type(value) == "number" then
      rawset(t, key, value * value)
    else
      rawset(t, key, value)
    end
  end
})

t.foo = "foo"
t.bar = 4
t.la = 10

print(t.foo)
print(t.bar)
print(t.la)
```

结果：

```
foo
16
100
```

###__tostring
```
t = setmetatable({ 1, 2, 3 }, {
  __tostring = function(t)
    sum = 0
    for _, v in pairs(t) do sum = sum + v end
    return "Sum: " .. sum
  end
})

print(t) -- prints out "Sum: 6"
```
###向量	
https://github.com/vrld/hump/blob/master/vector.lua