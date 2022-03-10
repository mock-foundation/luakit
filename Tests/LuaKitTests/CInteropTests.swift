//
//  CInteropTests.swift
//  
//
//  Created by Егор Яковенко on 06.03.2022.
//

import XCTest
@testable import LuaKit

@_cdecl("test_c_func")
func testCFunc(args: OpaquePointer?) -> Int32 {
    print("...and a print from Swift!")
    return 0
}

@_cdecl("second_test_c_func")
func secondTestCFunc(args: OpaquePointer?) -> Int32 {
    print("That's a second one actually")
    return 0
}

final class CInteropTests: XCTestCase {
    func testCFunctionLoadAndRun() throws {
        let l = Lua(includeStd: true)
        l.registerFunction(testCFunc, name: "test_c_func")
        try l.run(code: "print(\"A print from Lua...\") \n test_c_func()", name: "code")
    }
    
    func testMultipleCFunctionsLoadAndRun() throws {
        let l = Lua(includeStd: true)
        l.registerFunction(testCFunc(args:), name: "test_c_func")
        l.registerFunction(secondTestCFunc(args:), name: "second_test_c_func")
        try l.run(code: "print(\"A print from Lua...\") \n test_c_func() \n second_test_c_func()", name: "code")
    }
}
