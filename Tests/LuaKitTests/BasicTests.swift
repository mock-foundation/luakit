//
//  BasicTests.swift
//  
//
//  Created by Егор Яковенко on 04.03.2022.
//

import XCTest
@testable import LuaKit

final class BasicTests: XCTestCase {
    func testInit() throws {
        let l = Lua()
    }
    
    func testCodeLoading() throws {
        let l = Lua()
        try l.loadCode("a = 1", name: "Code")
    }
    
    func testCodeRunning() throws {
        let l = Lua()
        try l.run(code: """
function fact (n)
      if n == 0 then
        return 1
      else
        return n * fact(n-1)
      end
    end
    
    print("Using number 5:")
    print(fact(5))
""", name: "someCode")
    }
}
