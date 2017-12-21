
//  MasonrySnip.swift
//  Fly
//
//  Created by SSBun on 2017/12/20.
//  Copyright © 2017年 SSBun. All rights reserved.
//

import Foundation

class MasonrySinp: Snip {
    
    var label: String
    var code: String
    var lineCount: Int
    var codeType: CodeType    
    
    required init?(label: String, spaceCount: Int, codeType: CodeType) {
        if codeType != .oc {return nil}
        guard let code = regularMatch(text: label, expression: "(?<=\\().+(?=\\))").first else {return nil}
        guard let mark = regularMatch(text: label, expression: "^[a-zA-Z]+").first else {return nil}
        let snapList = ["masm": "mas_makeConstraints:^(MASConstraintMaker *make) {\n",
                        "masu": "mas_updateConstraints:^(MASConstraintMaker *make) {\n",
                        "masrm": "mas_remakeConstraints:^(MASConstraintMaker *make) {\n",
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
        resultCode += " " * spaceCount + "[" + layoutView + " " + snapList[mark]!
        for item in layoutCodes {
            resultCode += " " * (spaceCount + 4) + item + "\n"
        }
        resultCode += " " * spaceCount + "}];"
        self.label = label
        self.code = resultCode
        self.codeType = codeType
        self.lineCount = layoutCodes.count + 3
    }
}
