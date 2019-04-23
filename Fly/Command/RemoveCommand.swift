//
//  RemoveCommand.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/15.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation


public struct RemoveCommand: Command {
    static var keyWord: String = "remove"
    
    static var alias: String = "rm"
    
    static var executor: Executor.Type = RemoveExecutor.self
    
    static var options: [Command.Type] = []
    
    static func execute(context: CodeContext, params: [Token]) -> CommandResult {
        return executor.execute(context:context, params:params)
    }
    
    
    public struct RemoveExecutor: Executor {
        static func execute(context: CodeContext, params: [Token]) -> CommandResult {
            var context = context
            var tempArr:[Code] = []
            if params ~= [] {
                if var code = context.codes[safe:context.commandCode.row] {
                    code.state = .remove
                    tempArr.append(code)
                }
            } else if params ~= [.number] {
                if var code = context.codes[safe:ROW(Int(params[0].value as! Double))] {
                    code.state = .remove
                    tempArr.append(code)
                }
            } else if params ~= [.number, .dot] {
                let range = sortIndex(one: ROW(Int(params[0].value as! Double)), two: context.commandCode.row)
                for i in range.0...range.1 {
                    if var code =  context.codes[safe:i] {
                        code.state = .remove
                        tempArr.append(code)
                    }
                }
            } else if params ~= [.number, .number] {
                let range = sortIndex(one: ROW(Int(params[0].value as! Double)), two: ROW(Int(params[1].value as! Double)))
                for i in range.0...range.1 {
                    if var code =  context.codes[safe:i] {
                        code.state = .remove
                        tempArr.append(code)
                    }
                }
            } else {
                return .error(.noneMatch)
            }
            context.codes = tempArr
            return .success(context)
        }
    }
}
