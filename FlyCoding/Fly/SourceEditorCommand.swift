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
    
    func perform(
        with invocation: XCSourceEditorCommandInvocation,
        completionHandler: @escaping (Error?) -> Void
    ) {
        defer { completionHandler(nil) }
        
        // Swift or Objective-C?
        let codeType = InputHandle.analyzeCodeType(codeLines: invocation.buffer.lines)
        
        guard let lines = invocation.buffer.selections as? [XCSourceTextRange],
              let codeRange = lines.first,
              let codes = invocation.buffer.lines as? [String]
        else { return }
        
        // The number of the first line of your selected codes.
        var lineNumber = codeRange.start.line
        
        // The command code
        var code = codes[lineNumber]
        if code.isEmpty {return}
        
        // MARK: - @do command analyzer
        
        // Try to recognize @do commands.
        if let codeContext = Preprocessor.preprocess(
            codes: invocation.buffer.lines,
            commandRow: lineNumber)
        {
            Processor.process(codeContext: codeContext, codes: invocation.buffer.lines)
            return
        }
        
        // Code indentation.
        let colCount = InputHandle.indentationLength(code: code)
        // Clear whitespace.
        code = code.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // MARK: - Command mode
        
        // Command model.
        if code.hasPrefix("#") || (code.hasPrefix("@") && codeType == .oc) {
            code = String(code[code.index(after: code.startIndex)...])
            code = regularReplace(text: code, expression: "[\\s]+", with: "")
            var snipLabels = (NSString(string: code).components(separatedBy: ")+") as [String]).map { $0+")" }
            if let lastCode = snipLabels.last {
                snipLabels[snipLabels.count-1] = String(lastCode[..<lastCode.index(before: lastCode.endIndex)])
            }
            let snips = snipLabels.compactMap {
                BaseSnip(
                    label: String($0),
                    spaceCount: colCount,
                    codeType: codeType
                )
            }
            invocation.buffer.lines.removeObject(at: lineNumber)
            for snip in snips {
                invocation.buffer.lines.insert(snip.code, at: lineNumber)
                lineNumber += snip.lineNumber
            }
            invocation.buffer.selections.removeAllObjects()
            invocation.buffer.selections.add(
                XCSourceTextRange(
                    start: .init(line: lineNumber-2, column: colCount+1),
                    end: .init(line: lineNumber-2, column: colCount+1)
                )
            )
            return
        }
        
        // MARK: - Property mode
        
        // Property mode
        let properties = decoderPropertyCode(code: code, codeType: codeType)
        invocation.buffer.lines.removeObject(at: lineNumber)
        // Make the cursor stop on the first placeholder of the generated text.
        var autoSelectFirstPlaceholder: XCSourceTextRange?
        // The generated text not having any placeholder, move the cursor beind the last character for conveniently performing next actions.
        var autoMoveCursorBehindLastChar: XCSourceTextRange?
        for property in properties {
            var propertyCode: String = ""
            if codeType == .swift {
                propertyCode = generatePropertyCode(property: property, spaceCount: colCount)
            }
            if codeType == .oc {
                propertyCode = generateOCPropertyCode(property: property, spaceCount: colCount)
            }
            if autoSelectFirstPlaceholder == nil,
               let range = regularMatchRange(text: propertyCode, expression: "(.*)?").first
            {
                autoSelectFirstPlaceholder = XCSourceTextRange(
                    start: XCSourceTextPosition(
                        line: lineNumber,
                        column: range.location
                    ),
                    end: XCSourceTextPosition(
                        line: lineNumber,
                        column: range.location + range.length
                    )
                )
            }
            invocation.buffer.lines.insert(propertyCode, at: lineNumber)
            autoMoveCursorBehindLastChar = XCSourceTextRange(
                start: XCSourceTextPosition(
                    line: lineNumber,
                    column: propertyCode.count
                ),
                end: XCSourceTextPosition(
                    line: lineNumber,
                    column: propertyCode.count
                )
            )
            lineNumber += property.lineNumber
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
