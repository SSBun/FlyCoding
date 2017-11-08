//
//  SnapExpression.swift
//  Fly Coding
//
//  Created by SSBun on 22/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Foundation

// le.,r,b,t,cx,cy,c,w,h,s,e,


public struct ConstraintMaker {
    static let makerMap = ["l": "left",
                           "t": "top",
                           "b": "bottom",
                           "r": "right",
                           "w": "width",
                           "h": "height",
                           "x": "centerX",
                           "y": "centerY",
                           "c": "center",
                           "s": "size",
                           "e": "edges"]
    
    var makers: [String]
    
    init(code: String) {
        var tempArr = [String]()
        for c in code {
            if let m = ConstraintMaker.makerMap[String(c)] {
                tempArr.append(m)
            }
        }
        self.makers = tempArr
    }
    static func isMakerCode(code: String) -> Bool {
        return regularMatchLike(text: code, expression: "^[ltbrwhxycse]+$")
    }
}

public struct SnapExpression {
    public private(set) var expression: String
    public private(set) var decoderCode: String?
    
    public init(_ expression: String) {
        self.expression = expression
        guard expression.count > 0 else {return}
        var nsExpression = NSString(string: expression)
        var compareFlagRange: NSRange?
        var compareFlag = ""
        for item in ["<=", ">=", "="] {
            let tempRange = nsExpression.range(of: item)
            if tempRange.location != NSNotFound {
                compareFlag = item
                compareFlagRange = tempRange
                break
            }
        }
        guard let nCompareFlagRange = compareFlagRange else {return}
        
        let selfConstraint = nsExpression.substring(to: nCompareFlagRange.location)
        guard ConstraintMaker.isMakerCode(code: selfConstraint) else {return}
        
        // There are the layout flags will be add.
        let selfMakers = ConstraintMaker(code: selfConstraint).makers
        if selfMakers.isEmpty {return}
        nsExpression = NSString(string: nsExpression.substring(from: nCompareFlagRange.location + nCompareFlagRange.length))
        
        // The constrain priority
        var constrainPriority: String?
        let constrainPriorityRange = nsExpression.range(of: "~")
        if constrainPriorityRange.location != NSNotFound {
            constrainPriority = nsExpression.substring(from: constrainPriorityRange.location)
            nsExpression = NSString(string: nsExpression.substring(to: constrainPriorityRange.location))
        }
        
        var computeFlagRange: NSRange?
        var computeFlag: String?
        var computeValue: String?
        for item in ["+", "-", "*", "/"] {
            let tempRange = nsExpression.range(of: item)
            if tempRange.location != NSNotFound {
                if let t = computeFlagRange {
                    if tempRange.location < t.location {
                        computeFlag = item
                        computeFlagRange = tempRange
                    }
                } else {
                    computeFlag = item
                    computeFlagRange = tempRange
                }
            }
        }
        if let nComputeFlagRange = computeFlagRange {
            computeValue = nsExpression.substring(from: nComputeFlagRange.location + nComputeFlagRange.length)
            nsExpression = NSString(string: nsExpression.substring(to: nComputeFlagRange.location))
        }
        var computeObjects = nsExpression.components(separatedBy: ".")
        if computeObjects.isEmpty {return}
        if computeObjects.count >= 2, let lastObject = computeObjects.last, ConstraintMaker.isMakerCode(code: lastObject) {
            computeObjects.removeLast()
            computeObjects.append("snp")
            computeObjects += ConstraintMaker(code: lastObject).makers
        }
        
        var decoderCode = "$0."
        
        decoderCode += selfMakers.joined(separator: ".")
        decoderCode += ".\(compareFlagCode(with: compareFlag))"
        decoderCode += "(\(computeObjects.joined(separator: ".")))"
        if let c = computeFlag, let v = computeValue {
            decoderCode += ".\(computeFlagCode(with: c, value: v))"
        }
        if let c = constrainPriority, let v = constrainPriorityCode(with: c) {
            decoderCode += ".\(v)"
        }
        self.decoderCode = decoderCode
    }
    
    private func constrainPriorityCode(with code: String) -> String? {
        
        let nCode = String(code[code.index(after: code.startIndex)...])
        let flags = ["r": ".required",
                     "h": ".high",
                     "m": ".medium",
                     "l": ".low"]
        if let flag = flags[nCode] {
            return "priority(\(flag))"
        }
        if let level = Int(nCode) {
            return "priority(\(level))"
        }
        return nil
    }
    
    private func compareFlagCode(with flag: String) -> String {
        let flags = [">=": "greaterThanOrEqualTo",
                     "<=": "lessThanOrEqualTo",
                     "=": "equalTo"]
        return flags[flag] ?? "="
    }
    
    private func computeFlagCode(with flag: String, value: String) -> String {
        switch flag {
        case "-":
            return "offset(-\(value))"
        case "+":
            return "offset(\(value))"
        case "*":
            return "multipliedBy(\(value))"
        case "/":
            return "dividedBy(\(value))"
        default:
            return ""
        }
    }
}

