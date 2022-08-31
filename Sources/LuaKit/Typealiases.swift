//
//  Typealiases.swift
//  
//
//  Created by Егор Яковенко on 11.03.2022.
//

#if os(macOS)
import liblua_macOS
#elseif os(Linux)
import liblua_linux
#endif

public typealias CFunction = lua_CFunction
public typealias KContext = lua_KContext
public typealias KFunction = lua_KFunction
public typealias Reg = luaL_Reg
