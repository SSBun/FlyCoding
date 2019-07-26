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
//        var customCodes: [String: [String]] = [:]
        var universalCodes: [String: [String]] = [:]
        if let systemCodesPath = Bundle.main.path(forResource: codeType == .swift ? "ui_swift.plist" : "ui_oc.plist", ofType: nil), let temp_system = NSDictionary(contentsOfFile: systemCodesPath) as? [String: [String]] {
            systemCodes.merge(temp_system) {return $1}
        }
//        if let temp_custom = NSDictionary(contentsOfFile: "/Users/Shared/flyCoding/\(codeType == .swift ? "ui_swift.plist" : "ui_oc.plist")") as? [String: [String]] {
//            customCodes.merge(temp_custom) {return $1}
//        }
        if let universalCodesPath = Bundle.main.path(forResource: "ui_universal.plist", ofType: nil), let temp_universal = NSDictionary(contentsOfFile: universalCodesPath) as? [String: [String]] {
            universalCodes.merge(temp_universal) {return $1}
        }

        var allCodes = [String: [String]]()
        allCodes.merge(systemCodes){return $1}
//        allCodes.merge(customCodes) {return $1}
        var codes = allCodes[viewClassName.lowercased(), default: []]
        // Can not matching anything by use system formats or user custom formats, we will use common format to parse it.
        if codes.count == 0 {
            codes = universalCodes[codeType == .swift ? "bz_swift_view" : "bz_oc_view", default: []]
            codes = codes.map {return $0.replacingOccurrences(of: "{class}", with: String(viewClassName))}
        }
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

