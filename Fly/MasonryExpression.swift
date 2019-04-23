//
//  MasonryExpression.swift
//  Fly
//
//  Created by SSBun on 2017/12/20.
//  Copyright © 2017年 SSBun. All rights reserved.
//

import Foundation


// le.,r,b,t,cx,cy,c,w,h,s,e,

/*!
 View constrained labels
 */
public struct MSLConstraintMaker {
    static let makerMap = ["l": "leading",
                           "t": "top",
                           "b": "bottom",
                           "r": "trailing",
                           "w": "width",
                           "h": "height",
                           "x": "centerX",
                           "y": "centerY",
                           "c": "center",
                           "s": "size",
                           "e": "edges"]
    
    /*! all constrainted items */
    var makers: [String]
    
    /*!
     Resolves each character of the string to constraint.
     */
    init(code: String) {
        var tempArr = [String]()
        for c in code {
            if let m = MSLConstraintMaker.makerMap[String(c)] {
                tempArr.append(m)
            }
        }
        self.makers = tempArr
    }
    
    /*!
     Verify that the string can be resolved.
     */
    static func isMakerCode(code: String) -> Bool {
        return regularMatchLike(text: code, expression: "^[ltbrwhxycse]+$")
    }
}

public struct MSRConstraintMaker {
    static let makerMap = ["l": "mas_leading",
                           "t": "mas_top",
                           "b": "mas_bottom",
                           "r": "mas_trailing",
                           "w": "mas_width",
                           "h": "mas_height",
                           "x": "mas_centerX",
                           "y": "mas_centerY"]
    /*! all constrainted items */
    var makers: [String]
    
    /*!
     Generate constraints with characters from the string;
     */
    init(code: String) {
        var tempArr = [String]()
        for c in code {
            if let m = MSRConstraintMaker.makerMap[String(c)] {
                tempArr.append(m)
            }
        }
        self.makers = tempArr
    }
    
    /*!
     Verify that the string can be resolved.
     */
    static func isMakerCode(code: String) -> Bool {
        return regularMatchLike(text: code, expression: "^[ltbrwhxy]+$")
    }
}


/*!
 Snap constraint expression
 */
public struct MasonryExpression {
    /// Constraint expressionn code
    public private(set) var expression: String
    /// Result of the resolved.
    public private(set) var decoderCode: String?
    
    public init(_ expression: String) {
        self.expression = expression
        guard expression.count > 0 else {return}
        var nsExpression = NSString(string: expression)
        var compareFlagRange: NSRange?
        var compareFlag = ""
        for item in ["<==", ">==", "==", "<=", ">=", "="] {
            let tempRange = nsExpression.range(of: item)
            if tempRange.location != NSNotFound {
                compareFlag = item
                compareFlagRange = tempRange
                break
            }
        }
        guard let nCompareFlagRange = compareFlagRange else {return}
        
        let selfConstraint = nsExpression.substring(to: nCompareFlagRange.location)
        guard MSLConstraintMaker.isMakerCode(code: selfConstraint) else {return}
        
        // There are the layout flags will be add.
        let selfMakers = MSLConstraintMaker(code: selfConstraint).makers
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
        
        var isPositiveOrNegativeComputeFlag = false
        if computeFlag == "+" || computeFlag == "-" {
            isPositiveOrNegativeComputeFlag = true
        }
        
        if let nComputeFlagRange = computeFlagRange {
            computeValue = nsExpression.substring(from: nComputeFlagRange.location + nComputeFlagRange.length)
            nsExpression = NSString(string: nsExpression.substring(to: nComputeFlagRange.location))
        }
        var computeObjects = nsExpression.components(separatedBy: ".")
        if computeObjects.first?.count == 0 && !isPositiveOrNegativeComputeFlag {return}
        if computeObjects.count >= 2, let lastObject = computeObjects.last, MSRConstraintMaker.isMakerCode(code: lastObject) {
            computeObjects.removeLast()
            computeObjects += MSRConstraintMaker(code: lastObject).makers
        }
        if computeObjects.first?.count == 0 {
            if let c = computeFlag, let v = computeValue {
                computeObjects.removeAll()
                computeObjects.append(baseValueCode(with: c, value: v))
                computeFlag = nil
                computeValue = nil
            }
        }
        
        
        var decoderCode = "make."
        
        decoderCode += selfMakers.joined(separator: ".")
        decoderCode += ".\(compareFlagCode(with: compareFlag))"
        decoderCode += "(\(computeObjects.joined(separator: ".")))"
        if let c = computeFlag, let v = computeValue {
            decoderCode += ".\(computeFlagCode(with: c, value: v))"
        }
        if let c = constrainPriority, let v = constrainPriorityCode(with: c) {
            decoderCode += ".\(v)"
        }
        decoderCode += ";"
        self.decoderCode = decoderCode
    }
    
    private func constrainPriorityCode(with code: String) -> String? {
        let nCode = String(code[code.index(after: code.startIndex)...])
        let flags = ["h": "priorityHigh",
                     "m": "priorityMedium",
                     "l": "priorityLow"]
        if let flag = flags[nCode] {
            return flag
        }
        if let level = Int(nCode) {
            return "priority(\(level))"
        }
        return nil
    }
    
    private func compareFlagCode(with flag: String) -> String {
        let flags = [">=": "greaterThanOrEqualTo",
                     "<=": "lessThanOrEqualTo",
                     "=": "equalTo",
                     "<==": "mas_lessThanOrEqualTo",
                     ">==": "mas_greaterThanOrEqualTo",
                     "==": "mas_equalTo"]
        return flags[flag] ?? "equalTo"
    }
    
    private func baseValueCode(with flag: String, value: String) -> String {
        switch flag {
        case "-":
            return "-\(value)"
        default:
            return value
        }
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
