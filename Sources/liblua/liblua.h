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
 alternative here in Swift, so that's why you only see comments here
 in the Swift version.
 */

// lua.h
#define luakit_getextraspace(L) lua_getextraspace(L)
#define luakit_tonumber(L,i) lua_tonumber(L,i)
#define luakit_tointeger(L,i) lua_tointeger(L,i)
#define luakit_pop(L,n) lua_pop(L,n)
#define luakit_newtable(L) lua_newtable(L)
#define luakit_register(L,n,f) lua_register(L,n,f)
#define luakit_pushcfunction(L,f) lua_pushcfunction(L,f)
#define luakit_isfunction(L,n) lua_isfunction(L,n)
#define luakit_istable(L,n) lua_istable(L,n)
#define luakit_islightuserdata(L,n) lua_islightuserdata(L,n)
#define luakit_isnil(L,n) lua_isnil(L,n)
#define luakit_isboolean(L,n) lua_isboolean(L,n)
#define luakit_isthread(L,n) lua_isthread(L,n)
#define luakit_isnone(L,n) lua_isnone(L,n)
#define luakit_isnoneornil(L, n) lua_isnoneornil(L, n)
#define luakit_pushliteral(L, s) lua_pushliteral(L, s)
#define luakit_pushglobaltable(L) lua_pushglobaltable(L)
#define luakit_tostring(L,i) lua_tostring(L,i)
#define luakit_insert(L,idx) lua_insert(L,idx)
#define luakit_remove(L,idx) lua_remove(L,idx)
#define luakit_replace(L,idx) lua_replace(L,idx)

#undef lua_getextraspace(L)
#undef lua_tonumber(L,i)
#undef lua_tointeger(L,i)
#undef lua_pop(L,n)
#undef lua_newtable(L)
#undef lua_register(L,n,f)
#undef lua_pushcfunction(L,f)
#undef lua_isfunction(L,n)
#undef lua_istable(L,n)
#undef lua_islightuserdata(L,n)
#undef lua_isnil(L,n)
#undef lua_isboolean(L,n)
#undef lua_isthread(L,n)
#undef lua_isnone(L,n)
#undef lua_isnoneornil(L, n)
#undef lua_pushliteral(L, s)
#undef lua_pushglobaltable(L)
#undef lua_tostring(L,i)
#undef lua_insert(L,idx)
#undef lua_remove(L,idx)
#undef lua_replace(L,idx)

// lauxlib.h
#define luakitL_newlibtable(L,l) luaL_newlibtable(L,l)
#define luakitL_newlib(L,l) luaL_newlib(L,l)
#define luakitL_argcheck(L, cond,arg,extramsg) luaL_argcheck(L, cond,arg,extramsg)
#define luakitL_argexpected(L,cond,arg,tname) luaL_argexpected(L,cond,arg,tname)
#define luakitL_checkstring(L,n) luaL_checkstring(L,n)
#define luakitL_optstring(L,n,d) luaL_optstring(L,n,d)
#define luakitL_typename(L,i) luaL_typename(L,i)
#define luakitL_dofile(L, fn) luaL_dofile(L, fn)
#define luakitL_dostring(L, s) luaL_dostring(L, s)
#define luakitL_getmetatable(L,n) luaL_getmetatable(L,n)
#define luakitL_loadbuffer(L,s,sz,n) luaL_loadbuffer(L,s,sz,n)

#undef luaL_newlibtable(L,l)
#undef luaL_newlib(L,l)
#undef luaL_argcheck(L, cond,arg,extramsg)
#undef luaL_argexpected(L,cond,arg,tname)
#undef luaL_checkstring(L,n)
#undef luaL_optstring(L,n,d)
#undef luaL_typename(L,i)
#undef luaL_dofile(L, fn)
#undef luaL_dostring(L, s)
#undef luaL_getmetatable(L,n)
#undef luaL_loadbuffer(L,s,sz,n)

// ...and replacing them with functions that Swift understands

/*
 lua.h
 */
void *lua_getextraspace(lua_State *L) {
    return luakit_getextraspace(L);
}

lua_Number lua_tonumber(lua_State *L, int index) {
    return luakit_tonumber(L, index);
}

lua_Integer lua_tointeger(lua_State *L, int index) {
    return luakit_tointeger(L, index);
}

void lua_pop(lua_State *L, int n) {
    luakit_pop(L, n);
}

void lua_newtable(lua_State *L) {
    luakit_newtable(L);
}

