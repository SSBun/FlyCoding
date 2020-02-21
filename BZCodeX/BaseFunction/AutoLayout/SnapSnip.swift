//
//  SnapSnip.swift
//  Fly
//
//  Created by SSBun on 2017/11/9.
//  Copyright © 2017年 SSBun. All rights reserved.
//
import Foundation

class SnapSnip: Snip {

    var label: String
    var code: String
    var lineCount: Int
    var codeType: CodeType

    required init?(label: String, spaceCount: Int, codeType: CodeType) {
        if codeType != .swift {return nil}
        guard let code = regularMatch(text: label, expression: "(?<=\\().+(?=\\))").first else {return nil}
        guard let mark = regularMatch(text: label, expression: "^[a-zA-Z]+").first else {return nil}
        var repeatCount = 1
        if let countStr = regularMatch(text: label, expression: "(?<=\\)\\*)[\\d]+\\b").first, let count = Int(countStr), count >= 1 {
            repeatCount = count
        }
        let snapList = ["snpm": ".snp.makeConstraints {\n",
                        "snpu": ".snp.updateConstraints {\n",
                        "snprm": ".snp.remakeConstraints {\n"
                        ]
        let params = code.split(separator: ",").map {String($0)}
        if params.isEmpty {return nil}
        let layoutView = params[0]
        let layoutFlags = Array(params[1...])
        var layoutCodes = [String]()
        for flag in layoutFlags {
            if let layoutStr = SnapExpression(flag).decoderCode {
                layoutCodes.append(layoutStr)
            }
        }
        var resultCode = ""
        for _ in 0..<repeatCount {
            resultCode += " " * spaceCount + layoutView + snapList[mark]!
            for item in layoutCodes {
                resultCode += " " * (spaceCount + 4) + item + "\n"
            }
            resultCode += " " * spaceCount + "}"
            resultCode += "\n\n"
        }
        self.label = label
        self.code = resultCode
        self.codeType = codeType
        self.lineCount = (layoutCodes.count + 3) * repeatCount
    }
}
