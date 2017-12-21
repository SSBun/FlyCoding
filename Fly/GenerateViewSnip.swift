//
//  GenerateViewSnip.swift
//  Fly
//
//  Created by SSBun on 2017/11/9.
//  Copyright © 2017年 SSBun. All rights reserved.
//

import Foundation


class GenerateViewSnip: Snip {
    var label: String
    var code: String
    var lineCount: Int
    var codeType: CodeType
    
    required init?(label: String, spaceCount: Int, codeType: CodeType) {
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
        case "uicollectionview":
            codes = ["let flowLayout = UICollectionViewFlowLayout()",
                     "flowLayout.scrollDirection = <#direction#>",
                     "flowLayout.minimumInteritemSpacing = <#spacing#>",
                     "let \(selfValue) = UICollectionView(frame: <#frame#>, collectionViewLayout: flowLayout)",
                "\(selfValue).showsVerticalScrollIndicator = <#show#>",
                "\(selfValue).showsHorizontalScrollIndicator = <#show#>",
                "\(selfValue).dataSource = self",
                "\(selfValue).delegate = self",
                "\(selfValue).backgroundColor = <#color#>",
                "\(selfValue).register(<#class#>, forCellWithReuseIdentifier: <#id#>)",
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
            self.codeType = codeType
        } else {
            return nil
        }
    }
}

