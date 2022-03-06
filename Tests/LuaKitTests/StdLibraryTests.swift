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
        _ = Lua()
    }
}
