//
//  AutoLayoutSwift.swift
//  Fly
//
//  Created by caishilin on 2019/4/23.
//  Copyright © 2019 SSBun. All rights reserved.
//

import Foundation

class AutoLayoutSwift: Snip {

    var label: String
    var code: String
    var lineNumber: Int
    var codeType: CodeType

    required init?(label: String, spaceCount: Int, codeType: CodeType) {
        if codeType != .swift {return nil}
        guard let code = regularMatch(text: label, expression: "(?<=\\().+(?=\\))").first else {return nil}
        guard let mark = regularMatch(text: label, expression: "^[a-zA-Z]+").first else {return nil}
        var repeatCount = 1
        if let countStr = regularMatch(text: label, expression: "(?<=\\)\\*)[\\d]+\\b").first, let count = Int(countStr), count >= 1 {
            repeatCount = count
        }
        let snapList = [
            "layout": "NSLayoutConstraint.activate([\n"
        ]
        
        let params = code.split(separator: ",").map {String($0)}
        if params.isEmpty {return nil}
        let layoutView = params[0]
        let layoutFlags = Array(params[1...])
        var layoutCodes = [String]()
        for flag in layoutFlags {
            if let layoutStrs = AutoLayoutExpression(layoutView: layoutView, expression: flag).decoderCode {
                layoutCodes.append(contentsOf: layoutStrs)
            }
        }

        var resultCode = ""
        for _ in 0..<repeatCount {
            resultCode += " " * spaceCount + snapList[mark]!
            let totalCount = layoutCodes.count
            for (index, item) in layoutCodes.enumerated() {
                resultCode += " " * (spaceCount + 4) + item + (totalCount == index+1 ? "" : ",") + "\n"
            }
            resultCode += " " * (spaceCount + 4) + "])"
            resultCode += "\n\n"
        }
        self.label = label
        self.code = resultCode
        self.codeType = codeType
        self.lineNumber = (layoutCodes.count + 3) * repeatCount
    }
}
