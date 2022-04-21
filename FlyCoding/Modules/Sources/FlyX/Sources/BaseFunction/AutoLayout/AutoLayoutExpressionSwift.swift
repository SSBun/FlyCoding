//
//  AutoLayoutExpressionSwift.swift
//  Fly
//
//  Created by caishilin on 2019/4/23.
//  Copyright © 2019 SSBun. All rights reserved.
//

import Foundation

// le.,r,b,t,cx,cy,c,w,h,s,e,

// layout(label, lrt=view+100)
// layout(label, r=view+200)
// layout(label, w=)

/*!
 View constrained labels
 */

private struct Anchor {
    let view: String
    let anchor: String
    var code: String { "\(view).\(AutoLayoutConstraintMaker.parse(anchor))" }
}

private typealias ConstraintRealtion = (left: Anchor, to: Anchor?, multiplier: String?, constant: String?)

private enum AutoLayoutConstraintMode {
    // MARK: - EqualTo
    /// view.leadingAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>)
    /// view.widthAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutDimension>#>)
    /// view.widthAnchor.constraint(equalToConstant: <#T##CGFloat#>)
    /// view.leadingAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>, constant: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutDimension>#>, constant: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(equalTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(equalTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
    case equal(ConstraintRealtion)

    // MARK: - GreaterThanOrEqualTo
    /// view.leadingAnchor.constraint(greaterThanOrEqualTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>)
    /// view.leadingAnchor.constraint(greaterThanOrEqualTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>, constant: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(greaterThanOrEqualToConstant: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(greaterThanOrEqualTo: <#T##NSLayoutAnchor<NSLayoutDimension>#>)
    /// view.widthAnchor.constraint(greaterThanOrEqualTo: <#T##NSLayoutAnchor<NSLayoutDimension>#>, constant: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(greaterThanOrEqualTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(greaterThanOrEqualTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
    case greaterThanOrEqualTo(ConstraintRealtion)

    /// view.leadingAnchor.constraint(lessThanOrEqualTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>)
    /// view.leadingAnchor.constraint(lessThanOrEqualTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>, constant: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(lessThanOrEqualToConstant: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(lessThanOrEqualTo: <#T##NSLayoutAnchor<NSLayoutDimension>#>)
    /// view.widthAnchor.constraint(lessThanOrEqualTo: <#T##NSLayoutAnchor<NSLayoutDimension>#>, constant: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(lessThanOrEqualTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>)
    /// view.widthAnchor.constraint(lessThanOrEqualTo: <#T##NSLayoutDimension#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
    case lessThanOrEqualTo(ConstraintRealtion)
}

extension AutoLayoutConstraintMode {
    // swiftlint:disable cyclomatic_complexity
    func transform() -> String {
        switch self {
        case .equal((left: let left, to: .some(let right), multiplier: .none, constant: .none)):
            return "\(left.code).constraint(equalTo: \(right.code))"
        case .equal((left: let left, to: .some(let right), multiplier: .none, constant: .some(let constant))):
            return "\(left.code).constraint(equalTo: \(right.code), constant:\(constant))"
        case .equal((left: let left, to: .none, multiplier: .none, constant: .some(let constant))):
            return "\(left.code).constraint(equalToConstant: \(constant))"
        case .equal((left: let left, to: .some(let right), multiplier: .some(let multiplier), constant: .none)):
            return "\(left.code).constraint(equalTo: \(right.code), multiplier:\(multiplier))"
        case .equal((left: let left, to: .some(let right), multiplier: .some(let multiplier), constant: .some(let constant))):
            return "\(left.code).constraint(equalTo: \(right.code), multiplier:\(multiplier), constant:(\(constant))"

        case .greaterThanOrEqualTo((left: let left, to: .some(let right), multiplier: .none, constant: .none)):
            return "\(left.code).constraint(greaterThanOrEqualTo: \(right.code))"
        case .greaterThanOrEqualTo((left: let left, to: .some(let right), multiplier: .none, constant: .some(let constant))):
            return "\(left.code).constraint(greaterThanOrEqualTo: \(right.code), constant:\(constant))"
        case .greaterThanOrEqualTo((left: let left, to: .none, multiplier: .none, constant: .some(let constant))):
            return "\(left.code).constraint(greaterThanOrEqualToConstant: \(constant))"
        case .greaterThanOrEqualTo((left: let left, to: .some(let right), multiplier: .some(let multiplier), constant: .none)):
            return "\(left.code).constraint(greaterThanOrEqualTo: \(right.code), multiplier:\(multiplier))"
        case .greaterThanOrEqualTo((left: let left, to: .some(let right), multiplier: .some(let multiplier), constant: .some(let constant))):
            return "\(left.code).constraint(greaterThanOrEqualTo: \(right.code), multiplier:\(multiplier), constant:(\(constant))"

        case .lessThanOrEqualTo((left: let left, to: .some(let right), multiplier: .none, constant: .none)):
            return "\(left.code).constraint(lessThanOrEqualTo: \(right.code))"
        case .lessThanOrEqualTo((left: let left, to: .some(let right), multiplier: .none, constant: .some(let constant))):
            return "\(left.code).constraint(lessThanOrEqualTo: \(right.code), constant:\(constant))"
        case .lessThanOrEqualTo((left: let left, to: .none, multiplier: .none, constant: .some(let constant))):
            return "\(left.code).constraint(lessThanOrEqualToConstant: \(constant))"
        case .lessThanOrEqualTo((left: let left, to: .some(let right), multiplier: .some(let multiplier), constant: .none)):
            return "\(left.code).constraint(lessThanOrEqualTo: \(right.code), multiplier:\(multiplier))"
        case .lessThanOrEqualTo((left: let left, to: .some(let right), multiplier: .some(let multiplier), constant: .some(let constant))):
            return "\(left.code).constraint(lessThanOrEqualTo: \(right.code), multiplier:\(multiplier), constant:(\(constant))"
        default:
            return "error"
        }
    }
}

