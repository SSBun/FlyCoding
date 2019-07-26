//
//  FCUtils.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/15.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation


func correctParamType(tokens: [Token], types: [TokenType]) -> Bool {
    if tokens.count != types.count {
        return false
    }
    for v in zip(tokens, types) {
        if v.0.kind != v.1 {
            return false
        }
    }
    return true
}

func ~= (left: [Token], right: [TokenType]) -> Bool {
    return correctParamType(tokens: left, types: right)
}

public func sortIndex(one: Int, two: Int) -> (Int, Int) {
    return one <= two ? (one, two) : (two, one)
}

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            guard index < self.count, index >= 0 else {return nil}
            return self[index]
        }
        set {
            guard index < self.count, index >= 0, let value = newValue else {return}
            self[index] = value
        }
    }
}

public func ROW(_ row: Int) -> Int {
    return row - 1
}
