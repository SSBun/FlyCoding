//
//  SourceEditorCommand.swift
//  Fly Coding
//
//  Created by SSBun on 19/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Foundation
import XcodeKit
import BZCodeX

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    // swiftlint:disable cyclomatic_complexity
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) {
        defer { completionHandler(nil) }
        // Swift or Objective-C ?
        let codeType = InputHandle.analyzeCodeType(codeLines: invocation.buffer.lines)
        guard let lines = invocation.buffer.selections as? [XCSourceTextRange],
              let codeRange = lines.first,
              let codes = invocation.buffer.lines as? [String]
        else { return }
        // The starting line
        var lineCount = codeRange.start.line
        // The command code
        var code = codes[lineCount]
        if code.isEmpty {return}
        // @do command system
        if let codeContext = Preprocessor.preprocess(codes: invocation.buffer.lines, commandRow: lineCount) {
            Processor.process(codeContext: codeContext, codes: invocation.buffer.lines)
        } else {
            // Code indentation
            let colCount = InputHandle.indentationLength(code: code)
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
                let snips = snipLabels.compactMap {BaseSnip.init(label: String($0), spaceCount: colCount, codeType: codeType)}
                invocation.buffer.lines.removeObject(at: lineCount)
                for snip in snips {
                    invocation.buffer.lines.insert(snip.code, at: lineCount)
                    lineCount += snip.lineCount
                }
                invocation.buffer.selections.removeAllObjects()
                invocation.buffer.selections.add(XCSourceTextRange(start: .init(line: lineCount-2, column: colCount+1),
                                                                  end: .init(line: lineCount-2, column: colCount+1)))
            } else {
                // Property mode
                let properties = decoderPropertyCode(code: code, codeType: codeType)
                invocation.buffer.lines.removeObject(at: lineCount)
                // 默认让鼠标光标选中第一个变量;
                var autoSelectFirstPlaceholder: XCSourceTextRange?
                // 当生成的代码没有变量时，则将光标移动到最后一个字符后面，方便换行以及后续的操作
                var autoMoveCursorBehindLastChar: XCSourceTextRange?
                for property in properties {
                    var propertyCode: String = ""
                    if codeType == .swift {
                        propertyCode = generatePropertyCode(property: property, spaceCount: colCount)
                    }
                    if codeType == .oc {
                        propertyCode = generateOCPropertyCode(property: property, spaceCount: colCount)
                    }
                    if autoSelectFirstPlaceholder == nil, let range = regularMatchRange(text: propertyCode, expression: "<#(.*)?#>").first {
                        autoSelectFirstPlaceholder = XCSourceTextRange(start: XCSourceTextPosition(line: lineCount,
                                                                                                   column: range.location),
                                                                       end: XCSourceTextPosition(line: lineCount,
                                                                                                 column: range.location + range.length))
                    }
                    invocation.buffer.lines.insert(propertyCode, at: lineCount)
                    autoMoveCursorBehindLastChar = XCSourceTextRange(start: XCSourceTextPosition(line: lineCount,
                                                                                                 column: propertyCode.count),
                                                                     end: XCSourceTextPosition(line: lineCount,
                                                                                               column: propertyCode.count))
                    lineCount += property.lineCount
                }
                if let selectedRange = autoSelectFirstPlaceholder {
                    invocation.buffer.selections.removeAllObjects()
                    invocation.buffer.selections.add(selectedRange)
                } else if let selectedRange = autoMoveCursorBehindLastChar {
                    invocation.buffer.selections.removeAllObjects()
                    invocation.buffer.selections.add(selectedRange)
                }
            }
        }
    }
}
