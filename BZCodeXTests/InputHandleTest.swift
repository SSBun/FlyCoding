//
//  InputHandleTest.swift
//  BZCodeXTests
//
//  Created by caishilin on 2019/7/26.
//  Copyright © 2019 SSBun. All rights reserved.
//

import XCTest
@testable import BZCodeX

class InputHandleTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_code_indentation_lenght() {
        let testCodes = [(0, "B B  B  B  B"), (1, " B  BB"), (2, "  BBBBBB")]
        let correct = testCodes.reduce(into: true) {
            $0 = $0 && ($1.0 == InputHandle.indentationLength(code: $1.1))
        }
        XCTAssert(correct);
    }
    
    func test_code_indentation_empty_string() {
        XCTAssert(0 == InputHandle.indentationLength(code: ""))
    }
    
    func test_judge_code_type() {
        let case1 = InputHandle.analyzeCodeType(codeLines: NSMutableArray(array: ["//InputHandleTest.swift"])) == .swift
        let case2 = InputHandle.analyzeCodeType(codeLines: NSMutableArray(array: [Data()])) == .swift
        let case3 = InputHandle.analyzeCodeType(codeLines: NSMutableArray(array: ["//InputHandleTest.h"])) == .oc
        let case4 = InputHandle.analyzeCodeType(codeLines: NSMutableArray(array: ["//InputHandleTest.m"])) == .oc
        let case5 = InputHandle.analyzeCodeType(codeLines: NSMutableArray(array: ["//InputHandleTest.h", "TestViewController.swift"])) == .oc
        let case6 = InputHandle.analyzeCodeType(codeLines: NSMutableArray(array: ["//InputHandleTest.swift", "TestViewController.h"])) == .swift
        XCTAssertTrue(case1 && case2 && case3 && case4 && case5 && case6)
    }
}
