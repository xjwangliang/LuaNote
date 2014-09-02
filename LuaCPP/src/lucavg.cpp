//============================================================================
// http://gamedevgeek.com/tutorials/calling-c-functions-from-lua/
// http://gamedevgeek.com/tutorials/calling-lua-functions/
// http://blog.csdn.net/Lodger007/article/details/837349
// http://blog.csdn.net/lodger007/article/details/836897
//============================================================================

#include <iostream>
#include <stdio.h>
#include <string.h>
#include <lua.hpp>
#include <lauxlib.h>
#include <lualib.h>

using namespace std;



/* 指向Lua解释器的指针 */
lua_State* L;

/**
 * 函数必须要以Lua解释器作为唯一的参数，并且返回一个唯一的整数
 */
static int average_func(lua_State *L) {
	/* 得到参数个数(lua_gettop函数返回栈顶的索引值。因为在Lua中栈是从1开始编号的，因此该函数获得的值就是参数的个数) */
	int n = lua_gettop(L);
	double sum = 0;
	int i;
	for (i = 1; i <= n; i++) {
		if (!lua_isnumber(L, i)) {
			lua_pushstring(L, "Incorrect argument to 'average'.参数必须位数字");
			lua_error(L);
		}
	}
	/* 循环求参数之和 */
	for (i = 1; i <= n; i++) {
		/* 求和 */
		sum += lua_tonumber(L, i);
	}
	/* 压入平均值 */
	lua_pushnumber(L, sum / n);
	/* 压入和 */
	lua_pushnumber(L, sum);
	/* 返回返回值的个数(返回的整数实际上是被压入栈的值的个数) */
	return 2;
}

/**
 * 保存文件为cpp。如果你直接使用C而不是C++，将文件名改为luaavg.c，然后将extern "C"删除。
 * g++ luaavg.cpp -llua -llualib -o luaavg
 */
int main(int argc, char *argv[]) {
	/* 初始化Lua */
	L = luaL_newstate();
	/* 载入Lua基本库 */
	luaL_openlibs(L);
	/* 注册函数 */
	lua_register(L, "average", average_func);
	/* 运行脚本 */
	luaL_dofile(L, "avg.lua");
	/* 清除Lua */
	lua_close(L);
	/* 暂停 */
	printf("Press enter to exit…");
	getchar();
	return 0;

}


//int main() {
//	cout << "!!!Hello World!!!" << endl; // prints !!!Hello World!!!
//	return 0;
//}
