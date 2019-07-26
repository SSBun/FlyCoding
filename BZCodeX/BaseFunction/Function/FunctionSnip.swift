//
//  FuncationSnip.swift
//  Fly
//
//  Created by SSBun on 2017/11/9.
//  Copyright © 2017年 SSBun. All rights reserved.
//

import Foundation

/*!
 Generate function code
 
 eg: #func(@p.getAge:>)
 
 */
class FunctionSnip: Snip {
    var label: String
    var code: String
    var lineCount: Int
    var codeType: CodeType
   
    
    required init?(label: String, spaceCount: Int, codeType: CodeType) {
        guard let paramStr = regularMatch(text: label, expression: "(?<=\\().+(?=\\))").first else {return nil}
        self.label = label
        self.codeType = codeType
        self.code = ""
        self.lineCount = 0
        if codeType == .swift {
            guard let (code, lineCount) = generateSwiftFunction(paramStr: paramStr, spaceCount: spaceCount) else {return nil}
            self.code = code
            self.lineCount = lineCount
        } else if codeType == .oc {
            guard let (code, lineCount) = generateOCFunction(paramStr: paramStr, spaceCount: spaceCount) else {return nil}
            self.code = code
            self.lineCount = lineCount
        } else {
            return nil
        }
    }
    
    private func generateSwiftFunction(paramStr: String, spaceCount: Int) -> (String, Int)? {
        let params = paramStr.split(separator: ".")
        var prefix: String? = nil // Function prefix mark
        var functionName: String = ""
        if params.count >= 2 {
            prefix = String(params[0])
            functionName = String(params[1])
        } else {
            functionName = String(params[0])
        }
        if functionName.count <= 0 {return nil}
        
        if let prefixMark = prefix {
            prefix = Property.scopeWithShortcuts(prefixMark, isFunction: true) // Generate function prefix
        }
        var paramCount = 0
        var returnCount = 0
        
        func filterParamMark() {
            if let paramMarkRange = functionName.range(of: ":") {
                paramCount += 1
                functionName.removeSubrange(paramMarkRange)
                filterParamMark()
            }
        }
        filterParamMark()
        
        
        func filterReturnMark() {
            if let returnMarkRange = functionName.range(of: ">") {
                returnCount += 1
                functionName.removeSubrange(returnMarkRange)
                filterReturnMark()
            }
        }
        filterReturnMark()
        
        let repeatCount = Int(regularMatch(text: label, expression: "(?<=\\*)[0-9]+").first ?? "1") ?? 1
        var codes = [String]()
        var firstLine = ""
        if let prefix = prefix {
            firstLine += prefix
            firstLine += " func \(functionName)("
        } else {
            firstLine += "func \(functionName)("
        }
        
        if paramCount > 0 {
            for i in 0..<paramCount {
                if i == 0 {
                    firstLine += "<#name#>: <#type#>"
                } else {
                    firstLine += ", <#name#>: <#type#>"
                }
            }
            firstLine += ")"
        } else {
            firstLine += ")"
        }
        
        if returnCount > 0 {
            if returnCount == 1 {
                firstLine += " -> <#return#>"
            } else {
                firstLine += " -> ("
                for i in 0 ..< returnCount {
                    if i == 0 {
                        firstLine += "<#return#>"
                    } else {
                        firstLine += ", <#return#>"
                    }
                }
                firstLine += ")"
            }
        }
        
        firstLine += " {"
        codes.append(firstLine)
        codes.append(" " * 4 + "<#code#>")
        codes.append("}")
        
        if codes.count > 0 {
            var code = ""
            for _ in 0..<repeatCount {
                code += codes.reduce("") {
                    $0 + " " * spaceCount + $1 + "\n"
                }
                code += "\n"
            }
            return (code, repeatCount * (codes.count + 1))
        } else {
            return nil
        }
    }

    private func generateOCFunction(paramStr: String, spaceCount: Int) -> (String, Int)? {
        let params = paramStr.split(separator: ".")
        var prefix: String? = nil // Function prefix mark
        var functionName: String = ""
        if params.count >= 2 {
            prefix = String(params[0])
            functionName = String(params[1])
        } else {
            functionName = String(params[0])
        }
        if functionName.count <= 0 {return nil}
        if prefix == "+" {
            prefix = "+"
        } else {
            prefix = "-"
        }
        var paramCount = 0
        var returnCount = 0
        
        func filterParamMark() {
            if let paramMarkRange = functionName.range(of: ":") {
                paramCount += 1
                functionName.removeSubrange(paramMarkRange)
                filterParamMark()
            }
        }
        filterParamMark()
        
        
        func filterReturnMark() {
            if let returnMarkRange = functionName.range(of: ">") {
                returnCount += 1
                functionName.removeSubrange(returnMarkRange)
                filterReturnMark()
            }
        }
        filterReturnMark()
        
        let repeatCount = Int(regularMatch(text: label, expression: "(?<=\\*)[0-9]+").first ?? "1") ?? 1
        var codes = [String]()
        var firstLine = ""
        if let prefix = prefix {
            firstLine += prefix
        }
        
        if returnCount > 0 {
            firstLine += " (<#type#>)\(functionName)"
        } else {
            firstLine += " (void)\(functionName)"
        }

        if paramCount > 0 {
            for i in 0..<paramCount {
                if i == 0 {
                    firstLine += ":(<#type#>)<#param\(i)#>"
                } else {
                    firstLine += " <#name\(i)#>:(<#type#>)<#param\(i)#>"
                }
            }
        }
        
        firstLine += " {"
        codes.append(firstLine)
        codes.append(" " * 4 + "<#code#>")
        codes.append("}")
        
        if codes.count > 0 {
            var code = ""
            for _ in 0..<repeatCount {
                code += codes.reduce("") {
                    $0 + " " * spaceCount + $1 + "\n"
                }
                code += "\n"
            }
            return (code, repeatCount * (codes.count + 1))
        } else {
            return nil
        }
    }
}
