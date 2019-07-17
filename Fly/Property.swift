//
//  Property.swift
//  Fly
//
//  Created by SSBun on 2017/12/20.
//  Copyright © 2017年 SSBun. All rights reserved.
//

import Foundation


// MARK: - Property

struct Property {
    static let allScopeMark = ["l": "let",
                               "v": "var",
                               "p": "private",
                               "P": "public",
                               "o": "open",
                               "f": "fileprivate",
                               "pl": "private let",
                               "pv": "private var",
                               "Pl": "public let",
                               "Pv": "public var",
                               "ol": "open let",
                               "ov": "open var",
                               "fl": "fileprivate let",
                               "fv": "fileprivate var",
                               "lv": "lazy var"]
    
    static let allOCScopeMark = ["s": "strong",
                                 "w": "weak",
                                 "a": "assign",
                                 "r": "readonly",
                                 "g": "getter=<#getterName#>",
                                 "c": "copy",
                                 "n": "nullable",
                                 "N": "nonnull",
                                 "C": "class"]
    
    static let allSystemMark = ["@": "@objc",
                                "u": "unowned",
                                "w": "weak",
                                "c": "class",
                                "s": "static",
                                "b": "_B__B_"]
    
    var className: String
    let scope: String
    let defaultValue: String?
    var lineCount: Int = 1
    var instanceName: String = "<#name#>"
    let codeType: CodeType
    
    init(className: String, scope: String, defaultValue: String?, codeType: CodeType = .swift) {
        self.className = className
        self.defaultValue = defaultValue
        self.codeType = codeType
        self.scope = scope
        if className.count == 0 {
            self.className = handleOCClassNameWithEmpty(scope: scope)
        }
        if codeType == .swift, scope.contains("lazy") {
            self.lineCount = 3
        }
    }
    
    private func handleOCClassNameWithEmpty(scope: String) -> String {
        if scope.contains(Property.allOCScopeMark["s"]!) || scope.contains(Property.allOCScopeMark["c"]!) {
            return "<#type#> *"
        }
        if scope.contains(Property.allOCScopeMark["w"]!) || scope.contains(Property.allOCScopeMark["a"]!) {
            return "<#type#>"
        }
        return "<#type#> *"
    }
    
    static func scopeWithShortcuts(_ p: String, isFunction: Bool = false) -> String? {
        if p.count == 0 {return nil}
        var systemMarks = [String]()
        var scopeMark = ""
        for c in p {
            if let mark = allSystemMark[String(c)] {
                systemMarks.append(mark)
            } else {
                scopeMark += String(c)
            }
        }
        if let scopeMarkStr = allScopeMark[scopeMark] {
            systemMarks.append(scopeMarkStr)
        } else {
            if !isFunction {
                systemMarks.append("let")
            }
        }
        return systemMarks.joined(separator:" ")
    }
    
    static func scopeWithOCShortcuts(_ p: String) -> String? {
        if p.count == 0 {return nil}
        var scopeMark = "@property (nonatomic, "
        var systemMarks = [String]()
        for c in p {
            if let mark = allOCScopeMark[String(c)] {
                systemMarks.append(mark)
            }
        }
        if systemMarks.count <= 0 {
            systemMarks.append("strong")
        }
        scopeMark += systemMarks.joined(separator: ", ")
        scopeMark += ")"
        return scopeMark
    }
}


/*!
 Analyse command string and generate an array of `Property` objects.
 
 @discussion Adding * and numbers after the command can generate multiple copies at the same time. (eg: pl.String * 3)
 Adding + after the command can generate different classes of properteis and the same time. (eg: pl.String * 2 + P.Int * 4)
 @param code The command string.
 @return The result of the Analysis.
 */
