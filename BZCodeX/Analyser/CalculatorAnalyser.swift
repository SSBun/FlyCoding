//
//  CalculatorGrammarAnalyser.swift
//  grammarAnalyser
//
//  Created by 蔡士林 on 2018/4/14.
//  Copyright © 2018年 蔡士林. All rights reserved.
//

import Foundation

class CalculatorAnalyser: GrammarAnalyser {
    
    let tokens: [Token]
    
    required init(tokens: [Token]) {
        self.tokens = tokens.filter { $0.kind != .space}
    }
    
    func parseTokens() -> Any {
        /// 存储前置 token
        var st_ahead_token: Token? = nil
        /// 当前正在处理的 token
        var current_pos = 0
        
        /// 回撤 token 到前置 token
        func unget_token(_ token: Token) {
            st_ahead_token = token
        }
        
        /// 获取一个新的 token
        func get_token() -> Token {
            if st_ahead_token != nil {
                defer {st_ahead_token = nil}
                return st_ahead_token!
            } else {
                defer {current_pos += 1}
                return tokens[current_pos]
            }
        }
        
        /// 三级解析
        func parse_primary_expression() -> Double {
            var token = get_token()
            var v1: Double = 0
            var v2: Double = 0
            if token.kind == .number {
                v1 = token.value as! Double
                while true {
                    let token2 = get_token()
                    if token2.kind != .power {
                        unget_token(token2)
                        break
                    }
                    v2 = parse_expression()
                    return pow(v1, v2)
                }
            } else if token.kind == .leftParenthense {
                v1 = parse_expression()
                token = get_token()
                if token.kind != .rightParenthense {
                    CATCH_ERROR(.mark_grammar_error, token: token)
                }
            } else if token.kind == .sub {
                v1 = parse_expression()
                v1 = -v1
            } else {
                unget_token(token)
            }
            return v1;
        }
        
        /// 二级解析
        func parse_term() -> Double {
            var v1: Double = 0
            var v2: Double = 0
            v1 = parse_primary_expression()
            while true {
                let token = get_token()
                if token.kind != .mul && token.kind != .div {
                    unget_token(token)
                    break
                }
                v2 = parse_primary_expression()
                if token.kind == .mul {
                    v1 *= v2
                } else if token.kind == .div {
                    v1 /= v2
                }
            }
            return v1
        }
        
        /// 一级解析
        func parse_expression() -> Double {
            var v1: Double = 0
            var v2: Double = 0
            v1 = parse_term()
            while true {
                let token = get_token()
                if token.kind != .add && token.kind != .sub {
                    unget_token(token)
                    break
                }
                v2 = parse_term()
                if token.kind == .add {
                    v1 += v2
                } else if token.kind == .sub {
                    v1 -= v2
                }
            }
            return v1
        }
        
        return parse_expression();
    }
    
}
