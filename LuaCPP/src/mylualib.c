#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static int hello_c (lua_State *L) {
    const char * from_lua = lua_tostring(L,1);
    printf("Lua: %s\n",from_lua);
    lua_pushstring(L,"Hi Lua, nice to meet you");
    return 1;
}

static int add(lua_State *L) {
    int x = luaL_checkint(L, -2);
    int y = luaL_checkint(L, -1);
    lua_pushinteger(L, x + y);
    return 1;
}

static const struct luaL_Reg mylualib [] = {
    {"hello_c", hello_c},
    {"add", add},
    {NULL, NULL} /* sentinel */
};
int luaopen_mylualib (lua_State *L) {
    /* register a array of c functions exported to lua */
    luaL_newlib(L, mylualib);
    lua_pushvalue(L, -1);
    /* the module name(注意它和luaopen_xxx中xxx不同不必和文件名相同，也不必和xxx相同 */
    /* require必须和xxx相同) ，mylualib2是个require是全局变量也是返回值 */
    lua_setglobal(L, "mylualib2");
    return 1;
}
