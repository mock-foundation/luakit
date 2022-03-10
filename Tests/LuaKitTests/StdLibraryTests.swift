//
//  BasicTests.swift
//  
//
//  Created by Егор Яковенко on 04.03.2022.
//

import XCTest
@testable import LuaKit

final class StdLibraryTests: XCTestCase {
    func testDefaultSet() throws {
        let l = Lua(includeStd: true)
        try l.run(code: "print(math.abs(10))", name: "code")
    }
}
