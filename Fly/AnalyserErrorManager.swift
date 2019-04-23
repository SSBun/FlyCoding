//
//  ErrorHanding.swift
//  grammarAnalyser
//
//  Created by 蔡士林 on 2018/4/13.
//  Copyright © 2018年 蔡士林. All rights reserved.
//

import Foundation

enum AnalyserError {
    case mark_number_error
    case mark_grammar_error
}

typealias AnalyserErrorHandle = (AnalyserError) -> ()

func CATCH_ERROR(_ error: AnalyserError, token: Any) {
    AnalyserErrorManager.shared.catchAnalyserError(error: error, token: token)
}

class AnalyserErrorManager {
    
    static let shared = AnalyserErrorManager()
    public private(set) var logs: [AnalyserError] = []
    
    private var errorHandle: AnalyserErrorHandle?
    
    /// 监听语法解析器错误
    func observeAnalyserError(errorHandle: @escaping AnalyserErrorHandle) {
        self.errorHandle = errorHandle
    }
    
    /// 语法解析器捕捉错误回调
    func catchAnalyserError(error: AnalyserError, token: Any, file: String = #file, function: String = #function, line: Int = #line) {
        print("*****   Catch an analyser error:\(error)  ***** \n==> \(String(file.split(separator: "/").last ?? ""))[\(function):\(line)]\n==> errorMessage: \(token)")
        errorHandle?(error)
        fatalError()
    }
}
