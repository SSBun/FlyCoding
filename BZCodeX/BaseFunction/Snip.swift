//
//  Model.swift
//  Fly Coding
//
//  Created by SSBun on 21/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Foundation

// MARK: - Snip
/*!
 Snip protocol

 Any objects that complies with the protocol can extend a new command.
 */
public protocol Snip {
    var label: String {get}
    var code: String {get}
    var lineCount: Int {get}
    var codeType: CodeType {get}
    init?(label: String, spaceCount: Int, codeType: CodeType)
}

public class BaseSnip: Snip {
    public var label: String
    public var code: String
    public var lineCount: Int
    public var codeType: CodeType

    public required init?(label: String, spaceCount: Int, codeType: CodeType) {
        let snipList = ["make": GenerateViewSnip.self as Snip.Type,
                        "snpm": SnapSnip.self as Snip.Type,
                        "snpu": SnapSnip.self as Snip.Type,
                        "snprm": SnapSnip.self as Snip.Type,
                        "masm": MasonrySinp.self as Snip.Type,
                        "masu": MasonrySinp.self as Snip.Type,
                        "masrm": MasonrySinp.self as Snip.Type,
                        "func": FunctionSnip.self as Snip.Type,
                        "f": FunctionSnip.self as Snip.Type,
                        "anim": AnimationSnip.self as Snip.Type,
                        "layout": AutoLayoutSwift.self as Snip.Type
                        ]
        guard let mark = regularMatch(text: label, expression: "^[a-zA-Z]+").first else {return nil}
        guard let snipType = snipList[mark] else {return nil}
        guard let snip = snipType.init(label: label, spaceCount: spaceCount, codeType: codeType) else {return nil}
        self.label = snip.label
        self.code = snip.code
        self.codeType = codeType
        self.lineCount = snip.lineCount
    }
}
