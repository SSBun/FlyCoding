//
//  PropertyTest.swift
//  BZCodeXTests
//
//  Created by caishilin on 2019/7/26.
//  Copyright © 2019 SSBun. All rights reserved.
//

import XCTest
@testable import BZCodeX

class PropertyTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_swift_property_setInstanceName() {
        let code = "pl.UIImageView/posterView"
        let answer =
"""
private let posterView: UIImageView
"""
        let properties = decoderPropertyCode(code: code, codeType: .swift)
        let result = generatePropertyCode(property: properties[0], spaceCount: 0)
        XCTAssertEqual(answer, result)
    }

    func test_swift_property_setInstanceNameAndDefaultValue() {
        let code = "pl.{100}/age"
        let answer =
        """
private let age = 100
"""
        let properties = decoderPropertyCode(code: code, codeType: .swift)
        let result = generatePropertyCode(property: properties[0], spaceCount: 0)
        XCTAssertEqual(answer, result)
    }

    func test_swift_property_privateLazyVar() {
        let code = "plv.UIImageView"
        let answer =
        """
private lazy var <#name#>: UIImageView = {
    <#code#>
}()
"""
        let properties = decoderPropertyCode(code: code, codeType: .swift)
        let result = generatePropertyCode(property: properties[0], spaceCount: 0)
        XCTAssertEqual(answer, result)
    }

    func test_swift_property_privateLetBlock() {
        let code = "plb.UIImageView"
        let answer =
        """
private let <#name#>: UIImageView = {
    <#code#>
}()
"""
        let properties = decoderPropertyCode(code: code, codeType: .swift)
        let result = generatePropertyCode(property: properties[0], spaceCount: 0)
        XCTAssertEqual(answer, result)
    }
}
