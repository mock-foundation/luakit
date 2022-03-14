//
//  LuaState.swift
//  
//
//  Created by Егор Яковенко on 11.03.2022.
//

#if os(macOS)
import liblua_macOS
#elseif os(Linux)
import liblua_linux
#endif

public class LuaState {
    /// The `L` name was chosen because it is the same name used in
    /// Lua documentation examples.
    var L: OpaquePointer?
    
    public init() {
        L = luaL_newstate()
    }
    
    /// Converts the acceptable index into an equivalent absolute index (that is,
    /// one that does not depend on the stack size).
    /// - Parameter index: An index to convert
    /// - Returns: A converted index
    public func absIndex(_ index: Int32) -> Int32 {
        return lua_absindex(L, index)
    }
    
    /// Performs an arithmetic or bitwise operation over the two values (or one, in
    /// the case of negations) at the top of the stack, with the value on the top
    /// being the second operand, pops these values, and pushes the result of the
    /// operation. The function follows the semantics of the corresponding Lua
    /// operator (that is, it may call metamethods).
    /// - Parameter operation: An operation to do
    public func arith(operation: ValueOperation) {
        lua_arith(L, operation.rawValue)
    }
    
    @discardableResult
    /// Sets a new panic function and returns the old one.
    /// - Parameter function: New panic function
    /// - Returns: Old panic function
    public func atPanic(function: @escaping CFunction) -> CFunction {
        return lua_atpanic(L, function)
    }
    
    /// Calls a function. Like regular Lua calls, lua_call respects the `__call`
    /// metamethod. So, here the word "function" means any callable
    /// value.
    ///
    /// # Overview
    ///
    /// To do a call you must use the following protocol: first, the function
    /// to be called is pushed onto the stack; then, the arguments to the call
    /// are pushed in direct order; that is, the first argument is pushed first.
    /// Finally you call ``LuaState/call(argCount:resultCount:multipleResults:)``;
    /// `argCount` is the number of arguments that you pushed onto the stack.
    /// When the function returns, all arguments and the function value are
    /// popped and the call results are pushed onto the stack. The number
    /// of results is adjusted to `resultCount`, unless `multipleResults` is `true`.
    /// In this case, all results from the function are pushed and `resultCount` is ignored;
    /// Lua takes care that the returned values fit into the stack space, but it
    /// does not ensure any extra space in the stack. The function results are
    /// pushed onto the stack in direct order (the first result is pushed first),
    /// so that after the call the last result is on the top of the stack.
    ///
    /// Any error while calling and running the function is propagated upwards
    /// (with a `longjmp`).
    ///
    /// The following example shows how the host program can do the
    /// equivalent to this Lua code:
    ///
    /// `a = f("how", t.x, 14)`
    ///
    ///  Here it is in Swift:
    ///
    /// ```swift
    /// let lua = LuaState()
    ///
    /// lua.getGlobal("f") // function to be called
    /// lua.pushLiteral("how") // 1st argument
    /// lua.getGlobal("t") // table to be indexed
    /// lua.getField(-1, "x") // push result of t.x (2nd arg)
    /// lua.remove(L, -2) // remove 't' from the stack
    /// lua.pushInt(L, 14) // 3rd argument
    /// lua.call(L, 3, 1) // call 'f' with 3 arguments and 1 result
    /// lua.setGlobal("a") // set global 'a'
    /// ```
    /// Note that the code above is balanced: at its end, the stack is back to its
    /// original configuration. This is considered good programming practice.
    /// - Parameters:
    ///   - argCount: Amount of arguments that were pushed onto the stack.
    ///   - resultCount: Amount of results.
    ///   - multipleResults: Whether to return all results or not. If `true`,
    ///   then `resultCount` is ignored.
    public func call(argCount: Int32, resultCount: Int32 = 1, multipleResults: Bool = false) throws {
        luakit_call(L, argCount, multipleResults ? LUA_MULTRET : resultCount)
    }
    
    public func protectedCall(argCount: Int32, resultCount: Int32 = 1, multipleResults: Bool = false, messageHandlerIndex: Int32 = 0) throws {
        let result = luakit_pcall(L, argCount, multipleResults ? LUA_MULTRET : resultCount, messageHandlerIndex)
        
        if result != 0 {
            throw LuaError(rawValue: result)!
        }
    }
    
