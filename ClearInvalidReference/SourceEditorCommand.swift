//
//  SourceEditorCommand.swift
//  ClearInvalidReference
//
//  Created by SSBun on 2018/3/5.
//  Copyright © 2018年 SSBun. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

    // Default system frameworks. we will ignore these frameworks if user import it and not use.
    private let systemFramework: Set<String> = ["UIKit/UIKit.h", "objc/runtime.h", "objc/objc.h", "Foundation/Foundation.h", "kit", "sdk", "-Swift"]

    private var validImport: [String: Int] = [:]
    private var usedImport: Set<String> = []
    private var duplicateImport: [Int: String] = [:]
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

        for (index, code) in invocation.buffer.lines.enumerated() {
            if var rowCode = code as? String {
                rowCode = rowCode.trimmingCharacters(in: .whitespaces)
                if rowCode.hasPrefix("//") {continue}
                if rowCode.hasPrefix("#import") || rowCode.hasPrefix("#include") {
                    if let range = rowCode.range(of: "(?<=\").*?(?=\")|(?<=<).*?(?=>)", options: .regularExpression, range: rowCode.startIndex..<rowCode.endIndex, locale: nil) {
                        let moduleName = String(rowCode[range])
                        if validImport[moduleName] == nil {
                            validImport[moduleName] = index
                        } else {
                            duplicateImport[index] = moduleName
                        }
                    }
                } else {
                    validImport.forEach({ (key, _) in
                        if let range = key.range(of: "[a-zA-Z0-9_]*?(?=\\.)|[a-zA-Z0-9_]*?(?=\\+)|[a-zA-Z0-9_]*?(?=/)", options: .regularExpression, range: key.startIndex..<key.endIndex, locale: nil) {
                            let className = String(key[range])
                            if rowCode.contains(className) {
                                usedImport.insert(key)
                            }
                        }
                    })
                }
            }
        }

        for (name, index) in validImport {
            if !usedImport.contains(name) {
                var isSystem = false
                for item in systemFramework {
                    if name.lowercased().contains(item.lowercased()) {
                        isSystem = true
                        break
                    }
                }
                if let str = invocation.buffer.lines[index] as? String, !isSystem {
                    invocation.buffer.lines[index] = "\(str.trimmingCharacters(in: .whitespacesAndNewlines)) //Never used"
                }
            }
        }

        var indexSet = IndexSet()
        duplicateImport.forEach {
            indexSet.insert($0.key)
        }
        invocation.buffer.lines.removeObjects(at: indexSet)
        completionHandler(nil)
    }
    
}
