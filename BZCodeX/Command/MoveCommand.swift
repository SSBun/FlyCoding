//
//  MoveCommand.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/19.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation

public struct MoveCommand: Command {
    public static var keyWord: String = "move"

    public static var alias: String = "mv"

    public static var executor: Executor.Type = RemoveCommand.RemoveExecutor.self

    public static var options: [Command.Type] = []

    public static func execute(context: CodeContext, params: [Token]) -> CommandResult {
        return executor.execute(context: context, params: params)
    }
}
