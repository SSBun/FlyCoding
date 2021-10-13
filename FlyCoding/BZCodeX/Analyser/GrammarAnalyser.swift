//
//  GrammarAnalyser.swift
//  grammarAnalyser
//
//  Created by 蔡士林 on 2018/4/8.
//  Copyright © 2018年 蔡士林. All rights reserved.
//

import Foundation

enum GrammarTokenType {
    case mark
    case block
    case function
}

struct GrammarToken {
    var type: GrammarTokenType = .mark
    var contents: [GrammarToken] = []
    var scope: Scope = .zero
}

protocol GrammarAnalyser {
    var tokens: [Token] {get}
    init(tokens: [Token])
    func parseTokens() -> Any
}
