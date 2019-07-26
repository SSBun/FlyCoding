//
//  FCEnum.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/15.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation

public enum CommandError {
    case noneMatch
}

public enum CommandResult {
    case success(CodeContext)
    case error(CommandError)
}

public enum ParseResult {
    case success([(Command.Type, [Token])])
    case error(String?)
}

public enum CodeSate {
    case normal
    case insert
    case remove
    case replace(String)
}
