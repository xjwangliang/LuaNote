local mytestlib=require("mytestlib")  --指定包名称
--将包含C函数的代码生成库文件，如Linux的so，或Windows的DLL，同时拷贝到Lua代码所在的当前目录，或者是LUA_CPATH环境变量所指向的目录，以便于Lua解析器可以正确定位到他们
--比如Lua\5.1\clibs\"，这里包含了所有Lua可调用的C库

--在调用时，必须是package.function
print(mytestlib.add(1.0,2.0))
print(mytestlib.sub(20.1,19))

--编译命令为
--g++ -c step3_2.cpp
--g++ -O2 -bundle -undefined dynamic_lookup -o mytestlib.so step3_2.o