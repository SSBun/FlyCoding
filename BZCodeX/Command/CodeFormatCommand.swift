//
//  CodeFormatCommand.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/9/5.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation

public struct CodeFormatCommand: Command {
    public static var keyWord: String = "format"

    public static var alias: String = "fm"

    public static var executor: Executor.Type = CodeFormatExecutor.self

    public static var options: [Command.Type] = []

    public static func execute(context: CodeContext, params: [Token]) -> CommandResult {
        return executor.execute(context: context, params: params)
    }

    public struct CodeFormatExecutor: Executor {
        public static func execute(context: CodeContext, params: [Token]) -> CommandResult {
            var context = context
            var tempArr: [Code] = []
            if params ~= [.number, .dot] {
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
    /*
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign, readonly) BOOL isOpen;
     @property (natomic,weak) Person *me;
     */
    /// 格式化 OC 代码
    private func formattingOCCodes(codes: [Code]) -> [Code] {
        return codes
    }
    /// 格式化 Swift 代码
    private func formattingSwiftCodes(codes: [Code]) -> [Code] {
        return codes
    }
}
