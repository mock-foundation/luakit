//
//  liblua.h
//  
//
//  Created by Егор Яковенко on 04.03.2022.
//

#ifndef liblua_h
#define liblua_h

#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// Undefining macros...

/*
 This comment is for you, a guy that inspects a transpiled
 Swift header of this module. This section just
 contains #undef statements, and they don't have an alternative
 here in Swift, so that's why you don't see them in the Swift
 version.
 */
#undef lua_pushcfunction(L,f)
#undef lua_pop(L,n)
#undef luaL_checkstring(L,n)

// ...and replacing them with functions that Swift understands
void lua_pushcfunction(lua_State *L, lua_CFunction fn) {
    lua_pushcclosure(L, fn, 0);
}

void lua_pop(lua_State *L, int idx) {
    lua_settop(L, -(idx)-1);
}

const char *luaL_checkstring(lua_State *L, int arg) {
    luaL_checklstring(L, arg, NULL);
}

#endif /* liblua_h */
