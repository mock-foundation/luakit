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
#undef lua_pushcfunction(L,f)
#undef lua_pop(L,n)

// ...and replacing them with functions that Swift understands
void lua_pushcfunction(lua_State *L, lua_CFunction fn) {
    lua_pushcclosure(L, fn, 0);
}

void lua_pop(lua_State *L, int idx) {
    lua_settop(L, -(idx)-1);
}

#endif /* liblua_h */
