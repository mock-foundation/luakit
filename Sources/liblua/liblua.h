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

/*
 lua.h
 */
inline void *luakit_getextraspace(lua_State *L) {
    return lua_getextraspace(L);
}

inline lua_Number luakit_tonumber(lua_State *L, int index) {
    return lua_tonumber(L, index);
}

inline lua_Integer luakit_tointeger(lua_State *L, int index) {
    return lua_tointeger(L, index);
}

inline void luakit_pop(lua_State *L, int n) {
    lua_pop(L, n);
}

inline void luakit_newtable(lua_State *L) {
    lua_newtable(L);
}

inline void luakit_register(lua_State *L, const char *name, lua_CFunction f) {
    lua_register(L, name, f);
}

inline void luakit_pushcfunction(lua_State *L, lua_CFunction f) {
    lua_pushcfunction(L, f);
}

inline int luakit_isfunction(lua_State *L, int index) {
    return lua_isfunction(L, index);
}

inline int luakit_istable(lua_State *L, int index) {
    return lua_istable(L, index);
}

inline int luakit_islightuserdata(lua_State *L, int index) {
    return lua_islightuserdata(L, index);
}

inline int luakit_isnil(lua_State *L, int index) {
    return lua_isnil(L, index);
}

inline int luakit_isboolean(lua_State *L, int index) {
    return lua_isboolean(L, index);
}

inline int luakit_isthread(lua_State *L, int index) {
    return lua_isthread(L, index);
}

inline int luakit_isnone(lua_State *L, int index) {
    return lua_isthread(L, index);
}

inline int luakit_isnoneornil(lua_State *L, int index) {
    return lua_isnoneornil(L, index);
}

inline void luakit_pushglobaltable(lua_State *L) {
    lua_pushglobaltable(L);
}

inline const char *luakit_tostring(lua_State *L, int index) {
    lua_tostring(L, index);
}

inline void luakit_insert(lua_State *L, int index) {
    lua_insert(L, index);
}

inline void luakit_remove(lua_State *L, int index) {
    lua_remove(L, index);
}

inline void luakit_replace(lua_State *L, int index) {
    lua_replace(L, index);
}

inline void luakit_call(lua_State *L, int nargs, int nresults) {
    lua_call(L, nargs, nresults);
}

inline int luakit_pcall(lua_State *L, int nargs, int nresults, int msgh) {
    return lua_pcall(L, nargs, nresults, msgh);
}

/*
 lauxlib.h
 */

inline void luakitL_newlib(lua_State *L, const luaL_Reg l[]) {
    luaL_newlib(L, l);
}

inline void luakitL_newlibtable(lua_State *L, const luaL_Reg l[]){
    luaL_newlibtable(L, l);
}

inline void luakitL_argcheck(lua_State *L,
                    int cond,
                    int arg,
                    const char *extramsg) {
    luaL_argcheck(L, cond, arg, extramsg);
}

inline void luakitL_argexpected(lua_State *L,
                       int cond,
                       int arg,
                       const char *tname) {
    luaL_argexpected(L, cond, arg, tname);
}

inline const char *luakitL_checkstring(lua_State *L, int arg) {
    luaL_checkstring(L, arg);
}

inline const char *luakitL_typename(lua_State *L, int index) {
    luaL_typename(L, index);
}

inline int luakitL_dofile(lua_State *L, const char *filename) {
    luaL_dofile(L, filename);
}

inline int luakitL_dostring(lua_State *L, const char *str) {
    luaL_dostring(L, str);
}

inline int luakitL_getmetatable(lua_State *L, const char *tname) {
    luaL_getmetatable(L, tname);
}

inline int luakitL_loadbuffer(lua_State *L,
                     const char *buff,
                     size_t sz,
                     const char *name) {
    luaL_loadbuffer(L, buff, sz, name);
}

#endif /* liblua_h */
