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
        let snipList: [String: Snip.Type] = ["make": GenerateViewSnip.self,
                                             "snpm": SnapSnip.self,
                                             "snpu": SnapSnip.self,
                                             "snprm": SnapSnip.self,
                                             "masm": MasonrySinp.self,
                                             "masu": MasonrySinp.self,
                                             "masrm": MasonrySinp.self,
                                             "func": FunctionSnip.self,
                                             "f": FunctionSnip.self,
                                             "F": FunctionSnip.self,
                                             "anim": AnimationSnip.self,
                                             "layout": AutoLayoutSwift.self]
        guard let mark = regularMatch(text: label, expression: "^[a-zA-Z]+").first else {return nil}
        guard let snipType = snipList[mark] else {return nil}
        guard let snip = snipType.init(label: label, spaceCount: spaceCount, codeType: codeType) else {return nil}
        self.label = snip.label
        self.code = snip.code
        self.codeType = codeType
        self.lineCount = snip.lineCount
    }
}
