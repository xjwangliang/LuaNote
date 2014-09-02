/*
 * luaadd.cpp
 *
 *  Created on: 2014-9-1
 *      Author: wangliang
 */


/**
 * 	lua_getglobal()将一个Lua全局变量压入栈中。如果在Lua脚本中包含一个全局变量z，下面代码的功能就是得到它的值：

	lua_getglobal(L, "z");
	z = (int)lua_tointeger(L, -1);
	lua_pop(L, 1);


	lua_setglobal()函数能够设置全局变量地值。下面这段代码演示了如何将Lua全局变量z的值变为10：

	lua_pushnumber(L, 10);
	lua_setglobal(L, "z");

	应该记住：在Lua中，我们没有必要显式定义一个全局变量。如果全局变量不存在，调用lua_setglobal()将为你创建一个。
 */

#include <stdio.h>
extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
}

/* 指向Lua解释器的指针 */
lua_State* L;

int luaadd(int x, int y) {
	int sum;
	/* 通过名字得到Lua函数 */
	lua_getglobal(L, "add");
	/* 第一个参数 */
	lua_pushnumber(L, x);
	/* 第二个参数 */
	lua_pushnumber(L, y);
	/* 调用函数，告知有两个参数，一个返回值 */
	lua_call(L, 2, 1);
	/* 得到结果 */
	sum = (int) lua_tointeger(L, -1);
	lua_pop(L, 1);
	return sum;
}

int main(int argc, char *argv[]) {
	int sum;
	/* 初始化Lua */
	L = luaL_newstate();
	/* 载入Lua基本库 */
	luaL_openlibs(L);
	/* 载入脚本 */
	luaL_dofile(L, "add.lua");
	/* 调用Lua函数 */
	sum = luaadd(10, 15);
	/* 显示结果 */
	printf("The sum is %d\n", sum);
	/* 清除Lua */
	lua_close(L);
	/* 暂停 */
	printf("Press enter to exit…");
	getchar();
	return 0;
}

