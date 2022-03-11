//
//  LuaState.swift
//  
//
//  Created by Егор Яковенко on 11.03.2022.
//

import liblua

public class LuaState {
    /// The `L` name was chosen because it is the same name used in
    /// Lua documentation examples.
    var L: OpaquePointer?
    
    public init() {
        L = luaL_newstate()
    }
    
    public func absIndex(_ index: Int32) -> Int32 {
        return lua_absindex(L, index)
    }
    
    public func arith(operation: ValueOperation) {
        lua_arith(L, operation.rawValue)
    }
    
    @discardableResult
    public func atPanic(function: @escaping CFunction) -> CFunction {
        return lua_atpanic(L, function)
    }
    
    public func call(argCount: Int32, resultCount: Int32) {
        lua_call(L, argCount, resultCount)
    }
    
    public func callK(
        argCount: Int32,
        resultCount: Int32,
        context: KContext,
        function: @escaping KFunction
    ) {
        lua_callk(L, argCount, resultCount, context, function)
    }
    
    public func checkStack(elementCount: Int32) -> Bool {
        return lua_checkstack(L, elementCount) != 0
    }
    
    public func close() {
        lua_close(L)
    }
    
    public func closesSlot(at index: Int32) {
        lua_closeslot(L, index)
    }
    
    public func compare(at firstIndex: Int32, with secondIndex: Int32, operation: ComparationOperation) {
        lua_compare(L, firstIndex, secondIndex, operation.rawValue)
    }
    
    public func concat(count: Int32) {
        lua_concat(L, count)
    }
    
    public func copy(from: Int32, to: Int32) {
        lua_copy(L, from, to)
    }
    
    public func createTable(sequenceCount: Int32, otherCount: Int32) {
        lua_createtable(L, sequenceCount, otherCount)
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
    
    deinit {
        close()
    }
}
