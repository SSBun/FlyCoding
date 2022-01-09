//
//  AnimationSnip.swift
//  Fly
//
//  Created by SSBun on 2017/11/9.
//  Copyright © 2017年 SSBun. All rights reserved.
//

import Foundation

/*!
 Generate view animation code
 */
class AnimationSnip: Snip {
    var label: String
    var code: String
    var lineNumber: Int
    var codeType: CodeType

    required init?(label: String, spaceCount: Int, codeType: CodeType) {

        guard let paramStr = regularMatch(text: label, expression: "(?<=\\().+(?=\\))").first else {return nil}
        let params = paramStr.split(separator: ".")
        var prefix: String = "" // Animation type
        prefix = String(params[0])
        if prefix.count <= 0 {prefix = "df"}

        var codes = [String]()
        switch prefix.lowercased() {
        case "df":
            codes = ["UIView.animate(withDuration: <#T##TimeInterval#>) {",
                     " " * 4 + "<#code#>",
                     "}"]
        case "dc":
            codes = ["UIView.animate(withDuration: <#T##TimeInterval#>, animations: {",
                     "    <#code#>",
                     "}) { (<#Bool#>) in",
                     "    <#code#>",
                     "}"]
        case "dd":
            codes = ["UIView.animate(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, options: <#T##UIViewAnimationOptions#>, animations: {",
                     "    <#code#>",
                     "}) { (<#Bool#>) in",
                     "    <#code#>",
                     "}"]
        case "ds":
            codes = ["UIView.animate(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, usingSpringWithDamping: <#T##CGFloat#>, initialSpringVelocity: <#T##CGFloat#>, options: <#T##UIViewAnimationOptions#>, animations: {",
                     "    <#code#>",
                     "}) { (<#Bool#>) in",
                     "    <#code#>",
                     "}"]
        case "dk":
            codes = ["UIView.animateKeyframes(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, options: <#T##UIViewKeyframeAnimationOptions#>, animations: {",
                     "    <#code#>",
                     "}) { (<#Bool#>) in",
                     "    <#code#>",
                     "}"]
        default:
            codes = []
        }

        let repeatCount = Int(regularMatch(text: label, expression: "(?<=\\*)[0-9]+").first ?? "1") ?? 1
        if codes.count > 0 {
            self.label = label
            var code = ""
            for _ in 0..<repeatCount {
                code += codes.reduce("") {
                    $0 + " " * spaceCount + $1 + "\n"
                }
                code += "\n"
            }
            self.code = code
            self.lineNumber = repeatCount * (codes.count + 1)
            self.codeType = codeType
        } else {
            return nil
        }
    }
}
