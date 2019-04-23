//
//  FCPreprocessor.swift
//  grammarAnalyser
//
//  Created by caishilin on 2018/6/13.
//  Copyright © 2018 蔡士林. All rights reserved.
//

import Foundation

class FCPreprocessor {
    
}

// copy
//@fc cp 100 to 32
//@fc cp 12 . to 30

// remove
//@fc rm 12
//@fc rm 12 .
//@fc rm
//@fc rm t
//@fc rm b

// format
//@fc fm 12
//@fc fm 12 .

// calculator
//@fc js 12+30*30

// lenght  code length
// ///  summary
//

//@fc move 12 . to 23
//@fc mv t
//@fc mv b

struct Preprocessor {
    static let commandFlag = "@fc"
    static var allCommands: [Command.Type] = [RemoveCommand.self,
                                              MoveCommand.self,
                                              CopyCommand.self,
                                              ToCommand.self]

    static func preprocess(codes: inout [String], commandRow: Int) -> CodeContext? {
        let codeValue = codes[commandRow]
        guard let range = regularMatchRange(text: codeValue, expression: "\(commandFlag)").last else {return nil}
        var commandStr = ""
        if range.location >= 1 {
            codes[commandRow] = String(codeValue[...codeValue.index(codeValue.startIndex, offsetBy: range.location-1)])
            commandStr = String(codeValue[codeValue.index(codeValue.startIndex, offsetBy: range.location)...])
        } else {
            codes[commandRow] = ""
            commandStr = codeValue
        }
        let commandCode = Code(state: .normal, scope: Scope(start: Position(row: commandRow, col: range.location), end: Position(row: commandRow, col: range.location + commandStr.count)), value: commandStr)
        var formatCodes:[Code] = []
        var index = 0
        for code in codes {
            let formatCode = Code(state: .normal, scope: Scope(start: Position(row: index, col: 0), end: Position(row: index, col: code.count)), value: code)
            formatCodes.append(formatCode)
            index+=1
        }
        var codeContext = CodeContext(commandCode: commandCode, codes: formatCodes)
        
        // Parse command
        let tokens = LexicalAnalyser(code: commandCode.value).tokens
        guard case .success(let commands) = parseCommand(tokens: tokens) else {return nil}
        for command in commands {
            if case .success(let context) = command.0.execute(context: codeContext, params: command.1) {
                codeContext = context
            } else {
                return nil
            }
        }
        return codeContext
    }
    
    static func parseCommand(tokens: [Token]) -> ParseResult {
        var tokens = tokens
        if tokens.count < 2 {return .error("empty command")}
        guard let token = tokens.first, token.kind == .identifier, token.str == commandFlag else {
            return .error("error command")
        }
        tokens.remove(at: 0)
        tokens = tokens.filter {$0.kind != .space && $0.kind != .end}
        var tasks: [(Command.Type, [Token])] = []
        
        var command: Command.Type? = nil
        var params: [Token] = []
        
        for t in tokens {
            if let result = checkCommand(t) {
                if let aCommand = command {
                    tasks.append((aCommand, params))
                    command = result
                    params.removeAll()
                } else {
                    command = result
                }
            } else {
                params.append(t)
            }
        }
        if let aCommand = command {
            tasks.append((aCommand, params))
        }
        return .success(tasks)
    }
    
    static func checkCommand(_ token: Token) -> Command.Type? {
        guard token.kind == .identifier, let code = token.value as? String else {return nil}
        for command in allCommands {
            if [command.alias, command.keyWord].contains(code) {
                return command
            }
        }
        return nil
    }
    
}

