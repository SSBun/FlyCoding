//
//  Match.swift
//  Fly Coding
//
//  Created by SSBun on 22/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Foundation



public func regularMatch(text: String, expression: String) -> [String] {
    var results = [String]()
    let expression = try! NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
    expression.enumerateMatches(in: text, options: .reportCompletion, range: NSRange(location: 0, length: text.count), using: { (result, _, _) in
        if let result = result {
            let item = (text as NSString).substring(with: result.range)
            results.append(item)
        }
    })
    return results
}

public func regularMatchRange(text: String, expression: String) -> [NSRange] {
    var results = [NSRange]()
    let expression = try! NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
    expression.enumerateMatches(in: text, options: .reportCompletion, range: NSRange(location: 0, length: text.count), using: { (result, _, _) in
        if let result = result {
            results.append(result.range)
        }
    })
    return results
}

public func regularMatchLike(text: String, expression: String) -> Bool {
    let expression = try! NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
    let count = expression.numberOfMatches(in: text, options: .reportCompletion, range: NSRange(location: 0, length: text.count))
    return count > 0
}

public func regularReplace(text: String, expression: String, with template: String) -> String {
    let expression = try! NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
    let result = expression.stringByReplacingMatches(in: text, options: .reportCompletion, range: NSRange(location: 0, length: text.count), withTemplate: template)
    return result
}

public func *(left: String, right: Int) -> String {
    return Array(0..<right).reduce("", { (str, _) -> String in
        return str + " "
    })
}