//#snpm(view, e=self.view+10/10/10/10)

public struct AutoLayoutConstraintMaker {
    static let makerMap = ["l": "leadingAnchor",
                           "t": "topAnchor",
                           "b": "bottomAnchor",
                           "r": "trailingAnchor",
                           "w": "widthAnchor",
                           "h": "heightAnchor",
                           "x": "centerXAnchor",
                           "y": "centerYAnchor",
                           "F": "firstBaselineAnchor",
                           "L": "lastBaselineAnchor"]

    /// Verify whether the string can be parsed.
    static func isMakerCode(code: String) -> Bool {
        return regularMatchLike(text: code, expression: "^[ltbrwhxyFL]+$")
    }

    static func parse(_ code: String) -> String {
        if isMakerCode(code: code) {
            return makerMap[code] ?? "unsupport"
        } else {
            return "[\(code) parse error]"
        }
    }
}

/// Snap constraint expression
public struct AutoLayoutExpression {

    /// Constraint expressionn code
    public private(set) var expression: String
    private let layoutView: String
    /// Result of the resolved.
    public private(set) var decoderCode: [String]?

    public init(layoutView: String, expression: String) {
        self.layoutView = layoutView
        self.expression = expression
        guard expression.count > 0 else {return}
        var nsExpression = NSString(string: expression)
        var compareFlagRange: NSRange?
        // The constraint relation of view.
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

        /// The constraint flags of the left view.
        let selfConstraint = nsExpression.substring(to: nCompareFlagRange.location)
        
        guard AutoLayoutConstraintMaker.isMakerCode(code: selfConstraint) else {return}

        nsExpression = NSString(string: nsExpression.substring(from: nCompareFlagRange.location + nCompareFlagRange.length))

        // Get the constant value from the expresison if existed.
        var constant: String?
        let constantFlagRange = nsExpression.range(of: ":")
        if constantFlagRange.location != NSNotFound {
            constant = nsExpression.substring(from: constantFlagRange.location + constantFlagRange.length)
            nsExpression = NSString(string: nsExpression.substring(to: constantFlagRange.location))
        }

        // The multiplier value
        var computeFlagRange: NSRange?
        var computeValue: String?

        let tempRange = nsExpression.range(of: "*")
        if tempRange.location != NSNotFound {
            computeFlagRange = tempRange
        }

        if let nComputeFlagRange = computeFlagRange {
            computeValue = nsExpression.substring(from: nComputeFlagRange.location + nComputeFlagRange.length)
            nsExpression = NSString(string: nsExpression.substring(to: nComputeFlagRange.location))
        }

        let computeObjects = nsExpression.components(separatedBy: ".")

        // The right view.
        var targetView: String?
        // The constraint flags relating with the right view.
        var targetConstraint: String?

        if computeObjects.count == 1 && computeObjects[0].count != 0 {
            targetView = computeObjects.first
        } else if computeObjects.count == 2, AutoLayoutConstraintMaker.isMakerCode(code: computeObjects[1]) {
            targetView = computeObjects[0]
            targetConstraint = computeObjects[1]
        }

        // The left layout view having more than one constraint flag, the right view must have none flags.
        if selfConstraint.count > 1 && nil != targetConstraint {
            return
        }
        // If the left layout view has just one constraint flag, but the rigth view has more than one flags. we return directly.
        if selfConstraint.count == 1 && targetConstraint?.count ?? 0 > 1 {
            return
        }

        var modes: [AutoLayoutConstraintMode] = []

        // State: the left view has only one constraint flag.
        if selfConstraint.count == 1 {
            let leftAnchor = Anchor(view: layoutView, anchor: selfConstraint)
            var rightAnchor: Anchor?
            if let targetView = targetView {
                rightAnchor = Anchor(view: targetView, anchor: targetConstraint ?? selfConstraint)
            }
            let relation: ConstraintRealtion = (left: leftAnchor, to: rightAnchor, multiplier:computeValue, constant: constant)
            modes.append(generateMode(relation: relation, compareFlag: compareFlag))
        }

        // State: the left view has multiple constraint flags.
        if selfConstraint.count > 1 {
            for char in selfConstraint {
                let flag = String(char)
                let leftAnchor = Anchor(view: layoutView, anchor: flag)
                var rightAnchor: Anchor?
                if let targetView = targetView {
                    rightAnchor = Anchor(view: targetView, anchor: flag)
                }
                let relation: ConstraintRealtion = (left: leftAnchor, to: rightAnchor, multiplier:computeValue, constant: constant)
                modes.append(generateMode(relation: relation, compareFlag: compareFlag))
            }
        }

        self.decoderCode = modes.map {
            return $0.transform()
        }

    }

    private func generateMode(relation: ConstraintRealtion, compareFlag: String) -> AutoLayoutConstraintMode {
        switch compareFlag {
        case "=":
            return .equal(relation)
        case ">=":
            return .greaterThanOrEqualTo(relation)
        case "<=":
            return .lessThanOrEqualTo(relation)
        default:
            return .equal(relation)
        }
    }

    private func baseValueCode(with flag: String, value: String) -> String {
        switch flag {
        case "-":
            return "-\(value)"
        default:
            return value
        }
    }
}