func decoderPropertyCode(code: String, codeType: CodeType) -> [Property] {
    let modules = code.components(separatedBy: "+")
    var properties = [Property]()
    var currentScope = "let"
    if codeType == .oc {
        currentScope = "@property (nonatomic, strong)"
    }
    
    for var module in modules {
        guard let className = regularMatch(text: module, expression: codeType == .swift ? "(?<=\\.)[<>&,\\(\\)\\?!a-zA-Z0-9_\\:\\[\\]\\ ]+" : "(?<=\\.)([\\*<>&,\\(\\)\\?!a-zA-Z0-9_\\:\\[\\]\\ ;](?!\\*\\ *\\d+))*").first else {continue}
        module = module.trimmingCharacters(in: .whitespacesAndNewlines)
        if codeType == .swift, let scopStr = regularMatch(text: module, expression: "^[a-zA-Z@]+(?=\\.)").first, let scop = Property.scopeWithShortcuts(scopStr) {
            currentScope = scop
        }
        if codeType == .oc, let scopStr = regularMatch(text: module, expression: "^[a-zA-Z]+(?=\\.)").first, let scop = Property.scopeWithOCShortcuts(scopStr) {
            currentScope = scop
        }
        let defaultValue = regularMatch(text: module, expression: "(?<=\\{).*(?=\\})").first
        var count = 1
        if let countStr = regularMatch(text: module, expression: "(?<=\\*)[0-9]+").first, let countN = Int(countStr), countN > 1{
            count = countN
        }
        for _ in 0..<count {
            let property = Property(className: className, scope: currentScope, defaultValue: defaultValue, codeType: codeType)
            properties.append(property)
        }
    }
    return properties
}


/*!
 Generate property code
 
 @disscussion Being not an optional property but has a default value, the class name wil be ignored.
 If the default value is empty string(eg: ""), we will modify the default value to that append a
 string `()` after the class name.
 @param proerpty: The property willing be parsed.
 @param spaceCount: The number of code identation
 @return Property code
 */
func generatePropertyCode(property: Property, spaceCount: Int) -> String {
    var code = ""
    if let defaultValue = property.defaultValue {
        if property.className.hasSuffix("?") || property.className.hasSuffix("!") {
            if defaultValue.count == 0 {
                code += " " * spaceCount + property.scope + " " + "<#name#>" + ": " + property.className + " = " + String(property.className[..<property.className.index(before: property.className.endIndex)]) + "()"
            } else {
                code += " " * spaceCount + property.scope + " " + "<#name#>" + ": " + property.className + " = " + defaultValue
            }
        } else {
            if defaultValue.count == 0 {
                code += " " * spaceCount + property.scope + " " + "<#name#>" + " = " + property.className + "()"
            } else {
                code += " " * spaceCount + property.scope + " " + "<#name#>" + " = " + defaultValue
            }
        }
    } else {
        if property.scope.contains("lazy") {
            code += " " * spaceCount + property.scope + " " + "<#name#>" + ": " + property.className + " = {\n" + " " * (spaceCount + 4) + "<#code#>" + "\n" + " " * spaceCount + "}()"
        } else if let range = regularMatchRange(text: property.scope, expression: "_B__B_[\\ ]?").first {
            let scope = String(property.scope[..<property.scope.index(property.scope.startIndex, offsetBy: range.location)] + property.scope[property.scope.index(property.scope.startIndex, offsetBy: range.location+range.length)...])
            code += " " * spaceCount + scope + " " + "<#name#>" + ": " + property.className + " = {\n" + " " * (spaceCount + 4) + "<#code#>" + "\n" + " " * spaceCount + "}()"
        } else {
            code += " " * spaceCount + property.scope + " " + "<#name#>" + ": " + property.className
        }
    }
    return code
}

func generateOCPropertyCode(property: Property, spaceCount: Int) -> String {
    var code = property.scope
    code += " "
    code += property.className
    code = code.trimmingCharacters(in: .whitespacesAndNewlines)
    if property.className.hasSuffix(";") {
        return code
    }
    if !property.className.hasSuffix("*") {
        code += " "
    }
    code += "<#name#>"
    return code
}

