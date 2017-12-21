//
//  SourceEditorCommand.swift
//  Fly Coding
//
//  Created by SSBun on 19/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Foundation
import XcodeKit

enum CodeType {
    case swift
    case oc
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let codeType = analyzeCodeType(codeLines: invocation.buffer.lines)
        if let lines = invocation.buffer.selections as? [XCSourceTextRange], let codeRange = lines.first, let codes = invocation.buffer.lines as? [String] {
            // The begain line count
            var lineCount = codeRange.start.line
            // The command code
            var code = codes[lineCount]
            if code.isEmpty {return}
            // Nonblank col
            let colCount = regularMatchRange(text: code, expression: "[\\S]+?").first?.location ?? 0
            // Clear whitespace
            code = code.trimmingCharacters(in: .whitespacesAndNewlines)
            // Command model
            if code.hasPrefix("#") || (code.hasPrefix("@") && codeType == .oc) {
                code = String(code[code.index(after: code.startIndex)...])
                code = regularReplace(text: code, expression: "[\\s]+", with: "")
                var snipLabels = (NSString(string: code).components(separatedBy: ")+") as [String]).map {$0+")"}
                if let lastCode = snipLabels.last {
                    snipLabels[snipLabels.count-1] = String(lastCode[..<lastCode.index(before: lastCode.endIndex)])
                }
                let snips = snipLabels.flatMap {BaseSnip.init(label: String($0), spaceCount: colCount, codeType: codeType)}
                invocation.buffer.lines.removeObject(at: lineCount)
                for snip in snips {
                    invocation.buffer.lines.insert(snip.code, at: lineCount)
                    lineCount += snip.lineCount
                }
            } else {
                // Property model
                let properties = decoderPropertyCode(code: code, codeType: codeType)
                invocation.buffer.lines.removeObject(at: lineCount)
                for property in properties {
                    var propertyCode: String = ""
                    if codeType == .swift {
                        propertyCode = generatePropertyCode(property: property, spaceCount: colCount)
                    }
                    if codeType == .oc {
                        propertyCode = generateOCPropertyCode(property: property, spaceCount: colCount)
                    }
                    invocation.buffer.lines.insert(propertyCode, at: lineCount)
                    lineCount += property.lineCount
                }
            }
        }
        completionHandler(nil)
        return;
    }
}

func analyzeCodeType(codeLines lines: NSMutableArray) -> CodeType {
    guard let codeLines = lines as? [String] else {return .swift}
    var maxLineCount = 0
    if codeLines.count <= 50 {
        maxLineCount = codeLines.count
    } else {
        maxLineCount = 50
    }
    let prefix50Lines = codeLines[0..<maxLineCount]
    for line in prefix50Lines {
        if line.contains(".swift") {
            return .swift
        }
        if line.contains(".h") || line.contains(".m") {
            return .oc
        }
    }
    return .swift
}


