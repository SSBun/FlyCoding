//
//  MoveCommand.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/19.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation



public struct MoveCommand: Command {
    static var keyWord: String = "move"
    
    static var alias: String = "mv"
    
    static var executor: Executor.Type = RemoveCommand.RemoveExecutor.self
    
    static var options: [Command.Type] = []
    
    static func execute(context: CodeContext, params: [Token]) -> CommandResult {
        return executor.execute(context:context, params:params)
    }
}
