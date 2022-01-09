//
//  ScriptBoxTest.swift
//  BZCodeXTests
//
//  Created by caishilin on 2021/12/28.
//  Copyright © 2021 SSBun. All rights reserved.
//

import XCTest
@testable import BZCodeX

class ScriptBoxTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_run_script() throws {
        let result = try ScriptMagicBox().execute(commands: "ls", "-1")
        print(result ?? "")
        XCTAssert(result != nil)
    }
}
