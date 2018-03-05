//
//  GenerateViewSnip.swift
//  Fly
//
//  Created by SSBun on 2017/11/9.
//  Copyright © 2017年 SSBun. All rights reserved.
//

import Foundation


class GenerateViewSnip: Snip {
    var label: String
    var code: String
    var lineCount: Int
    var codeType: CodeType
    
    required init?(label: String, spaceCount: Int, codeType: CodeType) {
        guard let paramStr = regularMatch(text: label, expression: "(?<=\\()[_a-zA-Z,]+(?=\\))").first else {return nil}
        let params = paramStr.split(separator: ",")
        guard let viewClassName = params.first, viewClassName.count > 0 else {return nil}
        var selfValue = "<#name#>"
        if params.count > 1 {
            let valueName = params[1]
            if valueName.count > 0 {
                selfValue = String(valueName)
            }
        }
        let repeatCount = Int(regularMatch(text: label, expression: "(?<=\\*)[0-9]+").first ?? "1") ?? 1
        
        var systemCodes: [String: [String]] = [:]
        if let systemCodesPath = Bundle.main.path(forResource: "ui_swift.plist", ofType: nil), let temp_system = NSDictionary(contentsOfFile: systemCodesPath) as? [String: [String]] {
            systemCodes.merge(temp_system) {return $1}
        }
        var customCodes: [String: [String]] = [:]
        if let temp_custom = NSDictionary(contentsOfFile: "/Users/Shared/flyCoding/ui_swift.plist") as? [String: [String]] {
            customCodes.merge(temp_custom) {return $1}
        }
        var allCodes = [String: [String]]()
        allCodes.merge(systemCodes){return $1}
        allCodes.merge(customCodes) {return $1}
        var codes = allCodes[viewClassName.lowercased(), default: []]
        codes = codes.map {return $0.replacingOccurrences(of: "{query}", with: selfValue)}
        
        if codes.count > 0 {
            self.label = label
            var code = ""
            for _ in 0..<repeatCount {
                code += codes.reduce("") {
                    $0 + " " * spaceCount + $1 + "\n"
                }
                code += "\n"
            }
            self.code = code
            self.lineCount = repeatCount * (codes.count + 1)
            self.codeType = codeType
        } else {
            return nil
        }
    }
}

