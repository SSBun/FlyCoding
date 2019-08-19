//
//  FCPrinter.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/15.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation

public struct Processor {
    public static func process(codeContext: CodeContext, codes: NSMutableArray) {
        var codeContext = codeContext
        codeContext.codes.sort {
            if $0.row >= $1.row {
                return false
            }
            return true
        }
        var offset = 0
        for code in codeContext.codes {
            switch code.state {
            case .normal:
                break
            case .insert:
                let insertRow = code.scope.row+code.executeOffset+offset
                let insertOffset = insertRow - codes.count
                if insertOffset >= 0 {
                    for _ in 0...(insertOffset) {
                        codes.add("")
                    }
                }
                codes.insert(code.value, at: insertRow)
                offset += 1
            case .remove:
                codes.removeObject(at: code.row+code.executeOffset+offset)
                offset -= 1
            case .replace(_):
                codes[code.row+code.executeOffset] = code.value
            }
        }
    }
}
