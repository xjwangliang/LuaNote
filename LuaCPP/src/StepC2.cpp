/*
 * StepC2.cpp
 *
 *  Created on: 2014-9-2
 *      Author: wangliang
 */
#include <stdio.h>
#include <string.h>
#include <lua.hpp>
#include <lauxlib.h>
#include <lualib.h>

void load(lua_State* L, const char* fname, int* w, int* h) {
	/* luaL_loadfile编译了fname中的Lua代码，如果没有错误，则返回0，同时将编译后的程序块压入虚拟栈中 */
	/* lua_pcall函数会将程序块从栈中弹出，并在保护模式下运行该程序块。执行成功返回0，否则将错误信息压入栈中 */
	if (luaL_loadfile(L,fname) || lua_pcall(L,0,0,0)) {
		printf("Error Msg is %s.\n", lua_tostring(L,-1));
		return;
	}
	/* lua_getglobal是宏，其原型为：#define lua_getglobal(L,s)  lua_getfield(L, LUA_GLOBALSINDEX, (s)) */
	/* Lua代码中与之相应的全局变量值压入栈中 */
	lua_getglobal(L, "width");
	lua_getglobal(L, "height");
	if (!lua_isnumber(L, -2)) {
		printf("'width' should be a number\n");
		return;
	}
	if (!lua_isnumber(L, -1)) {
		printf("'height' should be a number\n");
		return;
	}
	*w = lua_tointeger(L,-2);
	*h = lua_tointeger(L,-1);
}

/**
 * 	构造table对象，同时初始化table的字段值，最后再将table对象赋值给Lua中的一个全局变量。

 lua_newtable是宏，其原型为：#define lua_newtable(L) lua_createtable(L, 0, 0)。
 调用该宏后，Lua会生成一个新的table对象并将其压入栈中。

 lua_setglobal是宏，其原型为：#define lua_setglobal(L,s) lua_setfield(L,LUA_GLOBALSINDEX,(s))。
 调用该宏后，Lua会将当前栈顶的值赋值给第二个参数指定的全局变量名。该宏在执行成功后，会将刚刚赋值的值从栈顶弹出。

 void lua_getfield(lua_State *L, int idx, const char *k);
 第二个参数是table变量在栈中的索引值，最后一个参数是table的键值，该函数执行成功后会将字段值压入栈中。

 void lua_setfield(lua_State *L, int idx, const char *k);
 第二个参数是table变量在栈中的索引值，最后一个参数是table的键名称，而字段值是通过上一条命令lua_pushnumber(L,0.4)压入到栈中的，
 该函数在执行成功后会将刚刚压入的字段值弹出栈。
 */
void load(lua_State* L) {
	/* new一个table，压到top */
	lua_newtable(L);
	printf("After lua_newtable %d\n", lua_gettop(L)); // 1
	lua_pushnumber(L, 0.3);
	printf("After lua_pushnumber %d\n", lua_gettop(L)); // 2
	lua_setfield(L, -2, "r");
	printf("After lua_setfield %d\n", lua_gettop(L)); // 1

	lua_pushnumber(L, 0.1);
	lua_setfield(L, -2, "g");

	lua_pushnumber(L, 0.4);
	lua_setfield(L, -2, "b");

	/* top设置给background，弹出top */
	lua_setglobal(L, "background");
	printf("After lua_setglobal %d\n", lua_gettop(L)); // 0

	/* background压到top */
	lua_getglobal(L, "background");
	printf("After lua_getglobal %d\n", lua_gettop(L)); // 1

	if (!lua_istable(L,-1)) {
		printf("'background' is not a table.\n");
		return;
	}
	/* 获取top(table)的r字段的值，然后将r压入top*/
	lua_getfield(L, -1, "r");
	printf("After lua_getfield %d\n", lua_gettop(L)); // 2
	if (!lua_isnumber(L, -1)) {
		printf("Invalid component in background color.\n");
		return;
	}
	int r = (int) (lua_tonumber(L,-1) * 255);
	lua_pop(L, 1);
	lua_getfield(L, -1, "g");
	if (!lua_isnumber(L, -1)) {
		printf("Invalid component in background color.\n");
		return;
	}
	int g = (int) (lua_tonumber(L,-1) * 255);
	lua_pop(L, 1);

	lua_getfield(L, -1, "b");
	if (!lua_isnumber(L, -1)) {
		printf("Invalid component in background color.\n");
		return;
	}
	int b = (int) (lua_tonumber(L,-1) * 255);
	printf("r = %d, g = %d, b = %d\n", r, g, b);
	lua_pop(L, 1);
	lua_pop(L, 1);
	return;
}

const char* lua_function_code = "function add(x, y) return x + y end";

void call_function(lua_State* L) {
	//luaL_dostring 等同于luaL_loadstring() || lua_pcall()
	//注意：在能够调用Lua函数之前必须执行Lua脚本，否则在后面实际调用Lua函数时会报错，
	//错误信息为:"attempt to call a nil value."
	if (luaL_dostring(L,lua_function_code)) {
		printf("Failed to run lua code.\n");
		return;
	}
	printf("After luaL_dostring %d\n", lua_gettop(L)); // 0（先push后pop）
	double x = 1.0, y = 2.3;
	lua_getglobal(L, "add");
	lua_pushnumber(L, x);
	lua_pushnumber(L, y);
	//下面的第二个参数表示带调用的lua函数存在两个参数。
	//第三个参数表示即使待调用的函数存在多个返回值，那么也只有一个在执行后会被压入栈中。
	//lua_pcall调用后，虚拟栈中的函数参数和函数名均被弹出。
	if (lua_pcall(L,2,1,0)) {
		printf("error is %s.\n", lua_tostring(L,-1));
		return;
	}
	printf("After lua_pcall %d\n", lua_gettop(L)); // 1
	//此时结果已经被压入栈中。
	if (!lua_isnumber(L, -1)) {
		printf("function 'add' must return a number.\n");
		return;
	}
	double ret = lua_tonumber(L,-1);
	lua_pop(L, -1);
	//弹出返回值。
	printf("The result of call function is %f.\n", ret);
}

int main() {
	lua_State* L = luaL_newstate();
	call_function(L);
	lua_close(L);
	return 0;

//  调用load(lua_State* L)
//	lua_State* L = luaL_newstate();
//	load(L);
//	lua_close(L);
//	return 0;

//	调用load(lua_State* L, const char* fname, int* w, int* h)：
//	lua_State* L = luaL_newstate();
//	int w, h;
//	load(L, "config2.lua", &w, &h);
//	printf("width = %d, height = %d\n", w, h);
//	lua_close(L);
//	return 0;
}