    /// This function behaves exactly like ``LuaState/call(argCount:resultCount:multipleResults:)``,
    /// but allows the called function to yield (see [§4.5](https://www.lua.org/manual/5.4/manual.html#4.5))
    /// - Parameters:
    ///   - argCount: Amount of arguments that were pushed onto the stack.
    ///   - resultCount: Amount of results.
    ///   - multipleResults: Whether to return all results or not. If `true`,
    ///   then `resultCount` is ignored.
    ///   - context: TODO: fill this up
    ///   - function: TODO: fill this up
    public func callK(
        argCount: Int32,
        resultCount: Int32 = 1,
        multipleResults: Bool = false,
        context: KContext,
        function: @escaping KFunction
    ) {
        lua_callk(
            L,
            argCount,
            multipleResults ? LUA_MULTRET : resultCount,
            context,
            function)
    }
    
    /// Ensures that the stack has space for at least `elementCount` extra elements,
    /// that is, that you can safely push up to n values into it. It returns `false` if it cannot
    /// fulfill the request, either because it would cause the stack to be greater than
    /// a fixed maximum size (typically at least several thousand elements) or because
    /// it cannot allocate memory for the extra space. This function never shrinks the
    /// stack; if the stack already has space for the extra elements, it is left unchanged.
    /// - Parameter elementCount: Amount of extra elements to check.
    /// - Returns: Whether ``LuaState/checkStack(elementCount:)`` can
    /// fulfill the request.
    public func checkStack(elementCount: Int32) -> Bool {
        return lua_checkstack(L, elementCount) != 0
    }
    
    /// Close all active to-be-closed variables in the main thread, release all objects in
    /// the given Lua state (calling the corresponding garbage-collection metamethods,
    /// if any), and frees all dynamic memory used by this state.
    ///
    /// On several platforms, you may not need to call this function, because all resources
    /// are naturally released when the host program ends. On the other hand, long-running
    /// programs that create multiple states, such as daemons or web servers, will probably
    /// need to close states as soon as they are not needed.
    ///
    /// This function is also automatically called when ``LuaState`` instance is deallocated.
    public func close() {
        lua_close(L)
    }
    
    /// Close the to-be-closed slot at the given index and set its value to nil. The index
    /// must be the last index previously marked to be closed (see `lua_toclose`
    /// TODO: Fill this up) that is still active (that is, not closed yet).
    ///
    /// A `__close` metamethod cannot yield when called through this function.
    ///
    /// (Exceptionally, this function was introduced in Lua release 5.4.3. It is not present in previous 5.4 releases.)
    /// - Parameter index: Slot index that should be closed.
    public func closesSlot(at index: Int32) {
        lua_closeslot(L, index)
    }
    
    /// Compares two Lua values. Returns `true` if the value at index `firstIndex` satisfies
    /// op when compared with the value at `secondIndex`, following the semantics
    /// of the corresponding Lua operator (that is, it may call metamethods). Otherwise
    /// returns `false`. Also returns `false` if any of the indices is not valid.
    /// - Parameters:
    ///   - firstIndex: What to compare
    ///   - secondIndex: What to compare with
    ///   - operation: An operation to do
    public func compare(at firstIndex: Int32, with secondIndex: Int32, operation: ComparationOperation) -> Bool {
        return lua_compare(L, firstIndex, secondIndex, operation.rawValue) != 0
    }
    
    /// Concatenates the `count` values at the top of the stack, pops them, and leaves
    /// the result on the top. If `count` is 1, the result is the single value on the stack
    /// (that is, the function does nothing); if n is 0, the result is the empty string.
    /// Concatenation is performed following the usual semantics of Lua
    /// (see [§3.4.6](https://www.lua.org/manual/5.4/manual.html#3.4.6)).
    /// - Parameter count: How many values to concat.
    public func concat(count: Int32) {
        lua_concat(L, count)
    }
    
    /// Copies the element at index `from` into the valid index `to`, replacing
    /// the value at that position. Values at other positions are not affected.
    /// - Parameters:
    ///   - from: Where to copy from
    ///   - to: Where to copy to
    public func copy(from: Int32, to: Int32) {
        lua_copy(L, from, to)
    }
    
