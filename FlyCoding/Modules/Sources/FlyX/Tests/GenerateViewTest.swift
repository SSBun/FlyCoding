//
//  GenerateViewTest.swift
//  BZCodeXTests
//
//  Created by caishilin on 2020/1/17.
//  Copyright © 2020 SSBun. All rights reserved.
//

import XCTest
@testable import FlyX

class GenerateViewTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_swift_make_uiview() {
        let code = "make(UIView,testView)"
        let answer =
        """
let testView = UIView()
testView.backgroundColor = <#color#>
<#superView#>.addSubview(testView)


"""
        if let snip = BaseSnip.init(label: code, spaceCount: 0, codeType: .swift) {
            XCTAssertEqual(answer, snip.code)
        } else {
            XCTFail("Analyze code failure.")
        }
    }
}
