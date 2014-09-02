local mylib=require("mylib")
--local mylib=import("mylib")
print(mylib.lsin(10))

--可能linux的编译命令是
--  gcc mylib.c -fPIC -shared -o libmylib.so
--  (gdb --args lua bug.lua?)

--mac的编译命令为
--  gcc -c Step3_lib.c
--  gcc -O2 -bundle -undefined dynamic_lookup -o mylib.so Step3_lib.o

-- luaopen_xxx    :xxx是module的名字
-- require("xxx") :xxx是文件的名字(不包括后缀名字)，同时也是module的名字
-- 所以最终编译的so文件必须和xxx相同，为xxx.so





