import liblua
import Foundation

/// A class that represents a Lua instance.
public class Lua {
    /// The `L` name was chosen because it is the same name used in
    /// Lua documentation examples.
    var L: OpaquePointer?
    
    // MARK: - Initializers
    
    /// Opens a Lua instance.
    /// - Parameter libs: Libs to open with Lua.
    public init(libs: [StandartLibrary]) {
        L = luaL_newstate()
        openStdLibs(libs)
    }
    
    public init() {
        L = luaL_newstate()
        luaL_openlibs(L)
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
    
    /// Just an equivalent of `lua_pop`, because actually `lua_pop`
    /// is a macro, and Swift doesn't like function macros.
    private func luaPop(idx: Int32) {
        lua_settop(L, -(idx)-1)
    }
    
    /// Runs code. Wow.
    /// - Parameters:
    ///   - code: Code to run.
    ///   - name: Name assigned to this exact piece of code.
    public func run(code: String, name: String) throws {
        try loadCode(code, name: name)
        try executeCode(args: 0, results: 0, errfunc: 0, context: 0)
    }
    
    /// Executes code specified in parameters.. Use this function **ONLY** if you know what are you doing.
    /// - Parameters:
    ///   - args: idk
    ///   - results: idk
    ///   - errfunc: idk
    ///   - context: some context idk
    public func executeCode(args: Int32, results: Int32, errfunc: Int32, context: Int) throws {
        if lua_pcallk(L, args, results, errfunc, context, nil) != 0 {
            if let message = lua_tolstring(L, -1, nil) {
                let messageString = String(cString: message, encoding: .utf8) ?? "Unknown"
                throw RuntimeError(message: messageString)
            } else {
                throw RuntimeError(message: "Unknown")
            }
        }
    }
    
    /// Loads code into memory. Use this function **ONLY** if you know what are you doing.
    /// - Parameters:
    ///   - code: Code to load.
    ///   - name: Name assigned to this exact piece of code.
    public func loadCode(_ code: String, name: String) throws {
        let result = luaL_loadbufferx(L, code, code.utf8.count, name, nil)
        guard result == 0 else {
            if let message = lua_tolstring(L, -1, nil) {
                let messageString = String(cString: message, encoding: .utf8) ?? "Unknown"
                throw CompilationError(message: messageString)
            } else {
                throw CompilationError(message: "Unknown")
            }
        }
    }
    
    deinit {
        lua_close(L)
    }
}
