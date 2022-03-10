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

// Getting macros ready...

/*
 This comment is for you, a guy that inspects a transpiled
 Swift header of this module. This section just
 contains #undef and #define statements, and they don't have an
 alternative here in Swift, so that's why you don't see them in
 the Swift version.
 */
#define luakit_pushcfunction(L,f) lua_pushcfunction(L,f)
#define luakit_pop(L,n) lua_pop(L,n)
#define luakitL_checkstring(L,n) luaL_checkstring(L,n)

#undef lua_pushcfunction(L,f)
#undef lua_pop(L,n)
#undef luaL_checkstring(L,n)

// ...and replacing them with functions that Swift understands
void lua_pushcfunction(lua_State *L, lua_CFunction fn) {
    luakit_pushcfunction(L, fn);
}

void lua_pop(lua_State *L, int idx) {
    luakit_pop(L, idx);
}

const char *luaL_checkstring(lua_State *L, int arg) {
    luakitL_checkstring(L, arg);
}

// also undefining non-needed stuff...

/*
 So yea, here is the same story with macros not being seen in Swift
 */
#undef luakit_pushcfunction(L,f)
#undef luakit_pop(L,n)
#undef luakitL_checkstring(L,n)

#endif /* liblua_h */
