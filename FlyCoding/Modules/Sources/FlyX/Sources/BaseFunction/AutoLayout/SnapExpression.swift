//
//  SnapExpression.swift
//  Fly Coding
//
//  Created by SSBun on 22/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Foundation

// MARK: - ConstraintMaker

// le.,r,b,t,cx,cy,c,w,h,s,e,

/// !
// View constrained labels
public struct ConstraintMaker {
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

    /// ! all constrainted items
    var makers: [String]

    /// !
    // Resolves each character of the string to constraint.
    init(code: String) {
        var tempArr = [String]()
        for c in code {
            if let m = ConstraintMaker.makerMap[String(c)] {
                tempArr.append(m)
            }
        }
        self.makers = tempArr
    }

    /// !
    // Verify that the string can be parsed.
    static func isMakerCode(code: String) -> Bool {
        return regularMatchLike(text: code, expression: "^[ltbrwhxycse]+$")
    }
}

// MARK: - SnapExpression

/// !
// Snap constraint expression
public struct SnapExpression {
    /// Constraint expression code
    public private(set) var expression: String
    /// Results of parsed.
    public private(set) var decoderCode: String?
    // swiftlint:disable cyclomatic_complexity
    public init(_ expression: String) {
        self.expression = expression
        guard expression.count > 0 else {
            return
        }
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
        guard let nCompareFlagRange = compareFlagRange else {
            return
        }

        let selfConstraint = nsExpression.substring(to: nCompareFlagRange.location)
        guard ConstraintMaker.isMakerCode(code: selfConstraint) else {
            return
        }

        // The layout flags that will be added.
        let selfMakers = ConstraintMaker(code: selfConstraint).makers
        if selfMakers.isEmpty {
            return
        }
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
        for item in ["++", "--", "+", "-", "*", "/"] {
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
        if computeObjects.first?.count == 0, !isPositiveOrNegativeComputeFlag {
            return
        }
        if computeObjects.count >= 2, let lastObject = computeObjects.last, ConstraintMaker.isMakerCode(code: lastObject) {
            computeObjects.removeLast()
            computeObjects.append("snp")
            computeObjects += ConstraintMaker(code: lastObject).makers
        }
        
        if computeObjects.first?.count == 0 {
            if let c = computeFlag, let v = computeValue {
                computeObjects.removeAll()
                computeObjects.append(baseValueCode(with: c, value: v))
                computeFlag = nil
                computeValue = nil
            }
        }
        
        let valueMakers: [ConstraintValueMaker] = [
            ConstraintSizeMaker(),
            ConstraintEdgesMaker()
        ]
        
        var decoderCode = "$0."
        decoderCode += selfMakers.joined(separator: ".")
        decoderCode += ".\(compareFlagCode(with: compareFlag))"
        
        var constraintValueStr: String?
        for maker in valueMakers {
            if let constraintValue = maker.tryGenerateValue(
                makers: selfMakers,
                computeObjects: computeObjects
            ) {
                constraintValueStr = constraintValue
                break
            }
        }
        decoderCode += constraintValueStr ?? "(\(computeObjects.joined(separator: ".")))"
        
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
        case "++":
            return "inset(\(value))"
        case "--":
            return "inset(-\(value))"
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

// MARK: - ConstraintValueMaker

protocol ConstraintValueMaker {
    func tryGenerateValue(makers: [String], computeObjects: [String]) -> String?
}

private struct ConstraintSizeMaker: ConstraintValueMaker {
    func tryGenerateValue(
        makers: [String],
        computeObjects: [String]
    ) -> String? {
        // Must only have the `size` constraint.
        guard
            makers.count == 1,
            makers.contains("size"),
            computeObjects.count == 1,
            computeObjects[0].first == "@"
        else { return nil }
        
        var sizeStr = computeObjects[0]
        sizeStr.removeFirst()
        let sizeValues = sizeStr.components(separatedBy: "@")
        
        var widthValue = ""
        var heightValue = ""
        if sizeValues.count == 1 {
            widthValue = sizeValues[0]
            heightValue = sizeValues[0]
        } else if sizeValues.count == 2 {
            widthValue = sizeValues[0]
            heightValue = sizeValues[1]
        } else {
            return nil
        }
        return "(CGSize(width: \(widthValue), height: \(heightValue)))"
    }
}

private struct ConstraintEdgesMaker: ConstraintValueMaker {
    func tryGenerateValue(
        makers: [String],
        computeObjects: [String]
    ) -> String? {
        // Must only have the `edges` constraint.
        guard
            makers.count == 1,
            makers.contains("edges"),
            computeObjects.count == 1,
            computeObjects[0].first == "@"
        else { return nil }
        
        var sizeStr = computeObjects[0]
        sizeStr.removeFirst()
        let sizeValues = sizeStr.components(separatedBy: "@")
        
        var topValue = ""
        var leftValue = ""
        var bottomValue = ""
        var rightValue = ""
        if sizeValues.count == 1 {
            topValue = sizeValues[0]
            leftValue = sizeValues[0]
            bottomValue = sizeValues[0]
            rightValue = sizeValues[0]
        } else if sizeValues.count == 2 {
            topValue = sizeValues[0]
            leftValue = sizeValues[1]
            bottomValue = sizeValues[0]
            rightValue = sizeValues[1]
        } else if sizeValues.count == 4 {
            topValue = sizeValues[0]
            leftValue = sizeValues[1]
            bottomValue = sizeValues[2]
            rightValue = sizeValues[3]
        } else {
            return nil
        }
        return "(UIEdgeInsets(top: \(topValue), left: \(leftValue), bottom: \(bottomValue), right: \(rightValue)))"
    }
}




