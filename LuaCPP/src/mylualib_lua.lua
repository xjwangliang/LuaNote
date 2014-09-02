local lib = require("mylualib")
hi = mylualib2.hello_c("I'm Lua")
print(hi)
--效果和上面一样
hi = lib.hello_c("I'm Lua")
print(hi)

print(lib.add(10,30))
--//http://blog.csdn.net/hanhuili/article/details/8496927
--lua: multiple Lua VMs detected 
--gcc -c mylualib.c ; gcc -O2 -bundle -undefined dynamic_lookup -o mylualib.so mylualib.o