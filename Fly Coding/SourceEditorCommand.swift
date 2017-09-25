//
//  SourceEditorCommand.swift
//  Fly Coding
//
//  Created by SSBun on 19/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Foundation
import XcodeKit



class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        if let lines = invocation.buffer.selections as? [XCSourceTextRange], let codeRange = lines.first, let codes = invocation.buffer.lines as? [String] {
            var lineCount = codeRange.start.line
            var code = codes[lineCount]
            let colCount = regularMatchRange(text: code, expression: "[\\S]+?").first?.location ?? 0
            code = code.trimmingCharacters(in: .whitespacesAndNewlines)
            if code.hasPrefix("#") {
                code = code.substring(from: code.index(after: code.startIndex))
                code = regularReplace(text: code, expression: "[\\s]+", with: "")
                let snipLabels = (NSString(string: code).components(separatedBy: ")+") as [String]).map {$0+")"}
                let snips = snipLabels.flatMap {BaseSnip.init(label: String($0), spaceCount: colCount)}
                 invocation.buffer.lines.removeObject(at: lineCount)
                for snip in snips {
                    invocation.buffer.lines.insert(snip.code, at: lineCount)
                    lineCount += snip.lineCount
                }
            } else {
                let properties = decoderPropertyCode(code: code)
                invocation.buffer.lines.removeObject(at: lineCount)
                for property in properties {
                    let propertyCode = generatePropertyCode(property: property, spaceCount: colCount)
                    invocation.buffer.lines.insert(propertyCode, at: lineCount)
                    lineCount += property.lineCount
                }
            }
        }
        completionHandler(nil)        
    }
    
}

func decoderPropertyCode(code: String) -> [Property] {
    let modules = code.components(separatedBy: "+")
    var properties = [Property]()
    var currentScope = "let"

    for module in modules {
        guard let className = regularMatch(text: module, expression: "(?<=\\.)[<>&,\\(\\)\\?!a-zA-Z0-9_\\:\\[\\]\\ ]+").first else {continue}
        if let scopStr = regularMatch(text: module, expression: "^[a-zA-Z@]+(?=\\.)").first, let scop = Property.scopeWithShortcuts(scopStr){
            currentScope = scop
        }
        let defaultValue = regularMatch(text: module, expression: "(?<=\\{).*(?=\\})").first
        var count = 1
        if let countStr = regularMatch(text: module, expression: "(?<=\\*)[0-9]+").first, let countN = Int(countStr), countN > 1{
            count = countN
        }
        for _ in 0..<count {
            let property = Property(className: className, scope: currentScope, defaultValue: defaultValue)
            properties.append(property)
        }
    }
    return properties
}

func generatePropertyCode(property: Property, spaceCount: Int) -> String {
    var code = ""
    if let defaultValue = property.defaultValue {
        if property.className.hasSuffix("?") || property.className.hasSuffix("!") {
            if defaultValue.characters.count == 0 {
                code += " " * spaceCount + property.scope + " " + "<#name#>" + ": " + property.className + " = " + property.className.substring(to: property.className.index(before: property.className.endIndex)) + "()"
            } else {
                code += " " * spaceCount + property.scope + " " + "<#name#>" + ": " + property.className + " = " + defaultValue
            }
        } else {
            if defaultValue.characters.count == 0 {
                code += " " * spaceCount + property.scope + " " + "<#name#>" + " = " + property.className + "()"
            } else {
                code += " " * spaceCount + property.scope + " " + "<#name#>" + " = " + defaultValue
            }
        }
    } else {
        if property.scope.contains("lazy") {
            code += " " * spaceCount + property.scope + " " + "<#name#>" + ": " + property.className + " = {\n" + " " * (spaceCount + 4) + "<#code#>" + "\n" + " " * spaceCount + "}()"
        } else {
            code += " " * spaceCount + property.scope + " " + "<#name#>" + ": " + property.className
        }
    }
    return code
}











































