//
//  Model.swift
//  Fly Coding
//
//  Created by SSBun on 21/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Foundation

// MARK: - Property
struct Property {
    static let allScopeMark = ["l": "let",
                               "v": "var",
                               "p": "private",
                               "P": "public",
                               "o": "open",
                               "f": "fileprivate",
                               "pl": "private let",
                               "pv": "private var",
                               "Pl": "public let",
                               "Pv": "public var",
                               "ol": "open let",
                               "ov": "open var",
                               "fl": "fileprivate let",
                               "fv": "fileprivate var",
                               "lv": "lazy var"]
    
    static let allSystemMark = ["@": "@objc",
                                "u": "unowned",
                                "w": "weak",
                                "c": "class"]
    
    let className: String
    let scope: String
    let defaultValue: String?
    var lineCount: Int = 1
    var instanceName: String = "<#name#>"
    
    init(className: String, scope: String, defaultValue: String?) {
        self.className = className
        self.scope = scope
        self.defaultValue = defaultValue
        if scope.contains("lazy") {
            self.lineCount = 3
        }
    }
    
    static func scopeWithShortcuts(_ p: String, isFunction: Bool = false) -> String? {
        if p.count == 0 {return nil}
        var systemMarks = [String]()
        var scopeMark = ""
        for c in p {
            if let mark = allSystemMark[String(c)] {
                systemMarks.append(mark)
            } else {
                scopeMark += String(c)
            }
        }
        if let scopeMarkStr = allScopeMark[scopeMark] {
            systemMarks.append(scopeMarkStr)
        } else {
            if !isFunction {
                systemMarks.append("let")
            }
        }
        return systemMarks.joined(separator:" ")
    }
}


// MARK: - Snip

protocol Snip {
    var label: String {get}
    var code: String {get}
    var lineCount: Int {get}
    
    init?(label: String, spaceCount: Int)
}


class BaseSnip: Snip {
    var label: String
    var code: String
    var lineCount: Int
    
    required init?(label: String, spaceCount: Int) {
        let snipList = ["make": GenerateViewSnip.self as Snip.Type,
                        "snpm": SnapSnip.self as Snip.Type,
                        "snpu": SnapSnip.self as Snip.Type,
                        "snprm": SnapSnip.self as Snip.Type,
                        "func": FunctionSnip.self as Snip.Type,
                        "anim": AnimationSnip.self as Snip.Type,
                        ]
        guard let mark = regularMatch(text: label, expression: "^[a-zA-Z]+").first else {return nil}
        guard let snipType = snipList[mark] else {return nil}
        guard let snip = snipType.init(label: label, spaceCount: spaceCount) else {return nil}
        self.label = snip.label
        self.code = snip.code
        self.lineCount = snip.lineCount
    }
}










