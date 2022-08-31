import Foundation

#if os(macOS)
import liblua_macOS
#elseif os(Linux)
import liblua_linux
#endif

/// A class that represents a Lua instance.
final public class Lua {
    var lua: LuaState
    
    // MARK: - Initializers
    
    /// Opens a Lua instance with provided standart libraries.
    /// - Parameter libs: Libs to open with Lua.
    public init(libs: [StandartLibrary]) {
        lua = LuaState()
        openStdLibs(libs)
    }
    
    /// Open a new Lua instance with no standart libraries.
    public init() {
        lua = LuaState()
    }
    
    /// Open a new Lua instance with a kit of standart
    /// libraries (if instructed to using `includeStd` argument).
    /// 
    /// Here is a list of standart libraries that will be opened:
    /// - Base
    /// - OS
    /// - I/O
    /// - Table
    /// - Coroutine
    /// - String
    /// - UTF8
    /// - Math
    /// - Debug
    /// - Package
    /// - Parameter includeStd: Whether to include standart libraries
    /// from the above list or not. If you specify false, then, well, just use
    /// ``init()``, it will be easier for you and everybody else 🤷
    public init(includeStd: Bool = false) {
        lua = LuaState()
        
        if includeStd {
            lua.openLibs()
        }
    }
    
    
    // MARK: - Public methods
    
    /// Opens standart libraries specified in `libs` parameter.
    /// - Parameter libs: Libraries to load.
    public func openStdLibs(_ libs: [StandartLibrary]) {
        for lib in libs {
            openStdLib(lib)
        }
    }
    
    /// Opens a standart library specified in `lib` parameter.
    /// - Parameter lib: A library to load.
    public func openStdLib(_ lib: StandartLibrary) {
        switch lib {
            case .base:
                lua.openBase()
            case .table:
                lua.openTable()
            case .io:
                lua.openIO()
            case .string:
                lua.openString()
            case .math:
                lua.openMath()
            case .os:
                lua.openOS()
            case .utf8:
                lua.openUTF8()
            case .debug:
                lua.openDebug()
            case .package:
                lua.openPackage()
            case .coroutine:
                lua.openCoroutine()
        }
    }
    
    // MARK: - Code interactions
    
    /// Runs code. Wow.
    /// - Parameters:
    ///   - code: Code to run.
    ///   - name: Name assigned to this exact piece of code.
    public func run(code: String, name: String) throws {
        try loadCode(code, name: name)
        try executeCode(argCount: 0, resultCount: 0)
    }
    
    /// Executes code specified in parameters.
    /// - Parameters:
    ///   - argCount: Amount of args that were pushed onto the stack.
    ///   - resultCount: Amount of results.
    func executeCode(argCount: Int32, resultCount: Int32) throws {
//        luakit_pcall(lua.L, 0, 0, 0)
        try lua.protectedCall(argCount: argCount, resultCount: resultCount)
    }
    
    /// Loads code into memory.
    /// - Parameters:
    ///   - code: Code to load.
    ///   - name: Name assigned to this exact piece of code.
    public func loadCode(_ code: String, name: String) throws {
        try lua.loadBuffer(code, name: name)
    }
    
    /// Registers a function to be used in Lua. An equivalent of `lua_register`.
    /// For more documentation look at <doc:Function-import-and-export> article.
    /// - Parameters:
    ///   - function: A function to be passed. Note that it should be a C function (exported to C as `@_cdecl`).
    ///   - name: How this function should be named in Lua.
    public func register(function: @escaping CFunction, name: String) {
        lua.register(name: name, function: function)
    }
    
    // MARK: - Stack manipulation
    
    func getLastErrorMessageFromStack() -> String {
        return lua.toString(from: -1) ?? "Unknown"
    }
    
    /// Pushes a `String` to the stack
    /// - Parameter string: A string to be pushed, nothin' strange here
    public func pushToStack(string: String) {
        lua.pushString(string)
    }
    
    /// Pushes a `Double` value to the stack
    /// - Parameter double: A Double to pushed, nothing suprizing
    public func pushToStack(double: Double) {
        lua.pushDouble(double)
    }
    
    /// Pushes a boolean value to the stack
    /// - Parameter bool: Well, a boolean to be pushed
    public func pushToStack(bool: Bool) {
        lua.pushBool(bool)
    }
    
    /// Pushes a `nil` value to the stack, because, well, no arguments
    /// were specified here.
    public func pushToStack() {
        lua.pushNil()
    }
    
    public func getStringFromStack(at index: Int32) throws -> String? {
        return lua.toString(from: index)
    }
    
    // MARK: - Static methods
    
    
    /// A helper function for functions that are exported into Lua. Returns a `Double` value from
    /// arguments passed to that function in case if it actually exists there.
    /// - Parameters:
    ///   - args: A `OpaquePointer` instance that is passed to the caller function.
    ///   - index: The argument index that should be returned. **Starts from 1.**
    ///   Please don't bully me, this is the Lua developer, it is him that did this
    /// - Returns: The wanted `Double` arg.
    public static func getArgAsDouble(args: OpaquePointer, index: Int32) -> Double {
        return luaL_checknumber(args, index)
    }
    
    /// A helper function for functions that are exported into Lua. Returns a `String` value from
    /// arguments passed to that function in case if it actually exists there.
    /// - Parameters:
    ///   - args: A `OpaquePointer` instance that is passed to the caller function.
    ///   - index: The argument index that should be returned. **Starts from 1.**
    ///   Please don't bully me, this is the Lua developer, it is him that did this
    /// - Returns: The wanted `String` arg
    public static func getArgAsString(args: OpaquePointer, index: Int32) -> String {
        return String(cString: luakitL_checkstring(args, index))
    }
}
