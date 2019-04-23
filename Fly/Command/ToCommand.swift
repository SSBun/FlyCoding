//
//  ToCommand.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/19.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation

public struct ToCommand: Command {
    static var keyWord: String = "to"
    
    static var alias: String = "to"
    
    static var executor: Executor.Type = ToExector.self
    
    static var options: [Command.Type] = []
    
    static func execute(context: CodeContext, params: [Token]) -> CommandResult {
        return ToExector.execute(context:context, params:params)
    }
    
    public struct ToExector: Executor {
        static func execute(context: CodeContext, params: [Token]) -> CommandResult {
            var context = context
            if params ~= [.dot] {
                let insertRow = context.commandCode.row
                
                var insertCodes: [Code] = []
                for i in 0..<context.codes.count {
                    var scope = context.codes[i].scope
                    let codeValue = context.codes[i].value
                    scope.row = insertRow
                    let newCode = Code(state: .insert, scope: scope, value: codeValue, executeOffset: 0)
                    insertCodes.append(newCode)
                }
                context.codes.append(contentsOf: insertCodes)
            } else if params ~= [.number] {
                let insertRow = ROW(Int(params[0].value as! Double))
                var insertCodes: [Code] = []
                for i in 0..<context.codes.count {
                    var scope = context.codes[i].scope
                    let codeValue = context.codes[i].value
                    scope.row = insertRow
                    let newCode = Code(state: .insert, scope: scope, value: codeValue, executeOffset: 0)
                    insertCodes.append(newCode)
                }
                context.codes.append(contentsOf: insertCodes)
            } else {
                return .error(.noneMatch)
            }
            return .success(context)
        }
    }
}
