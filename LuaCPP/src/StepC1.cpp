/*
 * StepC2.cpp
 *
 *  Created on: 2014-9-2
 *      Author: wangliang
 */
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <lua.hpp>
#include <lauxlib.h>
#include <lualib.h>

using namespace std;


static void stackDump(lua_State* L) {
	int top = lua_gettop(L);
	for (int i = 1; i <= top; ++i) {
		int t = lua_type(L, i);
		switch (t) {
			case LUA_TSTRING:
				printf("'%s'", lua_tostring(L,i));
				break;
			case LUA_TBOOLEAN:
				printf(lua_toboolean(L, i) ? "true" : "false");
				break;
			case LUA_TNUMBER:
				printf("%g", lua_tonumber(L,i));
				break;
			default:
				printf("%s", lua_typename(L, t));
				break;
		}
		printf("");
	}
	printf("\n");
}

int main3() {
	lua_State* L = luaL_newstate();
	lua_pushboolean(L, 1);
	lua_pushnumber(L, 10);
	lua_pushnil(L);
	lua_pushstring(L, "hello");
	stackDump(L); //true 10 nil 'hello'

	lua_pushvalue(L, -4);
	stackDump(L); //true 10 nil 'hello' true

	lua_replace(L, 3);
	stackDump(L); //true 10 true 'hello'

	lua_settop(L, 6);
	stackDump(L); //true 10 true 'hello' nil nil

	lua_remove(L, -3);
	stackDump(L); //true 10 true nil nil

	lua_settop(L, -5);
	stackDump(L); //true

	lua_close(L);
	return 0;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
int main(void) {
	const char* buff = "print(\"hello\")";
	int error;
	lua_State* L = luaL_newstate();
	/* luaL_openlibs函数是用于打开Lua中的所有标准库，如io库、string库等 */
	luaL_openlibs(L);
	/* luaL_loadbuffer编译了buff中的Lua代码，如果没有错误，则返回0，同时将编译后的程序块压入虚拟栈中 */
	/* lua_pcall函数会将程序块从栈中弹出，并在保护模式下运行该程序块。执行成功返回0，否则将错误信息压入栈中 */

//	luaL_loadbuffer(L, buff, strlen(buff), "line");
//	printf("After luaL_loadbuffer %d\n", lua_gettop(L)); // 1
//	lua_pcall(L,0,0,0);
//	printf("After lua_pcall %d\n", lua_gettop(L)); // 0（因为没有错误也没有返回值）

	error = luaL_loadbuffer(L, buff, strlen(buff), "line") || lua_pcall(L,0,0,0);
	int s = lua_gettop(L);
	cout << "lua_gettop: " << s << endl; // prints 0（因为没有错误也没有返回值）
	if (error) {
		/* lua_tostring函数中的-1，表示栈顶的索引值，栈底的索引值为1，以此类推。该函数将返回栈顶的错误信息，但是不会将其从栈中弹出 */
		fprintf(stderr, "%s", lua_tostring(L,-1));
		/* lua_pop是一个宏，用于从虚拟栈中弹出指定数量的元素，这里的1表示仅弹出栈顶的元素 */
		lua_pop(L, 1);
	}
	/* lua_close用于释放状态指针所引用的资源 */
	lua_close(L);
	return 0;
}

