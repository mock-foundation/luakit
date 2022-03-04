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
    public init(libs: [LuaLibrary]) {
        L = luaL_newstate()
        openLibs(libs)
    }
    
    public init() {
        L = luaL_newstate()
        
    }
    
    // MARK: - Public methods
    
    /// Opens libraries specified in `libs` parameter.
    /// - Parameter libs: Libraries to load.
    public func openLibs(_ libs: [LuaLibrary]) {
        for lib in libs {
            openLib(lib)
        }
    }
    
    /// Opens a library specified in `lib` parameter.
    /// - Parameter lib: A library to load.
    public func openLib(_ lib: LuaLibrary) {
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
        lua_pcallk(L, 0, 0, 0, 0, nil)
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
