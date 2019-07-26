//
//  LexicalAnalyser.swift
//  grammarAnalyser
//
//  Created by 蔡士林 on 2018/4/8.
//  Copyright © 2018年 蔡士林. All rights reserved.
//

import Foundation

/// 代码的起始点所在的行和列
struct Position {
    static let zero = Position(row: 0, col: 0)
    
    var row: Int
    var col: Int
}

/// 代码范围
struct Scope {
    static let zero = Scope(start: .zero, end: .zero)
    
    var start: Position
    var end: Position
    
    var row: Int {
        get {
            return start.row
        }
        set {
            let offset = end.row - start.row
            start.row = newValue
            end.row = newValue + offset
        }
    }
}

/// 代码中的标签类型
enum TokenType: String {
    case bad              = ""                            // 错误标记
    
    case number           = "\\d"                          // 数字
    case identifier       = "^[_A-Za-z]+[0-9A-Za-z]*$"    // 标识符 字母、数字和下划线组成，开头不能为数字
    case string           = "^\".*\""                     // 字符串
    
    case space            = " "             // 空格
    case dot              = "."             // 点
    case equal            = "="             // 等号
    case add              = "+"             // 加号 +
    case sub              = "-"             // 减号 -
    case mul              = "*"             // 乘号 *
    case div              = "/"             // 除号 /
    case leftBrace        = "{"             // 左大括号 {
    case rightBrace       = "}"             // 右大括号 {
    case leftBracket      = "["             // 左中括号 [
    case rightBracket     = "]"             // 右中括号 ]
    case leftParenthense  = "("             // 左小括号 (
    case rightParenthense = ")"             // 右小括号 )
    case leftArrow        = "<"             // 左尖括号 <
    case rightArrow       = ">"             // 右尖括号 >
    case quotation        = "\""            // 双引号
    case power            = "^"             // 次方
    case letter           = "[a-zA-Z]+"     // 字母
    case underLine        = "_"             // 下划线
    case end              = "\n"// 结束
}


/// 代码中的标签
public struct Token {
    var str: String = ""
    var kind: TokenType = .bad
    var scope: Scope = .zero
    var value: Any?
}

/// 标签识别中的状态
public enum TokenStatus {
    /* 初始化 **/
    
    case initPart
    /* 数字的整数部分**/
    case intPart
    /* 数字的点部分**/
    case dotPart
    /* 数字的小数部分**/
    case fraPart
    
    /* 字符串的左双引号**/
    case leftQuoPart
    /* 字符串的右双引号**/
    case rightQuoPart
    
    /* 识别标识符中**/
    case identifierPart
}

/// 词法解析
public class LexicalAnalyser {
    public private(set) var tokens: [Token] = []
    public let code: String
    public private(set) var string: String = ""
    
    init(code: String) {
        self.code = code
        self.string = code + TokenType.end.rawValue
        parseTokens()
    }
    
