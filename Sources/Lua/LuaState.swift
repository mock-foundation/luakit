//
//  LuaState.swift
//  
//
//  Created by Егор Яковенко on 11.03.2022.
//

import liblua

public class LuaState {
    var L: OpaquePointer?
    
    public func absIndex(_ index: Int32) -> Int32 {
        return lua_absindex(L, index)
    }
    
    public func arith(operation: Operation) {
        lua_arith(L, operation.rawValue)
    }
    
    @discardableResult
    public func atPanic(function: @escaping CFunction) -> CFunction {
        return lua_atpanic(L, function)
    }
    
    public func call(argCount: Int32, resultCount: Int32) {
        
    }
    
    public func getExtraSpace() {
        lua_getextraspace(L)
    }
    
    @available(*, deprecated, message: """
Using this function is alright, it represents the same one
used in Lua C API, but with name toNumber it does not seem
have a difference against toInteger, so use please toDouble
""", renamed: "toDouble")
    public func toNumber(index: Int32) -> Double {
        return lua_tonumber(L, index)
    }
    
    public func toDouble(index: Int32) -> Double {
        return lua_tonumber(L, index)
    }
    
    public func toInteger(index: Int32) -> Int64 {
        return lua_tointeger(L, index)
    }
    
    public func pop(at index: Int32) {
        lua_pop(L, index)
    }
    
    public func newTable() {
        lua_newtable(L)
    }
    
    public func register(name: String, function: @escaping CFunction) {
        lua_register(L, name, function)
    }
    
    public func pushCFunction(function: @escaping CFunction) {
        lua_pushcfunction(L, function)
    }
    
    public func isFunction(at index: Int32) -> Bool {
        return lua_isfunction(L, index) != 0
    }
    
    public func isTable(at index: Int32) -> Bool {
        return lua_istable(L, index) != 0
    }
    
    public func isLightUserData(at index: Int32) -> Bool {
        return lua_islightuserdata(L, index) != 0
    }
}
