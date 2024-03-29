//
//  InputHandle.swift
//  Fly
//
//  Created by caishilin on 2019/7/26.
//  Copyright © 2019 SSBun. All rights reserved.
//

import Foundation

public enum CodeType {
    case swift
    /// Objective-C
    case oc
}

public struct InputHandle {
    
}

public extension InputHandle {
    
    /// Checks the language type of the code file.
    ///
    /// - Parameter lines: codes
    /// - Returns: code type
    static func analyzeCodeType(codeLines lines: NSMutableArray) -> CodeType {
        guard let codeLines = lines as? [String] else {return .swift}
        var maxLineNumber = 0
        if codeLines.count <= 50 {
            maxLineNumber = codeLines.count
        } else {
            maxLineNumber = 50
        }
        let prefix50Lines = codeLines[0..<maxLineNumber]
        for line in prefix50Lines {
            if line.contains(".swift") {
                return .swift
            }
            if line.contains(".h") || line.contains(".m") {
                return .oc
            }
        }
        return .swift
    }
    
    /// Code indentation
    ///
    /// - Parameter code: The code to be analysed.
    /// - Returns: indentation length
    static func indentationLength(code: String) -> Int {
        return regularMatchRange(text: code, expression: "[\\S]+?").first?.location ?? 0
    }
}