    private func parseTokens() {
        
        //MARK: - GLOBAL PROPERTY
        /// 当前解析中的标签状态
        var status = TokenStatus.initPart
        /// 当前正在处理的标签
        var current_token = Token()
        /// 代码字符串中正在处理的字符位置
        var index = 0;
        current_token.scope.start = Position(row: 0, col: index)
        
        //MARK: - ASSISTED METHODS
        /// 生成一个新的标签
        func newToken() {
            current_token.scope.end = Position(row: 0, col: index)
            tokens.append(current_token)
            status = .initPart
            current_token = Token()
            current_token.scope.start = Position(row: 0, col: index)
        }
        
        /// 获取一个数字标签，如果正在处理并检测到标记结束
        func getNumber(_ c: String) {
            if (status == .intPart || status == .fraPart) && !isNumber(c) && !(c ~= .dot) {
                if let value = Double(current_token.str) {
                    current_token.kind = .number;
                    current_token.value = value
                    newToken()
                } else {
                    CATCH_ERROR(.mark_number_error, token: current_token)
                }
            }
        }
        
        /// 获取一个标识符
        func getIdentifier(_ c: String) {
            if status == .identifierPart {
                if !(c <=> [.underLine, .letter, .number]) {
                    current_token.kind = .identifier
                    current_token.value = current_token.str
                    newToken()
                }
            }
        }
        
        /// 解析标识符
        func parseIdentifier(_ c: String) -> Bool {
            if status == .initPart {
                if c <=> [.underLine, .letter] {
                    status = .identifierPart
                    return true
                }
            }
            if status == .identifierPart {
                if c <=> [.underLine, .number, .letter] {
                    return true
                }
            }
            return false
        }
        
        /// 解析数字标签
        func parseNumber(_ c: String) -> Bool {
            if status == .initPart {
                if isNumber(c) {
                    status = .intPart
                    return true
                }
            }
            if status == .intPart {
                if isNumber(c) {
                    return true
                }
                if c ~= .dot {
                    status = .dotPart
                    return true
                }
                fatalError("Parse number is error in .int")
            }
            
            if status == .dotPart {
                if isNumber(c) {
                    status = .fraPart
                    return true
                }
                fatalError("Parse number is error in .dot")
            }
            return false
        }
        
        /// 解析并获取字符串标记
        func parseAndGetString(_ c: String) -> Bool {
            if status == .initPart {
                if c ~= .quotation {
                    status = .leftQuoPart
                    return true
                }
            }
            if status == .leftQuoPart {
                if c ~= .quotation {
                    current_token.kind = .string
                    let str = current_token.str
                    current_token.value = str[str.index(after: str.startIndex)..<str.index(before: str.endIndex)]
                    newToken()
                }
                return true
            }
            return false
        }
        
        //MARK: - PARSE BEGIN
        let startIndex = string.startIndex
        while (index < string.count) {
            let c = String(string[string.index(startIndex, offsetBy: index) ..< string.index(startIndex, offsetBy: index+1)])
            getIdentifier(c)
            getNumber(c)
            
            if c ~= .end {
                current_token.kind = .end
                newToken()
                break
            }
                        
            index += 1
            current_token.str.append(c)
            
            /// 长标记解析区间 开始, 按优先级排列
            if (parseIdentifier(c)) {continue}
            if parseAndGetString(c) {continue}
            if parseNumber(c) {continue}
            /// 长标记解析区间 结束
            
            if let type = c ~= [.space,
                                .add,
                                .sub,
                                .mul,
                                .div,
                                .equal,
                                .leftBrace,
                                .rightBrace,
                                .leftBracket,
                                .rightBracket,
                                .leftParenthense,
                                .rightParenthense,
                                .leftArrow,
                                .rightArrow,
                                .dot,
                                .power]
            {
                current_token.kind = type
                newToken()
            }
        }
    }
    
    /// 是否是数字
    private func isNumber(_ c: String) -> Bool {
        let scan: Scanner = Scanner(string: c)
        var value: Int = 0
        return scan.scanInt(&value) && scan.isAtEnd
    }
    
}

extension String {
    /// 字符串匹配标签类型
    func matchTokenType(_ tokenType: TokenType) -> Bool {
        if self == tokenType.rawValue {
            return true
        }
        return false
    }
}

/// 字符串匹配标签类型
func ~= (left: String, right: TokenType) -> Bool {
    return left.matchTokenType(right)
}

func ~= (left: String, right: [TokenType]) -> TokenType? {
    return right.filter { left ~= $0 }.first
}

precedencegroup RegularExpressionOperatorPrecedence {
    lowerThan: MultiplicationPrecedence
    higherThan: AdditionPrecedence
    associativity: left
    assignment: false
}

infix operator <=>: RegularExpressionOperatorPrecedence

func <=> (left: String, right: TokenType) -> Bool {
    return regularMatchLike(text: left, expression: right.rawValue)
}

func <=> (left: String, right: [TokenType]) -> Bool {
    return right.filter { regularMatchLike(text: left, expression: $0.rawValue) }.count > 0
}


