local mylib=require("mylib")
--local mylib=import("mylib")
print(mylib.lsin(10))

-- cc test.c -shared -o test.so -llua -lm
-- gcc  Step3_lib.c -llua  -fPIC -shared -o mylib.so
--gdb --args lua bug.lua

--gcc  Step3_lib.c  -shared -o mylib.so -lm
--cc test.c -shared -o test.so -llua -lm
