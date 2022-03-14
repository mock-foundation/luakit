//
//  LuaError.swift
//  
//
//  Created by Егор Яковенко on 10.03.2022.
//

public enum LuaError: Int32, Error {
    case runtime = 2
    case memoryAllocation = 4
    case messageHandler = 5
    case syntax = 3
    case file = 6
}