void lua_register(lua_State *L, const char *name, lua_CFunction f) {
    luakit_register(L, name, f);
}

void lua_pushcfunction(lua_State *L, lua_CFunction f) {
    luakit_pushcfunction(L, f);
}

int lua_isfunction(lua_State *L, int index) {
    return luakit_isfunction(L, index);
}

int lua_istable(lua_State *L, int index) {
    return luakit_istable(L, index);
}

int lua_islightuserdata(lua_State *L, int index) {
    return luakit_islightuserdata(L, index);
}

int lua_isnil(lua_State *L, int index) {
    return luakit_isnil(L, index);
}

int lua_isboolean(lua_State *L, int index) {
    return luakit_isboolean(L, index);
}

int lua_isthread(lua_State *L, int index) {
    return luakit_isthread(L, index);
}

int lua_isnone(lua_State *L, int index) {
    return luakit_isthread(L, index);
}

int lua_isnoneornil(lua_State *L, int index) {
    return luakit_isnoneornil(L, index);
}

const char *lua_pushliteral(lua_State *L, const char *s) {
    return luakit_pushliteral(L, s);
}

void lua_pushglobaltable(lua_State *L) {
    luakit_pushglobaltable(L);
}

const char *lua_tostring(lua_State *L, int index) {
    luakit_tostring(L, index);
}

void lua_insert(lua_State *L, int index) {
    luakit_insert(L, index);
}

void lua_remove(lua_State *L, int index) {
    luakit_remove(L, index);
}

void lua_replace(lua_State *L, int index) {
    luakit_replace(L, index);
}

/*
 lauxlib.h
 */

void luaL_newlib(lua_State *L, const luaL_Reg l[]) {
    luakitL_newlib(L, l);
}

void luaL_newlibtable(lua_State *L, const luaL_Reg l[]){
    luakitL_newlibtable(L, l);
}

void luaL_argcheck(lua_State *L,
                    int cond,
                    int arg,
                    const char *extramsg) {
    luakitL_argcheck(L, cond, arg, extramsg);
}

void luaL_argexpected(lua_State *L,
                       int cond,
                       int arg,
                       const char *tname) {
    luakitL_argexpected(L, cond, arg, tname);
}

const char *luaL_checkstring(lua_State *L, int arg) {
    luakitL_checkstring(L, arg);
}

const char *luaL_typename(lua_State *L, int index) {
    luakitL_typename(L, index);
}

int luaL_dofile(lua_State *L, const char *filename) {
    luakitL_dofile(L, filename);
}

int luaL_dostring(lua_State *L, const char *str) {
    luakitL_dostring(L, str);
}

int luaL_getmetatable(lua_State *L, const char *tname) {
    luakitL_getmetatable(L, tname);
}

int luaL_loadbuffer(lua_State *L,
                     const char *buff,
                     size_t sz,
                     const char *name) {
    luakitL_loadbuffer(L, buff, sz, name);
}

// also undefining non-needed stuff...

/*
 So yea, here is the same story with macros not being seen in Swift
 */

/*
 lua.h
 */
#undef luakit_getextraspace(L)
#undef luakit_tonumber(L,i)
#undef luakit_tointeger(L,i)
#undef luakit_pop(L,n)
#undef luakit_newtable(L)
#undef luakit_register(L,n,f)
#undef luakit_pushcfunction(L,f)
#undef luakit_isfunction(L,n)
#undef luakit_istable(L,n)
#undef luakit_islightuserdata(L,n)
#undef luakit_isnil(L,n)
#undef luakit_isboolean(L,n)
#undef luakit_isthread(L,n)
#undef luakit_isnone(L,n)
#undef luakit_isnoneornil(L, n)
#undef luakit_pushliteral(L, s)
#undef luakit_pushglobaltable(L)
#undef luakit_tostring(L,i)
#undef luakit_insert(L,idx)
#undef luakit_remove(L,idx)
#undef luakit_replace(L,idx)

/*
 lauxlib.h
 */

#undef luakitL_newlibtable(L,l)
#undef luakitL_newlib(L,l)
#undef luakitL_argcheck(L, cond,arg,extramsg)
#undef luakitL_argexpected(L,cond,arg,tname)
#undef luakitL_checkstring(L,n)
#undef luakitL_optstring(L,n,d)
#undef luakitL_typename(L,i)
#undef luakitL_dofile(L, fn)
#undef luakitL_dostring(L, s)
#undef luakitL_getmetatable(L,n)
#undef luakitL_loadbuffer(L,s,sz,n)

#endif /* liblua_h */