    /// Creates a new empty table and pushes it onto the stack. Parameter `sequenceCount`
    /// is a hint for how many elements the table will have as a sequence; parameter `otherCount`
    /// is a hint for how many other elements the table will have. Lua may use these hints to
    /// preallocate memory for the new table. This preallocation may help performance when you
    /// know in advance how many elements the table will have. Otherwise you can use the function
    /// ``LuaState/newTable()``.
    /// - Parameters:
    ///   - sequenceCount: A hint for how many elements the table will have as a sequence.
    ///   - otherCount: A hint for how many other elements the table will have.
    public func createTable(sequenceCount: Int32, otherCount: Int32) {
        lua_createtable(L, sequenceCount, otherCount)
    }
    
    public func getExtraSpace() {
        luakit_getextraspace(L)
    }
    
    @available(*, deprecated, message: """
Using this function is alright, it represents the same one
used in Lua C API, but with name toNumber it does not seem
have a difference against toInt, so use please toDouble
""", renamed: "toDouble")
    public func toNumber(index: Int32) -> Double {
        return luakit_tonumber(L, index)
    }
    
    public func toDouble(index: Int32) -> Double {
        return luakit_tonumber(L, index)
    }
    
    public func toInt(index: Int32) -> Int64 {
        return luakit_tointeger(L, index)
    }
    
    public func toString(index: Int32) -> String? {
        if let luaString = luakit_tostring(L, index) {
            return String(cString: luaString)
        } else {
            return nil
        }
    }
    
    public func pop(at index: Int32) {
        luakit_pop(L, index)
    }
    
    public func newTable() {
        luakit_newtable(L)
    }
    
    public func register(name: String, function: @escaping CFunction) {
        luakit_register(L, name, function)
    }
    
    public func pushCFunction(function: @escaping CFunction) {
        luakit_pushcfunction(L, function)
    }
    
    public func isFunction(at index: Int32) -> Bool {
        return luakit_isfunction(L, index) != 0
    }
    
    public func isTable(at index: Int32) -> Bool {
        return luakit_istable(L, index) != 0
    }
    
    public func isLightUserData(at index: Int32) -> Bool {
        return luakit_islightuserdata(L, index) != 0
    }
    
    public func pushNil() {
        lua_pushnil(L)
    }
    
    public func push(bool: Bool) {
        lua_pushboolean(L, bool ? 1 : 0)
    }
    
    public func push(double: Double) {
        lua_pushnumber(L, double)
    }
    
    public func push(string: String) {
        lua_pushstring(L, string)
    }
    
    /// Opens  base  standart library.
    public func openBase() {
        luaopen_base(L)
    }
    
    /// Opens table standart library.
    public func openTable() {
        luaopen_table(L)
    }
    
    /// Opens I/O standart library.
    public func openIO() {
        luaopen_io(L)
    }
    
    /// Opens string standart library.
    public func openString() {
        luaopen_string(L)
    }
    
    /// Opens mathematics standart library.
    public func openMath() {
        luaopen_math(L)
    }
    
    /// Opens OS standart library.
    public func openOS() {
        luaopen_os(L)
    }
    
    /// Opens  UTF-8 standart library.
    public func openUTF8() {
        luaopen_utf8(L)
    }
    
    /// Opens  debug  standart library.
    public func openDebug() {
        luaopen_debug(L)
    }
    
    /// Opens package standart library.
    public func openPackage() {
        luaopen_package(L)
    }
    
    /// Opens coroutines standart library.
    public func openCoroutine() {
        luaopen_coroutine(L)
    }
    /// Opens all standart libraries.
    public func openLibs() {
        luaL_openlibs(L)
    }
    
    public func loadBuffer(_ buffer: String, name: String) throws {
        let result = luakitL_loadbuffer(L, buffer, buffer.utf8.count, name)
        
        if let error = LuaError(rawValue: result) {
            throw error
        }
    }
    
    public func loadBuffer(_ buffer: String, size: Int, name: String) throws {
        let result = luakitL_loadbuffer(L, buffer, size, name)
        
        if let error = LuaError(rawValue: result) {
            throw error
        }
    }
    
    public func loadBufferX(_ buffer: String, size: Int, name: String, mode: LoadMode) throws {
        let result = luaL_loadbufferx(L, buffer, size, name, mode.rawValue)
        
        if let error = LuaError(rawValue: result) {
            throw error
        }
    }
    
    public func loadBufferX(_ buffer: String, name: String, mode: LoadMode) throws {
        let result = luaL_loadbufferx(L, buffer, buffer.utf8.count, name, mode.rawValue)
        
        if let error = LuaError(rawValue: result) {
            throw error
        }
    }
    
    deinit {
        close()
    }
}
