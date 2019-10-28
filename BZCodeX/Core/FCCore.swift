//
//  FCProtocol.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/15.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation

public protocol Executor {
    static func execute(context: CodeContext, params: [Token]) -> CommandResult
}

public protocol Command {
    static var keyWord: String {get}
    static var alias: String {get}
    static var executor: Executor.Type {get}
    static var options: [Command.Type] {get}
    static func execute(context: CodeContext, params: [Token]) -> CommandResult
}

public struct Code {
    var state: CodeSate
    var scope: Scope
    var value: String
    var executeOffset: Int = 0
    var row: Int {
        get {
            return scope.row
        }
        set {
            scope.row = newValue
        }
    }
    
    init(state: CodeSate, scope: Scope, value: String, executeOffset: Int = 0) {
        self.state = state
        self.scope = scope
        self.value = value
        self.executeOffset = executeOffset
    }
}

public struct CodeContext {
    var commandCode: Code
    var codes: [Code]
}

