#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include <stdlib.h>

//C调用C,通过lua的api

/**
 编译执行：
	gcc -c mylualib.c ; gcc -O2 -bundle -undefined dynamic_lookup -o mylualib.so mylualib.o
	gcc myluause.c  -llua  -o luause
	./luause

	如果lua_pushstring(L, "mylualib");改成lua_pushstring(L, "mylualib2");则报错：

	require_fail=module 'mylualib2' not found:
		no field package.preload['mylualib2']
		no file '/usr/local/share/lua/5.2/mylualib2.lua'
		no file '/usr/local/share/lua/5.2/mylualib2/init.lua'
		no file '/usr/local/lib/lua/5.2/mylualib2.lua'
		no file '/usr/local/lib/lua/5.2/mylualib2/init.lua'
		no file './mylualib2.lua'
		no file '/usr/local/lib/lua/5.2/mylualib2.so'
		no file '/usr/local/lib/lua/5.2/loadall.so'
		no file './mylualib2.so'（eclise运行.是项目目录，命令行是二进制文件目录）

 */
int main(int argc, char* const argv[]) {
    lua_State *L = luaL_newstate();
    luaL_requiref(L, "base", luaopen_base, 1);
    luaL_requiref(L, "package", luaopen_package, 1);
    lua_getglobal(L, "require");
    if (!lua_isfunction(L, -1)) {
        printf("require not found\n");
        return 2;
    }
    lua_pushstring(L, "mylualib");
    if (lua_pcall(L, 1, 1, 0) != LUA_OK) {
        printf("require_fail=%s\n", lua_tostring(L, -1));
        return 3;
    }
    lua_getfield(L, -1, "add");
    lua_pushinteger(L, 2);
    lua_pushinteger(L, 3);
    lua_pcall(L, 2, 1, 0);
    int n = luaL_checkint(L, -1);
    printf("2 + 3 =%d\n", n);
    return 0;
}
