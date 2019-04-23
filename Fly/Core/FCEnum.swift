//
//  FCEnum.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/15.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation

enum CommandError {
    case noneMatch
}

enum CommandResult {
    case success(CodeContext)
    case error(CommandError)
}

enum ParseResult {
    case success([(Command.Type, [Token])])
    case error(String?)
}

enum CodeSate {
    case normal
    case insert
    case remove
    case replace(String)
}
