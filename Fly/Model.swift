//
//  Model.swift
//  Fly Coding
//
//  Created by SSBun on 21/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Foundation

// MARK: - Property
struct Property {
    static let allScopeMark = ["l": "let",
                               "v": "var",
                               "p": "private",
                               "P": "public",
                               "o": "open",
                               "f": "fileprivate",
                               "pl": "private let",
                               "pv": "private var",
                               "Pl": "public let",
                               "Pv": "public var",
                               "ol": "open let",
                               "ov": "open var",
                               "fl": "fileprivate let",
                               "fv": "fileprivate var",
                               "lv": "lazy var"]
    
    static let allSystemMark = ["@": "@objc",
                                "u": "unowned",
                                "w": "weak",
                                "c": "class"]
    
    let className: String
    let scope: String
    let defaultValue: String?
    var lineCount: Int = 1
    var instanceName: String = "<#name#>"
    
    init(className: String, scope: String, defaultValue: String?) {
        self.className = className
        self.scope = scope
        self.defaultValue = defaultValue
        if scope.contains("lazy") {
            self.lineCount = 3
        }
    }
    
    static func scopeWithShortcuts(_ p: String) -> String? {
        if p.count == 0 {return nil}
        var systemMarks = [String]()
        var scopeMark = ""
        for c in p {
            if let mark = allSystemMark[String(c)] {
                systemMarks.append(mark)
            } else {
                scopeMark += String(c)
            }
        }
        systemMarks.append(allScopeMark[scopeMark, default: "let"])
        return systemMarks.joined(separator:" ")
    }
}


// MARK: - Snip

protocol Snip {
    var label: String {get}
    var code: String {get}
    var lineCount: Int {get}
    
    init?(label: String, spaceCount: Int)
}


class BaseSnip: Snip {
    var label: String
    var code: String
    var lineCount: Int
    
    required init?(label: String, spaceCount: Int) {
        let snipList = ["make": GenerateViewSnip.self as Snip.Type,
                        "snpm": SnapSnip.self as Snip.Type]
        guard let mark = regularMatch(text: label, expression: "^[a-zA-Z]+").first else {return nil}
        guard let snipType = snipList[mark] else {return nil}
        guard let snip = snipType.init(label: label, spaceCount: spaceCount) else {return nil}
        self.label = snip.label
        self.code = snip.code
        self.lineCount = snip.lineCount
    }
}


class GenerateViewSnip: Snip {
    var label: String
    
    var code: String
    
    var lineCount: Int
    
    required init?(label: String, spaceCount: Int) {
        guard let paramStr = regularMatch(text: label, expression: "(?<=\\()[_a-zA-Z,]+(?=\\))").first else {return nil}
        let params = paramStr.split(separator: ",")
        guard let viewClassName = params.first, viewClassName.count > 0 else {return nil}
        var selfValue = "<#name#>"
        if params.count > 1 {
            let valueName = params[1]
            if valueName.count > 0 {
                selfValue = String(valueName)
            }
        }
        let repeatCount = Int(regularMatch(text: label, expression: "(?<=\\*)[0-9]+").first ?? "1") ?? 1
        var codes = [String]()
        switch viewClassName.lowercased() {
        case "uiview":
            codes = ["let \(selfValue)  = UIView()",
                     "\(selfValue).backgroundColor = <#color#>",
                     "<#superView#>.addSubview(\(selfValue))"]
        case "uilabel":
            codes = ["let \(selfValue) = UILabel()",
                     "\(selfValue).font = <#font#>",
                     "\(selfValue).textColor = <#color#>",
                     "\(selfValue).text = <#text#>",
                     "\(selfValue).backgroundColor = <#color#>",
                     "<#superView#>.addSubview(\(selfValue))"
                    ]
        case "uibutton":
            codes = ["let \(selfValue) = UIButton()",
                     "\(selfValue).setImage(UIImage(named: <#imageName#>), for: <#UIControlState#>)",
                     "\(selfValue).setTitle(<#T##title: String?##String?#>, for: <#T##UIControlState#>)",
                     "\(selfValue).addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)",
                     "<#superView#>.addSubview(\(selfValue))"
                    ]
        case "uiimageview":
            codes = ["let \(selfValue)  = UIImageView()",
                     "\(selfValue).backgroundColor = <#color#>",
                     "\(selfValue).image = <#image#>",
                     "<#superView#>.addSubview(\(selfValue))"]
        case "uitableview":
            codes = ["let \(selfValue) = UITableView(frame: <#frame#>, style: <#style#>)",
                     "\(selfValue).backgroundColor = <#color#>",
                     "\(selfValue).delegate = <#delegate#>",
                     "\(selfValue).dataSource = <#dataSource#>",
                     "\(selfValue).separatorStyle = <#style#>",
                     "\(selfValue).register(<#class#>, forCellReuseIdentifier: <#identifier#>)",
                     "<#superView#>.addSubview(\(selfValue))"
                    ]
        default:
            codes = []
        }
        
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
            self.lineCount = repeatCount * (codes.count + 1)
        } else {
            return nil
        }
    }
}

class SnapSnip: Snip {
    var label: String
    
    var code: String
    
    var lineCount: Int
    
    required init?(label: String, spaceCount: Int) {
        return nil
    }
    
    
}










































