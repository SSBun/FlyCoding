//  MasonrySnip.swift
//  Fly
//
//  Created by SSBun on 2017/12/20.
//  Copyright © 2017年 SSBun. All rights reserved.
//

import Foundation

public class MasonrySinp: Snip {

    public private(set) var label: String
    public private(set) var code: String
    public private(set) var lineNumber: Int
    public private(set) var codeType: CodeType

    public required init?(label: String, spaceCount: Int, codeType: CodeType) {
        if codeType != .oc {return nil}
        guard let code = regularMatch(text: label, expression: "(?<=\\().+(?=\\))").first else {return nil}
        guard let mark = regularMatch(text: label, expression: "^[a-zA-Z]+").first else {return nil}
        var repeatCount = 1
        if let countStr = regularMatch(text: label, expression: "(?<=\\)\\*)[\\d]+\\b").first, let count = Int(countStr), count >= 1 {
            repeatCount = count
        }
        let snapList = ["masm": "mas_makeConstraints:^(MASConstraintMaker *make) {\n",
                        "masu": "mas_updateConstraints:^(MASConstraintMaker *make) {\n",
                        "masrm": "mas_remakeConstraints:^(MASConstraintMaker *make) {\n"
                        ]

        let params = code.split(separator: ",").map {String($0)}
        if params.isEmpty {return nil}
        let layoutView = params[0]
        let layoutFlags = Array(params[1...])
        var layoutCodes = [String]()
        for flag in layoutFlags {
            if let layoutStr = MasonryExpression(flag).decoderCode {
                layoutCodes.append(layoutStr)
            }
        }

        var resultCode = ""
        for _ in 0..<repeatCount {
            resultCode += " " * spaceCount + "[" + layoutView + " " + snapList[mark]!
            for item in layoutCodes {
                resultCode += " " * (spaceCount + 4) + item + "\n"
            }
            resultCode += " " * spaceCount + "}];"
            resultCode += "\n\n"
        }
        self.label = label
        self.code = resultCode
        self.codeType = codeType
        self.lineNumber = (layoutCodes.count + 3) * repeatCount
    }
}
