#include <math.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

static int l_sin(lua_State *L) {
	double d = luaL_checknumber(L, 1);
	lua_pushnumber(L, sin(d));
	return 1;
}

static const struct luaL_Reg mylib[] = { { "lsin", l_sin }, { NULL, NULL } };

int luaopen_mylib(lua_State *L) {
	lua_newtable(L);
	luaL_setfuncs(L, mylib, 0);

	//luaL_openlib(L, "mylib", mylib, 0);
	return 1;
}
