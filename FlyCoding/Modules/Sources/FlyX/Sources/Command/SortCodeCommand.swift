//
//  SortCodeCommand.swift
//  BZCodeX
//
//  Created by caishilin on 2019/10/28.
//  Copyright © 2019 SSBun. All rights reserved.
//

import Foundation

public struct SortCodeCommand: Command {
    public static var keyWord: String = "sort"

    public static var alias: String = "st"

    public static var executor: Executor.Type = SortCodeExecutor.self

    public static var options: [Command.Type] = []

    public static func execute(context: CodeContext, params: [Token]) -> CommandResult {
        return executor.execute(context: context, params: params)
    }

    public struct SortCodeExecutor: Executor {
        public static func execute(context: CodeContext, params: [Token]) -> CommandResult {
            var context = context
            var range: (Int, Int)?

            if params ~= [.number, .dot] {
                range = sortIndex(one: ROW(Int(params[0].value as! Double)), two: context.commandCode.row)
            } else if params ~= [.number, .number] {
                range = sortIndex(one: ROW(Int(params[0].value as! Double)), two: ROW(Int(params[1].value as! Double)))
            } else if params ~= [.number] {
                range = sortIndex(one: context.commandCode.row - Int(params[0].value as! Double), two: context.commandCode.row)
            } else {
                return .error(.noneMatch)
            }

            guard let codeRange = range else { return .error(.noneMatch) }

            var originCodes: [Code] = (codeRange.0...codeRange.1).compactMap {
                context.codes[safe: $0]
            }
            let sortedCodes: [Code] = originCodes.sorted { (l, r) -> Bool in
                return l.scope.end.col < r.scope.end.col
            }
            for (index, code) in originCodes.enumerated() {
                let sortedCodeStr = sortedCodes[index].value
                if sortedCodeStr != code.value {
                    originCodes[index].state = .replace(sortedCodeStr)
                }
            }

            context.codes = originCodes
            return .success(context)
        }
    }
}
