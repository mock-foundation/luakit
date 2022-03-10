//
//  LuaError.swift
//  
//
//  Created by Егор Яковенко on 10.03.2022.
//

public enum LuaError: Int, Error {
    case runtime = 2
    case memoryAllocation = 4
    case messageHandler = 5
    case syntax = 3
    case yield = 1
    case file = 6
}
