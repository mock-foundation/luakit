import liblua
import Foundation

/// A class that represents a Lua instance.
final public class Lua {
    /// The `L` name was chosen because it is the same name used in
    /// Lua documentation examples.
    var L: OpaquePointer?
    
    // MARK: - Initializers
    
    /// Opens a Lua instance with provided standart libraries.
    /// - Parameter libs: Libs to open with Lua.
    public init(libs: [StandartLibrary]) {
        L = luaL_newstate()
        openStdLibs(libs)
    }
    
    /// Open a new Lua instance with no standart libraries.
    public init() {
        L = luaL_newstate()
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
        L = luaL_newstate()
        
        if includeStd {
            luaL_openlibs(L)
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
                luaopen_base(L)
            case .table:
                luaopen_table(L)
            case .io:
                luaopen_io(L)
            case .string:
                luaopen_string(L)
            case .math:
                luaopen_math(L)
            case .os:
                luaopen_os(L)
            case .utf8:
                luaopen_utf8(L)
            case .debug:
                luaopen_debug(L)
            case .package:
                luaopen_package(L)
            case .coroutine:
                luaopen_coroutine(L)
        }
    }
    
    /// Runs code. Wow.
    /// - Parameters:
    ///   - code: Code to run.
    ///   - name: Name assigned to this exact piece of code.
    public func run(code: String, name: String) throws {
        try loadCode(code, name: name)
        try executeCode(args: 0, results: 0, errfunc: 0, context: 0)
    }
    
    /// Executes code specified in parameters.
    /// - Parameters:
    ///   - args: idk
    ///   - results: idk
    ///   - errfunc: idk
    ///   - context: some context idk
    func executeCode(args: Int32, results: Int32, errfunc: Int32, context: Int) throws {
        if lua_pcallk(L, args, results, errfunc, context, nil) != 0 {
            throw RuntimeError(message: getLastErrorMessageFromStack())
        }
    }
    
    /// Loads code into memory. Use this function **ONLY** if you know what are you doing.
    /// - Parameters:
    ///   - code: Code to load.
    ///   - name: Name assigned to this exact piece of code.
    func loadCode(_ code: String, name: String) throws {
        let result = luaL_loadbufferx(L, code, code.utf8.count, name, nil)
        guard result == 0 else {
            throw CompilationError(message: getLastErrorMessageFromStack())
        }
    }
    
    public func insertToStack(_ string: String) {
        
    }
    
    func getLastErrorMessageFromStack() -> String {
        let valueFromStack = lua_tolstring(L, -1, nil)
        var stringMessage: String {
            if valueFromStack == nil {
                return "Unknown"
            } else {
                return String(cString: valueFromStack!)
            }
        }
        return stringMessage
    }
    
    public func registerFunction(_ function: @escaping lua_CFunction, name: String) {
        lua_pushcfunction(L, function)
        lua_setglobal(L, name)
    }
    
    public func getStringFromStack(at location: Int32) throws -> String {
        let valueFromStack = lua_tolstring(L, location, nil)
        var stringMessage: String {
            if valueFromStack == nil {
                return "Unknown"
            } else {
                return String(cString: valueFromStack!)
            }
        }
        return stringMessage
    }
    
    deinit {
        lua_close(L)
    }
}
